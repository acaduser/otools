(defun c:pviewportlock
	(/
		main vplock *error* doc
	)
	(vl-load-com)
	(defun main()
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(princ "\n全てのビューポートのロック状態変更")
		(initget 0 "Y N")
		(setq kw (getkword "\nキーワードを入力[ロック(Y)/解除(N)]<Y>:"))
		(cond
			((= kw "Y") (vplock 1))
			((= kw "N") (vplock 0))
			(t (vplock 1))
		)
		(princ)
	)
	(defun vplock (lock / layout block ent cnt)
		(vlax-for layout (vla-get-Layouts doc)
			(setq lname (vla-get-Name layout))
			(setq cnt 0)
			(if (/= lname "Model")
				(progn
					(vlax-for ent (vla-get-Block layout)
						(if (= (vla-get-ObjectName ent) "AcDbViewport")
							(progn
								(if (/= cnt 0)
									(progn
										(vla-put-DisplayLocked ent lock)
									)
								)
								(setq cnt (1+ cnt))
							)
						)
					)
					(princ (strcat "\n" lname " " (itoa (- cnt 1)))) 
				)
			)
		)
		(if (= lock 1)
			(princ (strcat "\nビューポートはロックされました。"))
			(princ (strcat "\nビューポートはロック解除されました。"))
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun *error*(s)	
		(princ (strcat "\n" s))
		(vla-EndUndoMark doc)
		(princ)
	)
	(apply 'main nil)
)
