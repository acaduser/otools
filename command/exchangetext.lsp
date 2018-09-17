(defun c:exchangeText
	(/
		*error* main
		getObject exchange recovery
		doc
		obj1 obj2
	)
	(defun main()
		(vl-load-com)
		(princ "\n文字内容交換")
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(if
			(and
				(setq obj1 (getObject (entsel "\n交換元文字選択:")))
				(setq obj2 (getObject (entsel "\n交換先文字選択:")))
			)
			(exchange obj1 obj2)
		)
		(vla-EndUndoMark doc)
		(if obj1 (vla-Update obj1))
		(if obj2 (vla-Update obj2))
		(princ)
	)
	(defun getObject(res / obj ret name)
		(if (= (type res) 'LIST)
			(progn
				(setq obj (vlax-ename->vla-object (car res)))
				(setq name (vla-get-ObjectName obj))
				(cond
					((= name "AcDbBlockReference")
						(setq res (nentselp  "" (cadr res)))
						(setq obj (vlax-ename->vla-object (car res)))
						(setq name (vla-get-ObjectName obj))
						(if (= name "AcDbAttribute")
							(setq ret obj)
						)
					)
					((= name "AcDbText")
						(setq ret obj)
						(vla-Highlight obj ':vlax-true)
					)
				)
			)
		)
		ret
	)
	(defun exchange(a b / tmp)
		(setq tmp (vla-get-TextString a))
		(vla-put-TextString a (vla-get-TextString b))
		(vla-put-TextString b tmp)
	)
	
	(defun *error* (s)
		(princ s)
		(if obj1 (vla-Update obj1))
		(if obj2 (vla-Update obj2))
		(vla-EndUndoMark doc)
	)

	(apply 'main nil)
)
