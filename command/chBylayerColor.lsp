(defun c:chBylayerColor
	(/
		main *error* 
		doc ename name index
	)
	(defun main()
		(vl-load-com)
		(princ "\n選択オブジェクトの画層色を変更する。")
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(if
			(and	
				(setq ss (ssget))
				(setq index (acad_colordlg 7 nil))
			)
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
						(vla-put-color oLayer index)
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
			(apply 'append (mapcar '(lambda(c d)(if(/= c d)(list c))) lst (cdr lst)))
			(list(last lst))
		)
	)
	(defun *error*(s)
		(vla-EndUndoMark doc)
		(princ s)
	)
	(apply 'main nil)
)
