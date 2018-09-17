(defun c:extEditor
	(/
		*error* main
		doc txtFile lst
	)
	(defun main()
		(vl-load-com)
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(if (setq ss (ssget "_:L" '((0 . "TEXT"))))
			(progn 
				(setq i 0)
				(repeat (sslength ss)
					(setq lst (cons (ssname ss i) lst))
					(setq i (1+ i))
				)
				(setq lst (reverse lst))
				
				(initget "U D R L C")
				(setq res (getkword "\nソート方法を選択[上から(U)/下から(D)/右から(R)/左から(L)/文字数とコード複合(C)]<選択順>:"))
				(setq key res)
				;;(print key)
				(cond
					((= key "L")
						(setq lst (vl-sort lst   
								'(lambda(a b)									
									(< (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))
								)
							)
						)
					)
					((= key "R")
						(setq lst (vl-sort lst 
								'(lambda(a b)									
									(> (cadr (assoc 10 (entget a))) (cadr (assoc 10 (entget b))))
								)
							)
						)
					)
					((= key "D")
						(setq lst (vl-sort lst 
								'(lambda(a b)									
									(< (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))
								)
							)
						)
					)
					((= key "U")
						(setq lst (vl-sort lst 
								'(lambda(a b)									
									(> (caddr (assoc 10 (entget a))) (caddr (assoc 10 (entget b))))
								)
							)  
						)
					)
					((= key "C")
						(setq lst (vl-sort lst 
								'(lambda(a b)									
								(< (length (vl-string->list (cdr (assoc 1 (entget a))))) (length (vl-string->list (cdr (assoc 1 (entget b))))))
									
									
								)
							)
						)
						(setq lst (vl-sort lst 
								'(lambda(a b)									
									
									(< (cdr (assoc 1 (entget a))) (cdr (assoc 1 (entget b))))
									
								)
							)
						)
					)
					((null key)
						(princ "\n選択順")
					)
				)
				
				
				(setq path (vl-filename-directory (vl-filename-mktemp)))
				;;(princ (strcat "\n"  path))

				(setq txtFile (strcat (vl-filename-directory (vl-filename-mktemp)) "\\extEditor.txt"))

				(princ (strcat "\n" txtFile))

				
				(setq dsc (open txtFile "w"))
				(foreach ename lst
					(write-line (cdr (assoc 1 (entget ename))) dsc)
				)
				(close dsc)
				(startapp "notepad" (strcat " \"" txtFile "\""))	
				(getkword "\n外部ファイル保存終了後Enter")
				(setq dsc (open txtFile "r"))
				
				(foreach ename lst
					(setq str (read-line dsc))
					;;(print str)
					(if (/= str nil)
						(progn
							(entmod (subst (cons 1 str) (assoc 1 (entget ename )) (entget ename)))
							
						)
					)
				)
				
				(close dsc)
			)
		) 
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun *error*(s)
		(princ s)
		(vla-EndUndoMark doc)
		(princ)
	)
	(main)
)
