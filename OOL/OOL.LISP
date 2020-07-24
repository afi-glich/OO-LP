;;; Saeed Afifa 835367


#| definisco struttura dati per la memorizzaione e manipolazione
 globale delle classi. |#

(defparameter *classes-specs* (make-hash-table))

(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec) name)

(defun get-class-spec (name)
  (gethash name *classes-specs*))

;;;; DEFINIZIONE DI TUTTE LE PRIMITIVE DEL PROGRAMMA 



;;; DEFINE CLASS

(defun define-class (class-name parents &rest slot-value)
  (cond ((not (symbolp class-name))
             (error "Class name is not a symbol."))
        ((not (listp parents))
             (error "Parents must be a list"))
        ((is-class class-name)
         (error "There is already a class named ~S" class-name))
        ;; verifico se tutti i parents sono classi già definite
        ((validate-parents parents)        
         (error "Parents list is not valid"))
        (T ;;aggiungo la lista dei parents e gli slot manipolati 
           ;;alla classe
           (add-class-spec class-name (list
                                       parents 
                                       (validate-slots slot-value))))))


;;; NEW

(defun new (class-name &rest slot-values)
  (cond ((not (symbolp class-name))
              (error "Class name must be a symbol."))
        ((null (is-class class-name))
         (error "Class does not exist"))
        (T
         #| creo una lista con append che conterrà gli slot definiti dalla scale
            + quelli definiti dalle superclassi per controllare che slot-values
            contenga solo slot già precedentemente definiti|#
         (if (find-slots
              (depth-first-slots class-name)
              slot-values)
             ;;aggiungo la nuova istanza alla lista delle istanze.
             (append (list 'oolinst class-name (validate-slots slot-values)))
           (error "One or more slots are not defined.")))))


;;; IS-CLASS

(defun is-class (class-name)
  (cond ((not (symbolp class-name))
         (error "Class name must be a symbol!"))
        ((null (get-class-spec class-name)) NIL)
        (T T)))


;;; IS-INSTANCE

(defun is-instance (value &optional (class-name T))
  (cond ((not (eql (first value) 'oolinst))
         (error "Value is not an instance."))
        ((eql class-name T) T)
        ((eql (second value) class-name) T)
        (T nil)))

;;; <<

(defun << (instance slot-name)
  (extract-value (append
                  (validate-slots (car (third instance)))
                  (depth-first-slots (second instance))) slot-name))

;; <<*

(defun <<* (instance &rest slot-name+)
  (cond ((null slot-name+) 
         (error "Slot name can not be empty."))
        ((= 1 (length slot-name+))
         (<< instance (car slot-name+)))
        (T
         (<< (<< instance (car slot-name+)) (cdr slot-name+)))))


;; cerca che tutti gli slot della lista specificata in new sono effettivamente slots 
;; della classe. Se non li trova allora li cerca tra i parents. 

;;; new-slot è la lista degli slot definita dalla new che stiamo verificando
;;; classes-slots è la lista di tutti gli slot della classe e relative superclassi

(defun find-slots (classes-slots new-slots)
  ;; se lista vuota, non serve alcuna ricerca
(print "qui")
  (cond ((null new-slots) T)
        ;; se classes-slots vuota, ma new-slots no allora non tutti
        ;; slot sono presenti nella classe/superclasse
        ((null classes-slots) NIL)
        ;; cerca se il primo elemento di new-slots è presente is classes-slots 
        ;; se non presente, termina la ricerca per tuttp il resto degli slots
        ((if (is-member (first new-slots) classes-slots) 
            (find-slots classes-slots (rest new-slots))))
          NIL))


(defun is-member (slot-name slots)
(print "anche qui")
(print slot-name)
(print slots)
  (cond ((null slots) nil)
        ((listp (first slots))
         (member slot-name (first slots)) T)
        (T (is-member slot-name (rest slots)))))

;; verifica se lo slot name è presente tra i parameteri della istanza

(defun extract-value (slots slot-name)
(print slots)
(print slot-name)
  (cond ((null slots)
         (error "Slot does not exist."))
        (T (if (member slot-name (first slots))
               (second (first slots))
             (extract-value (rest slots) slot-name)))))

;; verify if all the parents in the list are classes already exists

(defun validate-parents (parents)
  (cond ((null parents) NIL)
        ((not (is-class (first parents))) T)
        (T (validate-parents (rest parents)))))


;; verifico se la lista dei slots è pari. In caso affermativo, creo una associazione tra 
;; slot name e slot

(defun validate-slots (slots)
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
  (cond ((null (first (get-class-spec class)))
         (second (get-class-spec class)))
        (T (if (listp (second (get-class-spec class)))
               (append (second (get-class-spec class)) 
                       (mapcan #'depth-first-slots (first (get-class-spec class))))
             (append (list (second (get-class-spec class))) 
                       (mapcan #'depth-first-slots (first (get-class-spec class))))))))


;; funzione per la manipolazione dei metodi

;;; Funzione principale gestione metodi, ritorna un eval di una lambda
(defun process-method (method-name method-spec)
  (if (symbolp method-name)
      (setf (fdefinition method-name)
            (lambda (this &rest arguments)
              (apply (<< this method-name)
                     (append (list this) arguments))))
    (eval (rewrite-method-code method-name method-spec)))
(print "qua1"))


(defun rewrite-method-code (method-name method-spec)
(print method-spec)
(print "cc")
(append
 (list 'lambda) (list
  (list 'this) 
  (first (rest method-spec))
 (rest (rest method-spec))))
)



