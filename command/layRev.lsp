(defun c:layRev
	(/
		*error*	doc lay
	)
	(vl-load-com)
	(princ "\n画層表示状態反転")
	(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark doc)
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
