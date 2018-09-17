(defun c:layAllOn(/ doc)
	(vl-load-com)
	(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark doc)
	(acet-layerp-mark t)
	(vlax-for lay (vla-get-Layers doc)
		(vla-put-LayerOn lay ':vlax-true)
	)
	(acet-layerp-mark nil)
	(vla-EndUndoMark doc)
	(princ)
)
(defun c:layAllOff(/ doc)
	(vl-load-com)
	(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark doc)
	(acet-layerp-mark t)
	(vlax-for lay (vla-get-Layers doc)
		(if (= (vla-get-Name lay) (getvar "clayer"))
			(vla-put-LayerOn lay ':vlax-true)
			(vla-put-LayerOn lay ':vlax-false)
		)
	)
	(acet-layerp-mark nil)
	(vla-EndUndoMark doc)
	(princ)
)
(defun c:laySSON
	(/
		*error* main err
		doc ename obj name oLayer
	)
	(defun main()
		(vl-load-com)
		(setq *error* (defun err(s)(princ s)(vla-EndUndoMark doc)(princ)))
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(if (setq ss (ssget))
			(progn
				(setq ssList
					(vl-remove-if-not
						'(lambda(x)	(= (type x) 'ENAME))
						(mapcar 'cadr (ssnamex ss))
					)
				)
				(setq layerList
					(unique(vl-sort (mapcar '(lambda(x) (cdr(assoc 8 (entget x)))) ssList) '<))
				)
				(acet-layerp-mark t)
				(vlax-for oLayer(vla-get-Layers doc)
					(setq name (vla-get-name oLayer))
					(if (not(member name layerList))
						(vla-put-LayerOn oLayer ':vlax-false)
					)
				)
				(acet-layerp-mark nil)		
				(if (< (cdr (assoc 62 (entget (tblobjname "layer" (getvar "clayer"))))) 0)
					(progn
						(setvar "clayer" (car layerlist))
						(princ (strcat "\n現在の画層は " (car layerlist) " に設定されました。"))
					)
				)
				;;(print layerlist)
			)
		)
		
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun unique(lst)
		(append
			(apply
				'append
				(mapcar '(lambda(c d)(if(/= c d)(list c))) lst (cdr lst))
			)
			(list(last lst))
		)
	)
	(defun *error* (s)(princ s)(vla-EndUndoMark doc)(princ))
	(apply 'main nil)
)
(defun c:laySSOff
	(/
		*error* main err
		doc ename obj name oLayer
	)
	(defun main()
		(vl-load-com)
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(if (setq ss (ssget))
			(progn
				(setq ssList
					(vl-remove-if-not
						'(lambda(x)	(= (type x) 'ENAME))
						(mapcar 'cadr (ssnamex ss))
					)
				)
				(setq layerList
					(unique(vl-sort (mapcar '(lambda(x) (cdr(assoc 8 (entget x)))) ssList) '<))
				)
				(acet-layerp-mark t)
				(vlax-for oLayer(vla-get-Layers doc)
					(setq name (vla-get-name oLayer))
					(if (member name layerList)
						(vla-put-LayerOn oLayer ':vlax-false)
					)
				)
				(acet-layerp-mark nil)
			)
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun unique(lst)
		(append
			(apply
				'append
				(mapcar '(lambda(c d)(if(/= c d)(list c))) lst (cdr lst))
			)
			(list(last lst))
		)
	)
	(defun *error* (s)(princ s)(vla-EndUndoMark doc)(princ))
	(apply 'main nil)
)
(defun c:layPickNestOn
	(/
		*error* main
		doc oLayer
		enameList bname pick ename name
	)
	(defun main ()
		(vl-load-com)
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(sssetfirst)
		(vla-StartUndoMark doc)
		(if (setq pick (nentsel "\nオブジェクト選択:"))
			(progn
				(setq ename (car pick))
				(setq enameList (last pick))
				(setq name (cdr (assoc 8 (entget ename))))
				(if (and (= name "0") (= (type (car enameList)) 'ENAME))
					(progn
						(setq bname
							(car
								(vl-remove-if
									'(lambda(x)
										(= (cdr (assoc 8 (entget x))) "0")
									)
									enameList
								)
							)
						)
						(if bname
							(setq name (cdr (assoc 8 (entget bname))))
							(setq name "0")
						)
					)
				)
				(acet-layerp-mark t)
				(vlax-for oLayer(vla-get-Layers doc)
					(if (= (vla-get-name oLayer) name)
						(vla-put-LayerOn oLayer ':vlax-true)
						(vla-put-LayerOn oLayer ':vlax-false)
					)
				)
				(acet-layerp-mark nil)
				(print name)
			)
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun *error*(s)
		(princ s)(vla-EndUndoMark doc)(princ)
	)
	(apply 'main nil)
)
(defun c:layPickNestOff
	(/
		*error* main doc
		enameList owner pick name
	)
	(defun main ()
		(vl-load-com)
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(sssetfirst)
		(vla-StartUndoMark doc)
		(if (setq pick (nentsel "\nオブジェクト選択:"))
			(progn
				(setq enameList (last pick))
				(setq obj (vlax-ename->vla-object (car pick)))
				(setq name (vla-get-Layer obj))
				(if (and (= name "0") (= (vla-get-ObjectName obj) "AcDbAttribute"))
					(setq name (vla-get-Layer (vla-ObjectIDToObject doc (vla-get-OwnerID obj))))
				)
				(if (= name "0")
					(if (= (type (car enameList)) 'ENAME)
						(progn
							(setq owner
								(car
									(vl-remove-if
										'(lambda(x)
											(= (cdr (assoc 8 (entget x))) "0")
										)
										enameList
									)
								)
							)
							(if owner
								(setq name (cdr (assoc 8 (entget owner))))
								(setq name "0")
							)
						)
					)
				)
				(acet-layerp-mark t)
				(vlax-for o (vla-get-Layers doc)
					(if (= (vla-get-Name o) name) (vla-put-LayerOn o ':vlax-false))
				)
				(acet-layerp-mark nil)
				(print name)
			)
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun *error*(s)
		(princ s)(vla-EndUndoMark doc)(princ)
	)
	(apply 'main nil)
)
