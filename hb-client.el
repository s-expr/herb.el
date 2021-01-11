(require 'xelb)
(require 'hb-utils)
(require 'hb-protocol)
;;would be nice to have traits but this works I guess
(defclass hb:client ()
	((connection :type xcb:connection
							:initform (xcb:connect)
							:initarg :connection
							:protection :private)
	 
	 (-argsa :allocation :class
					 :initarg :args-atom
					 :type xcb:Atom
					 :protection :private)

	 (-outputa :allocation :class
						 :initarg :args-atom
						 :type xcb:Atom
						 :protection :private)

	 (-statusa :allocation :class
						 :type xcb:Atom
						 :protection :private)

	 (last-output :initform nil)

	 (-client-window :type xcb:WINDOW
									 :protection :private)

	 (-root-window :type xcb:WINDOW
								 :protection :private))

	"Class containing representing the active connection to hlwm") 

(hb:client:-create-atom-accessor -argsa hb:atoms:ipc-args)
(hb:client:-create-atom-accessor -outputa hb:atoms:ipc-output)
(hb:client:-create-atom-accessor -statusa hb:atoms:ipc-status)

(defun hb:connect ()
	(let ((client (make-instance 'hb:client)))
		(with-slots (connection -client-window -root-window) client	
			(setf -root-window (hb:-get-root-window connection))
			(let ((wid (xcb:generate-id connection)))
				(setf -client-window wid)
				(xcb:+request connection
						(make-instance 'xcb:CreateWindow
													 :class xcb:WindowClass:InputOutput
													 :wid (xcb:generate-id connection)
													 :parent -root-window
													 :depth 0
													 :border-width 0
													 :x 42
													 :y 42
													 :width 42
													 :height 42
													 :visual 0
													 :value-mask xcb:CW:OverrideRedirect
													 :override-redirect 1))))
		client))
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

(cl-defmethod hb:client:get-output ((client hb:client)))
;save the layout with the windowID's replaced with some sort of
;unique buffer id and rehydrate upon loading the layout?
					 
					 


