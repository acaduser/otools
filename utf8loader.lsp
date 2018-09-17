(defun utf8load
	(fn	/
		main dsc lst buff line tmp isUtf8
	)
	(vl-load-com)
	(defun main ()
		(setq b00000000   0)
		(setq b10000000 128)
		(setq b11000000 192)
		(setq b11100000 224)
		(setq b11110000 240)
		(setq b11111000 248)
		(setq str nil)
		(setq tmp nil)
		(setq isUtf8 t)
		(setq dsc (open (findfile fn) "r"))
		(while (setq res (read-line dsc))
			(setq tmp (cons "\n" (cons res tmp)))
		)
		(close dsc)
		(setq tmp (reverse tmp))
		(setq tmp (apply 'strcat tmp))
		(setq lst (vl-string->list tmp))
		(while (and isUtf8 lst)
			(cond
				;1byte
				((= b00000000 (logand b10000000 (car lst))) 
					(setq buff (cons (chr (car lst)) buff))
					(setq lst (cdr lst))
				)
				;
				((= b10000000 (logand b11000000 (car lst))) 
					(setq isUtf8 nil)
				)
				;2byte code
				((= b11000000 (logand b11100000 (car lst))) 
					(setq tmp (list (car lst) (cadr lst)))
					(setq tmp (encoding2 tmp))
					(setq buff (cons tmp buff))
					(setq lst (cddr lst))
				)
				;3byte code
				((= b11100000 (logand b11110000 (car lst)))

					(setq tmp (list (car lst) (cadr lst) (caddr lst)))

					(setq tmp (encoding3 tmp))
					;;(print tmp)
					(setq buff (cons tmp buff))
					(setq lst (cdddr lst))
				)
				;4Byte code
				((= b11110000 (logand b11111000 (car lst)))
					(setq tmp (list (car lst) (cadr lst) (caddr lst) (cadddr lst)))
					(setq tmp (encoding4 tmp))
					(setq buff (cons tmp buff))
					(setq lst (cddddr lst))


				)
				(t
					(setq isUtf8 nil)
				)
			)
		)
		(if isUtf8
			(progn
				(setq buff (reverse buff))
				(eval (read (strcat "(progn" (apply 'strcat buff) ")" )))
			)
			(progn
				(princ "\n can not UCF-8 decoding. using load function.")
				(load fn nil)
			)
		)
		(princ)
	)
	(defun encoding2 (moji)
		(setq bit1-6 (logand (cadr moji) 63))
		(setq bit7-11 (logand (car moji) 31))
		(setq bits (logior (lsh bit7-11 6) bit1-6))
		(strcat "\\u+" (dechex bits))
	)
	(defun encoding3 ( moji )
		(setq bit1-6 (logand (caddr moji) 127))
		(setq bit7-12 (logand (cadr moji) 127))
		(setq bit13-16 (logand (car moji) 15))
		(setq bit1-8 (logior bit1-6 (lsh (logand bit7-12 3) 6)))
		(setq bit9-16 (logior (lsh (logand bit13-16 15) 4) (lsh (logand bit7-12 (+ 4 8 16 32)) -2)))
		(setq bit1-16 (logior (lsh bit9-16 8) bit1-8))

		(strcat "\\u+" (dechex bit1-16))
	)
	(defun encoding4 (moji)
		(setq aaa nil)
		(setq int32 (+ (lsh (car moji) 24)))

		(setq bit1-6 (logand (cadddr moji) 127))
		(setq bit7-12 (logand (caddr moji) 127))
		(setq bit13-18 (logand (cadr moji) 127))
		(setq bit19-21 (logand (car moji) 7))
		(setq int (+ bit1-6 (lsh bit7-12 6) (lsh bit13-18 12) (lsh bit19-21 15)))
		(setq x10000 65536)
		(setq int (- int x10000))

		(setq xD800 55296)
		(setq xDC00 56320)
		(setq utf16hi (+ (lsh int -10) xD800))
		(setq utf16low (+ (logand int 1023)xDC00))

		
		(strcat "\\u+" (dechex utf16hi) "\\u+" (dechex utf16low))

	)
	(defun dechex(num / loop n str)
		(setq loop t str "")
		(while loop
			(setq n (logand num 15))
			(cond
				((<= n 9) (setq n (itoa n)))
				((= n 10) (setq n "A"))
				((= n 11) (setq n "B"))
				((= n 12) (setq n "C"))
				((= n 13) (setq n "D"))
				((= n 14) (setq n "E"))
				((= n 15) (setq n "F"))
			)
			(setq str (strcat n str))
			(setq num (lsh num -4))
			(if (= num 0)(setq loop nil))
		)
		(while (< (strlen str) 4)
			(setq str (strcat "0" str))
		)
		str
	) 
	(main)
)

(defun utf8demandLoad (fileName symList)
	(vl-load-com)
	(demandLoad-varidate symList)
)
(defun demandLoad-varidate(e / fnc)
	(if (= (type e) 'LIST)
		(if (apply 'and (mapcar 'vl-symbolp e))
			(demandLoad-define e)
			(mapcar 'demandLoad-varidate e)
		)
	)
)
(defun demandLoad-define(e /)
	(eval
		(list 'defun (car e) (cdr e)
			(list 'demandLoad-override (vl-princ-to-string e)fileName)
		)
	)
)
(defun demandLoad-override (s f / *error* sym surb ff)
	(defun *error*(s) (princ s)(set sym surb))
	(set 'sym (car (read s)))
	(set 'surb (eval sym))
	(set sym nil)
	(if (setq ff (findfile f))
		(progn
			(princ (strcat "\n" ff ""))
			(if utf8load (utf8load ff)(load ff nil))
			(if (eval sym)
				(eval(append (list sym) (cdr (read s))))
				(progn
					(princ (strcat "\n" (vl-symbol-name(car (read s))) " is not defined in file."))
					(set sym surb)
					(princ)
				)
			)
		)
		(progn
			(princ (strcat "\n" f " have not in support pass."))
			(set sym surb)
			(princ)
		)
	)
)
