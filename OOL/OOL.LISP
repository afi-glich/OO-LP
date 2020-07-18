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

;; manca da aggiungere la definizione di slot value a cui procedere dopo aver definito tutte le primitive fino a is_instance

(defun define-class (class-name parents &rest slot-values)
  (remove-duplicates parents)
  (cond ((not (symbolp class-name))
             (error "Class name not valid."))
        ((not (listp parents))
             (error "Parents must be a list"))
        ((is-class class-name)
         (error "Class already exists"))
        ((null (validate-parents parents))
         (error "Parents list is not valid"))
        ;; rimuovere inoltre duplicati dalla lista dei parents e ritornare errore se nella lista sono presenti
        ;; classi non definite.
        (T (add-class-spec class-name (list parents)))))


;; NEW

; aggiungere la parte dei slot appena verrà implementata in define class.

(defun new (class-name)
  (cond ((not (symbolp class-name))
              (error "Class name not valid"))
        ((is-class class-name)
         (error "Class does not exist"))
        (T (append (list 'oolinst class-name)))))



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
         (print value))
        (T NIL)))


;; verify if all the parents in the list are classes already exists

(defun validate-parents (parents)
  (cond ((null parents) NIL)
        ((not(is-class (first parents)))
          NIL)
        (T (validate-parents (rest parents)))))


















