
;(defconst hb:-frame-alist )

;(defun hb:-on-new-frame (framem)
;	(when-let ((frame-id (frame-parameter frame 'outer-window-id)))
;		(
	
;(add-hook #'hb:-on-new-frame 'server-after-make-frame-hook)
;(add-hook #'hb:-on-new-frame 'after-make-frame-hook)

(defmacro hb:client:-create-atom-accessor (slot atom-name)
	`(cl-defgeneric ,slot ((client hb:client))
		 (with-slots ((atom ,slot) (conn connection)) client
				 (unless (atom)
					 (setf atom (xcb:+request-unchecked+reply conn
													(make-instance 'xcb:InternAtom
																				 :only-if-exists t
																				 :name-len (length ,atom-name)
																				 :name ,atom-name)))
					 atom))))


(cl-defmethod hb:-get-root-window ((conn xcb:connection))
	(slot-value (car (slot-value
										(xcb:get-setup conn) 'roots))
							'root))

(provide 'hb-utils)
