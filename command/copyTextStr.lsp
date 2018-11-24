(defun c:copyTextStr
	(/
		*error* main doc modifymany modifysingle recovery secondinput
		ret bobj sobj hobj 
	)
	(defun main()
		(vl-load-com)
		(princ "\ncopyTextStr")
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(setq ret (entsel "\n参考にするオブジェクト選択:"))
		(if (= (type ret) 'LIST)
			(progn
				(setq bobj (vlax-ename->vla-object (car ret)))
				(setq hobj bobj)
				(if (= (vla-get-ObjectName bobj) "AcDbBlockReference")
					(progn
						(setq ret (nentselp "\nnent" (cadr ret)))
						(setq nobj (vlax-ename->vla-object (car ret)))
						(if
							(or
								(= (vla-get-ObjectName nobj) "AcDbText")
								(= (vla-get-ObjectName nobj) "AcDbAttribute")
							)
							(setq bobj nobj)
						)
					)
				)
				(if
					(or	
						(= (vla-get-ObjectName bobj) "AcDbText")
						(= (vla-get-ObjectName bobj) "AcDbMText")
						(= (vla-get-ObjectName bobj) "AcDbAttribute")
						(= (vla-get-ObjectName bobj) "AcDbAlignedDimension")
						(= (vla-get-ObjectName bobj) "AcDbRotatedDimension")
					)
					(progn
						(vla-Highlight hobj ':vlax-true)
						(initget "M")
						(setq ret (entsel "\n変更するオブジェクト選択:"))
						(cond
							((= (type ret) 'LIST)
								(setq sobj (vlax-ename->vla-object (car ret)))
								(if (= (vla-get-ObjectName sobj) "AcDbBlockReference")
									(progn
										(setq ret (nentselp "" (cadr ret)))
										(setq nobj (vlax-ename->vla-object (car ret)))
										;;(print (vla-get-objectname nobj))
										(if
											(or
												;(= (vla-get-ObjectName nobj) "AcDbText")
												(= (vla-get-ObjectName nobj) "AcDbAttribute")
											)
											(setq sobj nobj)
										)
										
									)
								)
								(cond
									(
										(or
											(= (vla-get-ObjectName bobj) "AcDbText")
											(= (vla-get-ObjectName bobj) "AcDbMText")
											(= (vla-get-ObjectName bobj) "AcDbAttribute")
										)
										;;(setq bstr (vla-get-TextString bobj))
										(setq bstr (cdr (assoc 1 (entget (vlax-vla-object->ename bobj)))))
									)
									(
										(or
											(= (vla-get-ObjectName bobj) "AcDbAlignedDimension")
											(= (vla-get-ObjectName bobj) "AcDbRotatedDimension")
										)
										(setq bstr (vla-get-TextOverride bobj))
									)
								)
								(cond
									(
										(or
											(= (vla-get-ObjectName sobj) "AcDbText")
											(= (vla-get-ObjectName sobj) "AcDbMText")
											(= (vla-get-ObjectName sobj) "AcDbAttribute")
										)
										(vla-put-TextString sobj bstr)
									)
									(
										(or
											(= (vla-get-ObjectName sobj) "AcDbAlignedDimension")
											(= (vla-get-ObjectName sobj) "AcDbRotatedDimension")
										)
										(vla-put-TextOverride sobj bstr)
									)
								)
							)
						)
					)
				)
			)
		)
		(if hobj (vla-Update hobj))
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun *error*(s)
		(if hobj (vla-Update hobj))
		(princ s)
		(vla-EndUndoMark doc)
		(princ)
	)
	(main)
)
