(defun c:layoutReOrder(/ *error* main doc lst tmp i)
	(vl-load-com)
	(defun *error*(s)(vla-EndUndoMark doc)(princ s)(princ))
	(setvar "cmdecho" 1)
	(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark doc)
	(vlax-for layout (vla-get-Layouts doc)
		(if (= (vla-get-ModelType layout) ':vlax-false)
			(setq lst (cons (list (vla-get-TabOrder layout) (vla-get-Name layout) (vla-get-Handle layout)) lst))
		)
	)
	(foreach n (mapcar 'cadr (vl-sort lst '(lambda(a b) (< (car a) (car b)))))
		(setq tmp (strcat n "&tmp"))
		(command "layout" "c" n tmp "layout" "d" n "layout" "r" tmp n)
	)
	(vla-EndUndoMark doc)
	(princ)
)
