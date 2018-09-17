(defun c:pviewporttomodel
	(/
		;function
		program newerror olderror 
		getactivespace userinput
		;private
		acapp acdoc acspace acutl aclayt acmspace acmlayout zeropt
		pname bname ss movedcount
	)
	(defun program(/)
		(terpri)
		(princ (strcat"\nビューポート境界をモデル空間に作図"))
		(vl-load-com)
		(setvar "cmdecho" 0)
		(setq olderror *error* *error* newerror)
		(setq acapp (vlax-get-acad-object))
		(setq acdoc (vla-get-activedocument acapp))
		(setq acpspace(vla-get-paperspace acdoc))
		(setq acutl (vla-get-utility acdoc))
		(setq aclayt (vla-get-activelayout acdoc))
		(setq acmspace (vla-get-modelspace acdoc))
		(setq acmlayout (vla-get-layout acmspace))
		(setq zeropt (vlax-3d-point '(0 0 0)))
		(setq movedcount 0)
		(if (= (getvar "tilemode") 0)
			(progn
				(if (= (vla-get-mspace acdoc) ':vlax-true) (vla-put-mspace acdoc ':vlax-false))
				(setq ss (ssget(list(cons 0 "VIEWPORT"))))
				(terpri)
				(if ss
					(progn
						(command "undo" "be")
						(userinput)
						(princ (strcat (itoa movedcount) "個のビューポートをモデル空間に作図しました\n"))
					)
				)
			)
			(princ "\nモデル空間では使用できません")
		)
		(setq *error* olderror)
		(command "undo" "e")
		(princ)
	)
	(defun newerror(s)
		(princ s)(command "undo" "e")(setq *error* olderror)(princ)
	)
	(defun userinput(/ i )
		(setq oldlocklist (pviewalllock))
		(setq i 0)
		(while (< i (sslength ss))
			(setq ename (ssname ss i))
			(setq acpview (vlax-ename->vla-object ename))
			(vla-display acpview ':vlax-true)
			(if (setq linkename (cdr (assoc 340 (entget ename))))
				(modifyclipvp linkename)
				(modifyrecvp acpview)
			)
			(if (>= i (- (sslength ss) 1))
				(progn
					(command "pspace")
					;;(vla-put-mspace acdoc ':vlax-false) ;;改行がなぜか入る
				)
			)

			(setq i (1+ i))
		)
		(pviewalllockrecov oldlocklist)

	)
	(defun pviewalllock(/ acblock alloldlock)
		(setq acblock (vla-get-block aclayt))
		(vlax-for item acblock
			(if (= (vla-get-objectname item) "AcDbViewport")
				(progn
					(setq alloldlock
						(append	alloldlock
							(list (vla-get-displaylocked item))
						)
					)
					(vla-put-displaylocked item ':vlax-true)
				)
			)
		)
		alloldlock
	)
	(defun pviewalllockrecov(alloldlock / acblock i cnt)
		(setq acblock (vla-get-block aclayt))
		(setq i 0 cnt 0)
		(vlax-for item acblock
			(if (= (vla-get-objectname item) "AcDbViewport")
				(progn
					(vla-put-displaylocked item (nth cnt alloldlock))
					(setq cnt (1+ cnt))
				)
			)
			(setq i (1+ i))
		)		
	)
	(defun modifyrecvp(acpview / oldlocklist  ptlist sa coords acpline)
		
		(if (= (vla-get-mspace acdoc) ':vlax-false)
			(vl-catch-all-apply 'vla-put-mspace (list acdoc ':vlax-true))
		)
		(if (= (vla-get-mspace acdoc) ':vlax-true)
			(progn
				(vl-catch-all-apply 'vla-put-activepviewport (list acdoc acpview))
				(setq newacpview (vla-get-activepviewport acdoc))
				(if (= (vla-get-objectid newacpview) (vla-get-objectid acpview))
					(progn
						(setq customscale (vla-get-customscale acpview))
						(setq twist (vla-get-twistangle acpview))
						(setq movedcount (1+ movedcount))
						(setq viewcenter (trans (getvar "viewctr") 1 0))
						(vla-getboundingbox acpview 'minpt 'maxpt)
						
						(setq
							listmin (vlax-safearray->list minpt)
							listmax (vlax-safearray->list maxpt)
						)
						(setq listcenpt (mapcar '(lambda(a b) (/ (+ a b) 2.0)) listmin listmax))
						(setq listbasemin (mapcar '(lambda (a b) (/ (- b a))) listcenpt listmin ))
						(setq listbasemax (mapcar '(lambda (a b) (/ (- b a))) listcenpt listmax ))
						
						(setq ptlist
							(append ptlist
								(list (car listbasemin) (cadr listbasemin))
								(list (car listbasemax) (cadr listbasemin))
								(list (car listbasemax) (cadr listbasemax))
								(list (car listbasemin) (cadr listbasemax))
							)
						)
						(setq sa (vlax-make-safearray vlax-vbdouble '(0 . 7)))
						(setq coords (vlax-safearray-fill sa ptlist))
						(setq acpline(vla-addLightWeightPolyline acmspace coords))
						(vla-put-closed acpline ':vlax-true)
						(vla-scaleentity acpline zeropt (/ 1 customscale))
						(vla-rotate acpline zeropt (* -1 twist))
						(vla-move acpline zeropt (vlax-3d-point viewcenter))

						(princ twist)(terpri)
			 		)
			 		(progn
			 		 	(vla-put-mspace acdoc ':vlax-false)
 						(princ "\nアクティブビューポートに割り当てれません")
			 		)
			 	)
			)
		)
		
	)
	(defun modifyclipvp(linkename / i oldlocklist  ptlist sa coords acpline)
		(setq linkacpline (vlax-ename->vla-object linkename))
		(setq coords (vla-get-coordinates linkacpline))
		
		(if (= (vla-get-mspace acdoc) ':vlax-false)
			(vl-catch-all-apply 'vla-put-mspace (list acdoc ':vlax-true))
		)
		(if (= (vla-get-mspace acdoc) ':vlax-true)
			(progn
				(vl-catch-all-apply 'vla-put-activepviewport (list acdoc acpview))
				(setq newacpview (vla-get-activepviewport acdoc))
				(if (= (vla-get-objectid newacpview) (vla-get-objectid acpview))
					(progn
						(setq customscale (vla-get-customscale acpview))
						(setq twist (vla-get-twistangle acpview))
						(setq movedcount (1+ movedcount))
						(setq viewcenter (trans (getvar "viewctr") 1 0))
						(vla-getboundingbox acpview 'minpt 'maxpt)
						
						(setq
							listmin (vlax-safearray->list minpt)
							listmax (vlax-safearray->list maxpt)
						)
						(setq listcenpt (mapcar '(lambda(a b) (/ (+ a b) 2.0)) listmin listmax))
						(setq ptlist (vlax-safearray->list (vlax-variant-value coords)))
						(setq ptlen (/ (length ptlist) 2))
						
						(setq acpline(vla-addLightWeightPolyline acmspace coords))
						(vla-move acpline (vlax-3d-point listcenpt) zeropt)
						(setq i 0)
						(repeat ptlen
							(vla-setbulge acpline i (vla-getbulge linkacpline i))
							(setq i (1+ i))
						)
						(vla-update acpline)
						(vla-put-closed acpline ':vlax-true)
						(vla-scaleentity acpline zeropt (/ 1 customscale))
						(vla-rotate acpline zeropt (* -1 twist))
						(vla-move acpline zeropt (vlax-3d-point viewcenter))
						
					
			 		)
			 		(progn
			 		 	(vla-put-mspace acdoc ':vlax-false)
 						(princ "\nアクティブビューポートに割り当てれません")
			 		)
			 	)
			)
		)
		
	)

	(defun getactivespace (d / s l)
		(setq l (vla-get-activelayout d))
		(if (=  (vla-get-name l) "Model")
			(setq s (vla-get-modelspace d))
			(if (= (vla-get-mspace d) ':vlax-true)
				(setq s (vla-get-modelspace d))
				(setq s (vla-get-paperspace d))
			)
		)
	)
	(apply 'program nil)
)
