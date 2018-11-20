(defun c:attdefToText
	(/
		*error* main
		oDoc obj
		enameList owner pick name dist
	)
	(defun main ()
		(vl-load-com)
		(princ "\nattdefToText")
		(setq oDoc (vla-get-ActiveDocument (vlax-get-acad-object)))
		
		(vla-StartUndoMark oDoc)
		(if (setq ss (ssget '((0 . "ATTDEF"))))
			(progn
				(setq i 0)
				(repeat (sslength ss)
					(setq en (ssname ss i))
					(setq obj (vlax-ename->vla-object en))
					(setq text(vla-AddText (getspace oDoc)  (vla-get-TagString obj) (vlax-3d-point '(0 0 0)) (vla-get-Height obj)))
					
					
					(vla-put-Alignment text (setq al (vla-get-Alignment obj)))
					
					(cond
						((= al 0) 
							(vla-put-InsertionPoint text (vla-get-InsertionPoint obj))
						)
						((= al 3)
							(print al)
							(vla-put-InsertionPoint text (vla-get-InsertionPoint obj))
							(vla-put-textalignmentpoint text (vla-get-textalignmentpoint obj))
							(print al)
						)
						((= al 5)
							(print al)
							(vla-put-InsertionPoint text (vla-get-InsertionPoint obj))
							(vla-put-textalignmentpoint text (vla-get-textalignmentpoint obj))
						)
						(t
							 (vla-put-TextAlignmentPoint text (vla-get-TextAlignmentPoint obj))

							 (print al)
						)

					)
					(vla-put-Layer text (vla-get-Layer obj))
					(vla-put-StyleName text (vla-get-StyleName obj))
					(vla-put-TrueColor text (vla-get-TrueColor obj))
					(vla-put-ScaleFactor text (vla-get-ScaleFactor obj))
					(vla-put-Rotation text (vla-get-Rotation obj))
					(vla-put-ObliqueAngle text (vla-get-ObliqueAngle obj))
					(vla-Delete obj)
					
					
					(setq i (1+ i))
				)
			)
		
		)	
		(vla-EndUndoMark oDoc)
		(princ)
	)
	(defun getspace(d)
		(if (and(= (vla-get-ActiveSpace d) 0)(= (vla-get-MSpace d) ':vlax-false))
			(vla-get-Paperspace d)
			(vla-get-ModelSpace d)
		)
	)
	(defun *error*(s)(vla-EndUndoMark oDoc)(princ s))
	(apply 'main nil)
)
