(defun c:grip(/	ss )
	(or
		(setq ss (cadr (ssgetfirst)))
		(setq ss (ssget))
		(setq ss (ssget "p"))
	)
	(sssetfirst nil ss)
	(princ)
)
