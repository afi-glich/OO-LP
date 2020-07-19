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

(defun define-class (class-name parents &rest slot-values)
  (remove-duplicates parents)
  (cond ((not (symbolp class-name))
             (error "Class name not valid."))
        ((not (listp parents))
             (error "Parents must be a list"))
        ((is-class class-name)
         (error "Class already exists"))
        ((validate-parents parents)
         (error "Parents list not valid"))
        (T
         (let (valori (validate-slots slot-values))
         (add-class-spec class-name (list parents valori))))))


;; NEW

; mettere il controllo per verificare che i slot selezionati sono parte della definizione della classe.
;; passi da swguire: 
;; 1) estrarre la lista degli slot dalla defizione di classe
;; 2) cercare i slot interessati e nel caso venga trovato anche uno solo non conforme, ritornare errore.

(defun new (class-name &rest slot-values)
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


