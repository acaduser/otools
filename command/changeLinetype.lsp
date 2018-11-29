(defun c:changeLinetype
	(/
		*error* main
		colorDlg entityData
		modifyIndex modifyTrueColor modifyColorBook
		split enList
		oDoc enames 
		ss pick i
	)
	(defun main()
		(vl-load-com)
		(princ "\n✍changeLinetype")
		(setq oDoc (vla-get-ActiveDocument (vlax-get-acad-object)))
		(vla-StartUndoMark oDoc)
		(if (setq ss (ssget "_:L"))
			(progn
				(setq i 0)
				(repeat (sslength ss)	(setq enames (cons (ssname ss i) enames) i (1+ i)))
				(reverse enames)
				(mapcar '(lambda(x) (redraw x 3)) enames)
				(initget " ")
				(setq pick (entsel "\n参考にするオブジェクト選択<ダイアログ>:"))
				(cond
					((= (type pick) 'LIST)
						(setq data (entget (car pick)))
						(if(setq name (cdr (assoc 6 data)))
								(modifyName ss name)
								(modifyName ss "ByLayer")
						)
					)
					((= pick "") 
						(setq res (lineTypeDlg "ByLayer" t))
						(if res (modifyName ss res))
					)
					((null pick)(mapcar '(lambda(x) (redraw x 4)) enames))
				)
			)
		)
		(vla-EndUndoMark oDoc)
		(princ)
	)
	(defun lineTypeDlg(lineType flag / names num id tbl res)
		(setq lineType (strcase lineType))
		(while
			(not
				(setq dsc (open (setq tempDcl (strcat  (getvar "tempprefix") "changeLineType.dcl")) "W"))
			)
		)
		(write-line
			
"lineTypeDlg : dialog {
	label = \"✍線種選択\";
	: column {
		: list_box {
			height = 28;
			width = 40;
			key = \"listbox\";
			allow_accept = true;
		}
	ok_cancel;
	}
}"

			dsc
		)
		(close dsc)
		(if (new_dialog "lineTypeDlg" (setq id (load_dialog tempDcl)))
			(progn
				(action_tile "accept" "(done_dialog 1)")
				(action_tile "cancel" "(done_dialog 0)")
				(action_tile "listbox" "(setq num $value)")
				(if flag (setq names (list "ByLayer" "Byblock")))
				(while (if (null tbl) (setq tbl (tblnext "LTYPE" t)) (setq tbl (tblnext "LTYPE")))
						(setq names (cons (cdr (assoc 2 tbl)) names))
				)
				(setq names (vl-sort names '<))
				(start_list "listbox")
				(mapcar 'add_list  names)
				(end_list)
				(if(vl-member-if '(lambda(x) (= (strcase lineType) (strcase x))) names)
					(setq num (itoa (vl-position lineType (mapcar 'strcase names))))
					(setq num (itoa (vl-position (strcase "Continuous")(mapcar 'strcase names))))
				)
				(set_tile "listbox" num)
				(setq res (start_dialog))
				(unload_dialog id)
			)
		)
		;;(vl-file-delete tempDcl)
		(if (/= res 0)(nth (atoi num) names))
	)
	(defun modifyName(ss e / )
		
		
		(command "_.chprop" ss "" "lt" e "")
		
		(princ (strcat "\n" e))
	)
	(defun *error*(s)
		(mapcar '(lambda(x) (redraw x 4)) enames)
		(vla-EndUndoMark oDoc)
		(princ s)
	)
	(apply 'main nil)
)
