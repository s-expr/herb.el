(require 'xelb)
(require 'xcb-icccm)
(require 'hb-protocol)

;; 
(cl-defmethod hb:lock ((connection xcb:connection) parent)
	"Lock (disable all events)."
	(xcb:+request connection
			(make-instance 'xcb:ChangeWindowAttributes
										 :window parent
										 :value-mask xcb:CW:EventMask
										 :event-mask xcb:EventMask:NoEvent))
	(xcb:flush connection))

(cl-defmethod hb:unlock ((connection xcb:connection) parent)
	"Lock (disable all events)."
	(xcb:+request connection
			(make-instance 'xcb:ChangeWindowAttributes
										 :window parent
										 :value-mask xcb:CW:EventMask
										 :event-mask (eval-when-compile
                                   (logior xcb:EventMask:SubstructureRedirect
                                           xcb:EventMask:StructureNotify))))
	(xcb:flush connection))

(cl-defmethod hb:get-root-window ((connection xcb:connection))
	(slot-value (car (slot-value
										(xcb:get-setup connection) 'roots))
							'root))

(cl-defmethod hb:get-emacs-parent-window ((connection xcb:connection))
	(make-instacen))

(cl-defmethod hb:spawn-ipc-window ((connection xcb:connection) parent)
	(let ((wid (xcb:generate-id connection)))
		(unless (parent)
			(error "Cannot spawn client without an active parent window"))
		(hb:lock)
		(xcb:+request connection
				(make-instance 'xcb:CreateWindow
											 :class xcb:WindowClass:InputOutput
											 :wid wid
											 :parent parent
											 :depth 0
											 :border-width 0
											 :x 42
											 :y 42
											 :width 42
											 :height 42
											 :visual 0
											 :event-mask xcb:EventMask:PropertyChange
											 :value-mask xcb:CW:OverrideRedirect
											 :override-redirect 1))
		;; ensure class and name of window are set
		;; so that we can ensure herbst establishes
		;; a connection
		(xcb:+request connection
				(make-instance 'xcb:icccm:set-WM_NAME
											 :data hb:const:herbst-ipc-class))
		(xcb:+request connection
				(make-instance 'xcb:icccm:set-WM_CLASS
											 :data hb:const:herbst-ipc-class))
		(hb:unlock)
		wid))

(provide 'hb-utils)
