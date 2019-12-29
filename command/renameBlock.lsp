(defun c:renameBlock (/ *error* main doc)
	(vl-load-com)
	(defun main()
		(princ "\nrenameBlock")
		(setvar "cmdecho" 1)
		(vla-StartUndoMark (setq doc (vla-get-ActiveDocument (vlax-get-acad-object))))
		(if
			(and
				(setq pick (entsel "\npick block reference:"))
				(setq ename (car pick))
				(= (cdr (assoc 0 (entget ename))) "INSERT")
			)
			(progn
				(setq bname (cdr (assoc 2 (entget ename))))
				(print bname)
				(setq str (showDialog bname))
				(cond
					((tblobjname "BLOCK" str)
						(progn
							(princ (strcat "\n" str " is already have."))
						)
					)
					(t
						(progn
							(setq f (command "_.rename" "_b"  bname str))
							(princ (strcat "\n" str))
						)
					)
				)
			)
		)
		(vla-EndUndoMark doc)
		(princ)
	)
	(defun showDialog (orgname / init ret newstr)
		(defun init ()
			(if
				(and
					(setq fname (writedcl "renameBlock.dcl"))
					(new_dialog "dlg" (setq id (load_dialog fname)))
				)
				(progn
					(set_tile "userValue" orgname)
					(action_tile "accept" "(OnAccept_Clicked $value)")
					(action_tile "cancel" "(OnCancel_Clicked $value)")
					(setq res (start_dialog))
					(if (= res 1)
						(progn
							(setq ret newstr)
						)
						(progn
							(setq ret nil)
						)
					)
					(unload_dialog id)
				)
			)
		)
		(defun OnAccept_Clicked(e)
			(setq newstr (get_tile "userValue"))
			(done_dialog 1)
		)
		(defun OnCancel_Clicked(e)
			(done_dialog 0)
		)
		(defun writedcl (fn / dsc tempDcl)
			(setq dsc (open (setq tempDcl (strcat  (getvar "tempprefix") fn)) "w"))
			(write-line
				"dlg : dialog
				{
					label = \"renameBlock\";
					initial_focus = \"userValue\";
					: edit_box
					{
						label = \"newstr\";
						key = \"userValue\";
						width = 48;
						is_enabled = true;
						allow_accept = true;
					}  	
					ok_cancel;
				}"
				dsc
			)
			(close dsc)
			tempDcl
		)
		(init)
		ret
	)
	(defun *error*(s)
		(princ s)
		(while (= (getvar "cmdactive") 1) (command))
		(vla-EndUndoMark doc)
		(princ)
	)
	(main)
)
