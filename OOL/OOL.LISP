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
        (T 
           (add-class-spec class-name (list parents 
                                            (validate-slots slot-value))))))


;; NEW

(defun new (class-name &rest slot-values)
(print slot-values)
(print (second (get-class-spec class-name)))
  (cond ((not (symbolp class-name))
              (error "Class name not valid"))
        ((null (is-class class-name))
         (error "Class does not exist"))
        (T
         (if (find-slots (append
                          (second (get-class-spec class-name))
                          (depth-first-slots class-name))
                         slot-values)
             (append (list 'oolinst class-name (validate-slots slot-values)))
           (error "Slots not valid.")))))


;; cerca che tutti gli slot della lista specificata in new sono effettivamente slots 
;; della classe. Se non li trova allora li cerca tra i parents. 

(defun find-slots (class-slots slots)
  (cond ((null slots) T)
        ((null class-slots) NIL)
        ((if (member (first slots) (first class-slots))
            (find-slots (rest (rest class-slots)) (rest (rest slots)))
          NIL))))


;;; IS-CLASS

(defun is-class (class-name)
  (cond ((not (symbolp class-name))
         (error "Class name not valid!"))
        ((null (get-class-spec class-name)) NIL)
        (T T)))


;;; IS-INSTANCE

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
  (extract-value (car (third instance)) slot-name))


;; <<*

(defun jaghsa (instance &rest slot-name+)
  (cond ((null slot-name+) 
         (error "Slot name is not a valid list."))
        ((= 1 (length slot-name+))
         (<< instance (car slot-name+)))
        (T
         (<< (<< instance (car slot-name+)) (cdr slot-name+)))))


;; verifica se lo slot name è presente tra i parameteri della istanza

(defun extract-value (slots slot-name)
  (cond ((null slots)
         (error "Slot does not exist."))
        (T (if (equalp (first slots) slot-name)
               (second slots)
             (extract-value (rest (rest slots)) slot-name)))))
          


;; verify if all the parents in the list are classes already exists

(defun validate-parents (parents)
  (cond ((null parents) NIL)
        ((not (is-class (first parents))) T)
        (T (validate-parents (rest parents)))))



;; verifico se la lista dei slots è pari. In caso affermativo, creo una associazione tra 
;; slot name e slot

(defun validate-slots (slots)
(print slots)
  (cond ((oddp (length slots))
         (error "Slot list is not complete"))
        ((null slots) slots)
        ((listp (second slots))
         (equalp (first (second slots)) '=>)
         (process-method (first slots) (second slots)))
        #| ((= 2 (length slots))
         (list slots)) |#
        (T
         (if (symbolp (first slots))
             (append (list (list (first slots) (second slots)))
                   (validate-slots (rest (rest slots))))
           (error "Slot name not valid")))))



;;faccio la ricerca depth first dei parents per estrarre gli slot.

(defun depth-first-slots (class)
  (if (null (first (get-class-spec class)))
       (list (second (get-class-spec class)))
     (append (list (second (get-class-spec class))) 
                   (mapcan #'depth-first-slots (first (get-class-spec class))))))


;; metodo per la manipolazione dei metodi

(defun process-method (method-name method-spec)
  (setf (fdefinition method-name) 
        (lambda (this &rest arguments)
          (print "ciao")
          (apply (<< this method-name) (append (list this) arguments))))
  (eval (rewrite-method-code method-name method-spec)))


(defun rewrite-method-code (method-name method-spec)
  (append 
   (list 'lambda) 
   (append (list 'this) (first (rest  method-spec)))
   (rest (rest method-spec))))








