(defun c:alignmenttext
	(/
		main *error*
		modify
		doc
	)
	(defun main(/ i ss kw obj ipt apt oldalign align)
		(vl-load-com)
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(princ "\n基点保持文字位置合わせ変更")
		(if (setq ss (ssget  (list (cons 0 "TEXT"))))
			(progn
				(initget "L A F C M R TL TC TR ML MC MR BL BC BR")
				(setq kw
					(getkword
						"[左(L)/中心(C)/中央(M)/右(R)/左上(TL)/中心上(TC)/右上(TR)/左中央(ML)/中央(MC)/右中央(MR)/左下(BL)/中央下(BC)/右下(BR)] <左>:"
					)
				)
				(if (null kw)(setq kw "L"))
				(modify)
			)
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun modify()
		(cond
			((= kw "L")		(setq align acAlignmentLeft))
			((= kw "A")		(setq align acAlignmentAligned))
			((= kw "F")		(setq align acAlignmentFit))
			((= kw "C")		(setq align acAlignmentCenter))
			((= kw "M")		(setq align acAlignmentMiddle))
			((= kw "R")		(setq align acAlignmentRight))
			((= kw "TL")		(setq align acAlignmentTopLeft))
			((= kw "TC")		(setq align acAlignmentTopCenter))
			((= kw "TR")		(setq align acAlignmentTopRight))
			((= kw "ML")		(setq align acAlignmentMiddleLeft))
			((= kw "MC")		(setq align acAlignmentMiddleCenter))
			((= kw "MR")		(setq align acAlignmentMiddleRight))
			((= kw "BL")		(setq align acAlignmentBottomLeft))
			((= kw "BC")		(setq align acAlignmentBottomCenter))
			((= kw "BR")		(setq align acAlignmentBottomRight))
		)
		(setq i 0)
		(while (< i (sslength ss))
			(setq obj (vlax-ename->vla-object (ssname ss i)))
			(setq ipt (vla-get-InsertionPoint obj))
			(setq apt (vla-get-TextAlignmentPoint obj))
			(setq oldalign (vla-get-Alignment obj))
			(if (= align acAlignmentLeft)
				(progn
					(vla-put-Alignment obj align)
					(if
						(or
							(= oldalign acAlignmentLeft)
							(= oldalign acAlignmentAligned)
							(= oldalign acAlignmentFit)
						)
						(vla-put-InsertionPoint obj ipt)
						(vla-put-InsertionPoint obj apt)
					)
					
				)
				(progn
					(vla-put-Alignment obj align)
					(if
						(or
							(= oldalign acAlignmentLeft)
							(= oldalign acAlignmentAligned)
							(= oldalign acAlignmentFit)
						)
						(vla-put-TextAlignmentPoint obj ipt)
					)
				)
			)
			(setq i (1+ i))
		)
	)
	(defun *error*(s)	
		(princ (strcat "\n" s))
		(vla-EndUndoMark doc)
		(princ)
	)
	(apply 'main nil)
)
