(require 'xelb)

(require 'hb-utils)
(require 'hb-protocol)


;;would be nice to have traits but this works I guess
(defclass hb:client ()
	((connection :type xcb:connection
							 :initform (xcb:connect)
							 :protection :private)
	 
	 (-argsa :allocation :class
					 :type xcb:ATOM
					 :protection :public)

	 (-outputa :allocation :class
						 :type xcb:ATOM
						 :protection :public)

	 (-statusa :allocation :class
						 :type xcb:ATOM
						 :protection :public)

	 (last-output :initform nil)

	 (-client-window :allocation :class
									 :type xcb:WINDOW
									 :protection :private)

	 (-root-window :type xcb:WINDOW
								 :protection :private))
	"Class containing representing the active connection to hlwm.") 

(defun hb:connect ()
	(let ((client (make-instance 'hb:client))
				(parent (hb:-curframe-wid)))
		(hb:client:-fetch-unset-slot
		 client -argsa hb:atoms:ipc-args)
		(hb:client:-fetch-unset-slot
		 client -statusa hb:atoms:ipc-status)
		(hb:client:-fetch-unset-slot
		 client -outputa hb:atoms:ipc-output)
		(with-slots (connection
								 -client-window
								 -root-window) client
			(xcb:icccm:init connection)
			(setf -root-window (hb:get-root-window connection))
			;;(setf -client-window (hb:spawn-ipc-window connection parent))
			client)))

;;destroy the client window
(cl-defmethod hb:disconnect ((client hb:client))
	(with-slots (connection -client-window) client
		(xcb:+request connection
				(make-instance 'xcb:DestroyWindow
											 :window -client-window)))
	(xcb:disconnect connection)) 
			


;;returns alist containing return code and value
(cl-defmethod hb:send-command ((client hb:client) cmds))

;;something to interface with attributes,
;;perhaps it returns an alist instead of text
;;and perhaps it takes an alist so we can set
;;the properties of multiple attrs simultaneously
(cl-defmethod hb:get-attr ((client hb:client) attr))

(cl-defmethod hb:set-attr ((client hb:client) attr))
;;need something that converts some datastructure
;;into foo.bar.baz

(cl-defmethod hb:client:get-output ((client hb:client)))
;;save the layout with the windowID's replaced with some sort of
;;unique buffer id and rehydrate upon loading the layout?

(cl-defmethod hb:client:-fetch-atom ((client hb:client) atom-name)
	(with-slots (connection) client
		(slot-value (xcb:+request-unchecked+reply connection
										(make-instance 'xcb:InternAtom
																	 :only-if-exists 0
																	 :name-len (length atom-name)
																	 :name atom-name))
								'atom)))

(defmacro hb:client:-fetch-unset-slot (client slot atom-name)
	`(unless (slot-boundp ,client (quote ,slot))
		 (with-slots (,slot) ,client
			 (setf ,slot (hb:client:-fetch-atom ,client ,atom-name)))))

(defun hb:-curframe-wid ()
	(string-to-number
	 (frame-parameter
		(selected-frame) 'window-id)))
