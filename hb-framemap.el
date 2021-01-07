
(defclass hb:framemap (map hb:client)
	((-framemap :protection :private)))


(cl-defmethod hb:set-frame ((map hb:framemap) frame-cons))

(cl-defmethod hb:get-frame ((map hb:framemap) frame-id))

(cl-defmethod hb:del-frame ((map hb:framemap) frame-id))

