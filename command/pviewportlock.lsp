(defun c:pviewportlock
	(/
		main vplock 
		app doc
	)
	(vl-load-com)
	(defun main(/ utl kw olderror newerror)
		(terpri)
		;;(command "undo" "e" "undo" "be")
		(setq olderror *error*)
		(setq *error*
			(defun newerror(s)
				(princ (strcat s))(command "undo" "e")(setq *error* olderror)(princ)
			)
		)
		(setvar "cmdecho" 0)
		(setq app (vlax-get-acad-object))
		(setq doc (vla-get-activedocument app))
		(princ "\n全てのビューポートのロック状態変更")
		(initget 0 "Y N")
		(setq kw(getkword "\nキーワードを入力[ロック(Y)/解除(N)]<Y>:"))(terpri)
		(cond
			((= kw "Y") (vplock 1))
			((= kw "N") (vplock 0))
			(t (vplock 1))
		)
		(setq *error* olderror)
		;;(command "undo" "e")
		(princ)
	)
	(defun vplock(lock / layouts layout block ent oname cnt)
		(setq layouts (vla-get-layouts doc))
		(vlax-for layout layouts
			(setq block (vla-get-block layout))
			(setq lname (vla-get-name layout))
			(setq cnt 0 i 0)
			(if (/= lname "Model")
				(progn
					(vlax-for ent block
						(setq oname (vla-get-objectname ent))
						(if (= oname "AcDbViewport")
							(progn
								;;(vlax-dump-object ent)
								(if (/= cnt 0)
									(progn
										(vla-put-displaylocked ent lock)
										
									)
								)
								(setq cnt (1+ cnt))
							)
						)
					)
					(princ (strcat lname " " (itoa (- cnt 1)) "\n")) 
				)
			)
		)
		(if (= lock 1)
			(princ (strcat "\nビューポートはロックされました．"))
			(princ (strcat "\nビューポートは解除されました．"))
		)
	)
	(apply 'main nil)
)
