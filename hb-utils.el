
(defconst hb:-frame-alist )

(defun hb:-on-new-frame (framem)
	(when-let ((frame-id (frame-parameter frame 'outer-window-id)))
		(
	
(add-hook #'hb:-on-new-frame 'server-after-make-frame-hook)
(add-hook #'hb:-on-new-frame 'after-make-frame-hook)
