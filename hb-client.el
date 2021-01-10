(require 'xelb)

;;would be nice to have traits but this works I guess
(defclass hb:client ()
	((connecton :type xcb:connection
							:initform (xcb:connect)
							:initarg :connection
							:protection :private)
	 
	 (-argsa :allocation :class
					 :type xcb:Atom

					 :protection :private)

	 (-outputa :allocation :class
						 :type xcb:Atom
						 :protection :private)

	 (-statusa :allocation :class
						 :type xcb:Atom
						 :protection :private)

	 (last-output :initform nil)

	 (-client-list :initform nil
								 :allocation :class
								 :protection :private)

	 (-client-window :type xcb:Window
									:protection :public)

	 (-root-window :type xcb:Window
								:protection :public))

	"Class containing representing the active connection to hlwm") 

(defmacro hb:client:create-atom-accessor (slot atom-name)
	`(cl-defgeneric ,slot ((client hb:client))
		 (with-slots ((atom ,slot)
									(conn connection))
				 (unless (atom)
					 (setq atom (xcb:+request-unchecked+reply conn
													(make-instance 'xcb:InternAtom
																				 :only-if-exists t
																				 :name-len (length ,atom-name)
																				 :name ,atom-name)))
					 atom))))

(hb:client:create-atom-accessor '-argsa hb:atoms:ipc-args)
(hb:client:create-atom-accessor '-outputa hb:atoms:ipc-output)
(hb:client:create-atom-accessor '-statusa hb:atoms:ipc-status)

(defun hb:connect ()
	(let ((client (make-instance 'hb:client)))
		(with-slots ())))
;create the window, set the atoms
;ensure that atoms are set for ipc
	
;destroy the client window
(cl-defmethod hb:disconnect ((client hb:client)))

;returns alist containing return code and value
(cl-defmethod hb:send-command ((client hb:client) cmds))

;;something to interface with attributes,
;;perhaps it returns an alist instead of text
;;and perhaps it takes an alist so we can set
;;the properties of multiple attrs simultaneously
(cl-defmethod hb:get-attr ((client hb:client) attr))


(cl-defmethod hb:set-attr ((client hb:client) attr))
;;need something that converts some datastructure
;;into foo.bar.baz

;save the layout with the windowID's replaced with some sort of
;unique buffer id and rehydrate upon loading the layout?
					 
					 

