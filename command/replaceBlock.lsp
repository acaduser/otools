(defun c:replaceBlock (/ *error* main doc)
	(vl-load-com)
	(defun main ()
		(princ "\nreplaceBlock")
		(vla-StartUndoMark (setq doc (vla-get-ActiveDocument (vlax-get-acad-object))))
		(if (setq ss (ssget "_:L" '((0 . "INSERT"))))
			(progn
				(initget " ")
				(setq pick (entsel "\nSelect<dialog>:"))
				;(print pick)
				(cond
					((= (type pick) 'LIST)
						(setq ename (car pick))
						(if (= (cdr (assoc 0 (entget ename))) "INSERT")
							(progn
								(setq bname (cdr (assoc 2 (entget ename))))
								(cond
									((wcmatch bname "~`**")
										(excute ss bname)
										(print bname)
									)
									(t
										(print bname)
										(princ "\nno change.")
									)
								)
							)
						)
					)
					((or (= pick "") (= (getvar "errno") 52))
						(if (setq res (showDialog)) 
							(progn
								(setq bname res)
								(excute ss bname)
								(print bname)
							)
						)
					)
				)
			)
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun excute (ss bn / i data)
		(setq i 0)
		(repeat (sslength ss)
			(setq en (ssname ss i))
			(setq data (entget en))
			(setq data (subst (cons 2 bn) (assoc 2 data) data))
			(entmod data)
			(entupd en)
			(setq i (1+ i))
		)
	)
	(defun showDialog (/ names num id tbl res)
		(setq dsc (open (setq dcl (strcat  (getvar "tempprefix") "replaceBlock.dcl")) "w"))
		(write-line
			(strcat
				"dlg : dialog\n"
				"{"
				"	label = \"replaceBlock\";\n"
				"	: list_box"
				"	{"
				"		height = 16;"
				"		width = 32;"
				"		key = \"listbox\";"
				"		allow_accept = true;"
				"	}"
				"	ok_cancel;"
				"}"
			)
			dsc
		)
		(close dsc)
		(setq tbl (tblnext "BLOCK" t))
		(while tbl
			(setq name (cdr (assoc 2 tbl)))
			(if (and (wcmatch name "~`**") (wcmatch name "~*|*"))
				(setq names (cons name names))
			)
			(setq tbl (tblnext "BLOCK"))
		)
		(setq id (load_dialog dcl))
		(new_dialog "dlg" id)
		(action_tile "accept" "(done_dialog 1)")
		(action_tile "cancel" "(done_dialog 0)")
		(action_tile "listbox" "(setq num $value)")
		(setq names (vl-sort names '<))
		(start_list "listbox")
		(mapcar 'add_list  names)
		(end_list)
		(setq num "0")
		(set_tile "listbox" num)
		(setq res (start_dialog))
		(unload_dialog id)
		(if (/= res 0) (nth (atoi num) names))
	)
	(defun *error*(s)
		(princ s)
		(vla-EndUndoMark doc)
		(princ)
	)
	(main)
)
