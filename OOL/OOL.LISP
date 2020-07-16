;;;; Membri del gruppo


;; definisco struttura dati per la memorizzaione globale delle classi.
(defparameter *classes-specs* (make-hash-table))

(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec))

(defun get-class-spec (name)
  (gethash name *classes-specs*))

;;;; DEFINIZIONE DI TUTTE LE PRIMITIVE DEL PROGRAMMA 

;; DEFINE CLASS

; manca da aggiungere la definizione di slot value a cui procedere dopo aver definito tutte le primitive fino a is_instance

(defun define-class (class-name parents)
  (cond ((not (symbolp class-name))
             (error "Class name not valid."))
        ((not (listp parents))
             (error "Parents must be a list"))
        ;; qui aggiungere un contollo per verificare che non esiste una classe con questo nome (usando is_class)
        ;; rimuovere inoltre duplicati dalla lista dei parents e ritornare errore se nella lista sono presenti
        ;; classi non definite.
        ((add-class-spec class-name (list parents)) 
         class-name)))

;; correggere perché deve restituire class-name e non la lista dei parents


;; NEW

; aggiungere la parte dei slot appena verrà implementata in define class.

(defun new (class-name)
  (cond ((not (symbolp class-name))
              (error "Class name not valid"))
        (T (append (list 'oolinst class-name)))))

; verifico se il class-name passato come parametro è una classe esistente con is_class


;;; IS-CLASS

(defun is-class (class-name)
  (cond ((not (symbolp class-name))
         (error "Class name not valid!"))
        ((eql class-name (get-class-spec class-name))
         (error "Class found"))
        (T (error "Class does not exist"))))
       

























