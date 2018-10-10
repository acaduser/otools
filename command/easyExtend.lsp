(defun c:easyExtend
	(/
		*error* main coords->3DPtList getspace
		line
	)
	(defun main ()
		(vl-load-com)
		(princ "\n🏹easyExtend")
		(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark doc)
		(setvar "cmdecho" 0)
		(if (setq ss (ssget "_:L" '((0 . "LINE,ARC,LWPOLYLINE") )))
			(progn
				(initget 1)
				(setq pt1 (getpoint "\n1点目指定:"))
				(initget 1)
				(setq pt2 (getpoint pt1 "\n2点目指定:"))
				(setq pt1w (trans pt1 1 0) pt2w (trans pt2 1 0))
				(command "_.layer" "_u" (getvar "clayer") "")
				(setq spc (getspace doc))
				(setq line (vla-AddLine spc (vlax-3d-point pt1w) (vlax-3d-point pt2w)))
				(setq i 0)
				(repeat (sslength ss)
					(setq ename (ssname ss i))
					(setq obj (vlax-ename->vla-object ename))
					;;(setq res (vla-IntersectWith obj line acExtendThisEntity))
					(setq res (vla-IntersectWith obj line acExtendBoth))
					(setq sa (vlax-variant-value res))
					(setq ub (vlax-safearray-get-u-bound  sa 1))
					(if (>= ub 2)
						(progn
							(setq coords (vlax-safearray->list sa))
							(foreach n  (coords->3DPtList coords)
								(command "_.extend" (vlax-vla-object->ename line) "" (list ename (trans n 0 1)) "")
							)
						)
					)
					(setq i (1+ i))
				)
				(vla-Delete line)
			)
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun coords->3DPtList(lst)
		(if lst
			(cons
				(list (car lst) (cadr lst) (caddr lst))
				(coords->3DPtList (cdddr lst))
			)
		)
	)
	(defun getspace(d)
		(if (and(= (vla-get-ActiveSpace d) 0)(= (vla-get-MSpace d) ':vlax-false))
			(vla-get-PaperSpace d)
			(vla-get-ModelSpace d)
		)
	)
	(defun *error*(s)
		(while (= (getvar "cmdactive") 1) (command-s ""))
		(if line (vla-Delete line))
		(princ (strcat s ""))
		(vla-EndUndoMark doc)
		(princ)
	)
	(apply 'main nil)
)
