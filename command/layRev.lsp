(defun c:layRev (/ *error* doc)
	(vl-load-com)
	(princ "\nlayRev")
	(vla-StartUndoMark (setq doc (vla-get-ActiveDocument (vlax-get-acad-object))))
	(acet-layerp-mark t)
	(vlax-for lay (vla-get-Layers doc)
		(if (= (vla-get-LayerOn lay) ':vlax-true)
			(vla-put-LayerOn lay ':vlax-false)
			(vla-put-LayerOn lay ':vlax-true)
		)
	)
	(acet-layerp-mark t)
	(vla-EndUndoMark doc)
	(princ)	
)
