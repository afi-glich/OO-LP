;;;; Membri del gruppo


;;;; definisco struttura dati per la memorizzaione e manipolazione
;;;; globale delle classi.
(defparameter *classes-specs* (make-hash-table))

(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec) name)

(defun get-class-spec (name)
  (gethash name *classes-specs*))

;;;; DEFINIZIONE DI TUTTE LE PRIMITIVE DEL PROGRAMMA 

;; DEFINE CLASS

(defun define-class (class-name parents &rest slot-value)
  (cond ((not (symbolp class-name))
             (error "Class name not valid."))
        ((not (listp parents))
             (error "Parents must be a list"))
        ((is-class class-name)
         (error "Class already exists"))
        ((validate-parents parents)
         (error "Parents list not valid"))
        (T (print (validate-slots (car slot-value)))
           (add-class-spec class-name (list parents 
                                            (validate-slots (car slot-value)))))))


;; NEW

(defun new (class-name &rest slot-values)
(print slot-values)
(print (second (get-class-spec class-name)))
  (cond ((not (symbolp class-name))
              (error "Class name not valid"))
        ((null (is-class class-name))
         (error "Class does not exist"))
        (T
         (if (find-slots (second (get-class-spec class-name)) slot-values)
             (append (list 'oolinst class-name (validate-slots (car slot-values))))
           (error "Slots not valid.")))))

;; cerca che tutti gli slot della lista specificata in new sono effettivamente slots 
;; della classe. Se non li trova allora li cerca tra i parents. 

(defun find-slots (class-slots slots)
  (cond ((null slots) T)
        ((null class-slots) NIL)
        ((if (member (first (first slots)) (first class-slots))
            (find-slots (rest (rest class-slots)) (rest (rest slots)))
          NIL))))


;;; IS-CLASS

(defun is-class (class-name)
  (cond ((not (symbolp class-name))
         (error "Class name not valid!"))
        ((null (get-class-spec class-name)) NIL)
        (T T)))


;;; IS-INSTANCE

;;; da rivedere per capire come ricercare i parametri già creati in precedenza.

(defun is-instance (value &optional (class-name T))
  (cond ((eql class-name T)
        (if (not (eql (first value) 'oolinst))
            nil
          T))
        (T (if (and (eql (first value) 'oolinst)
                    (eql (second value) class-name))
               T
             nil))))


;; <<

(defun << (instance slot-name)
  (find-s (car (third instance)) slot-name))



;; verifica se lo slot name è presente tra i parameteri della istanza

(defun find-s (slots slot-name)
  (cond ((null slots)
         (error "nessun parametro trovato nell'istanza"))
        (T (if (equalp (first slots) slot-name)
               (second slots)
             (find (rest (rest slots)) slot-name)))))
           



;; verify if all the parents in the list are classes already exists

(defun validate-parents (parents)
  (cond ((null parents) NIL)
        ((not (is-class (first parents)))
         T)
        (T (validate-parents (rest parents)))))


;; verifico se la lista dei slots è pari. In caso affermativo, creo una associazione tra 
;; slot name e slot

(defun validate-slots (slots)
  (cond ((oddp (length slots))
         (error "Slot list is not complete"))
        ((= 2 (length slots))
         (append (list (list (first slots) (second slots)))))
        (T
         (if (symbolp (first slots))
             (append (list (list (first slots) (second slots)))
                   (validate-slots (rest (rest slots))))
           (error "Slot name not valid")))))


