
Saeed Afifa 835367

	--------

Estensione Object-Oriented di Lisp - OOL

Il codice prevede la definizione di classi, la creazine di istanze ad esse associate, recuperare i valori dei slot di una data istanza e l'esecuzione dei metodi definiti istanze e classi.

Le primitive implementate a tal scopo sono:

1. (define-class <class-name> <parents> <slot-values>)

	verifica se claas-name è un nome già in uso e se parents è una lista valida. Se si va a manipolare la lista dei slot-values in modo da create una association list che contiene tutti gli slot. Va nel frattempo a inizializzare e processare il metodo, se eventualmente presente in slot-values. Infine crea la clsse tramite hash-tbale definita globalmente.
	Parents ammette anche lista vuota, mentre slot-values no.


2. (new <class-name> <slot-values>)

	Controlla se class-name è una classe, altrimenti genera errore. 
	Successivo verifa se la lista degli slot-values è valida: se ogni slot-name presente nella lista è definito in nella class-name o in una delle sue superlcassi. Nel caso la lista degli slot-values non sia valida, viene generato un errore; altrimenti si procede alla creazione della association list e successivamente creazione della istanza.

3. (is-class <class-name>)
	
	Restituisce T se class-name è una classe.

4. (is-instance <value> <class-name>)

	Restituisce T se value è un istanza della classe class-name.
	Classname è un parametero opzionale. Nel caso non venga specificato il suo valore, di default viene impostato T.


5. (<< <instance>, <slot-name>)

	instance rappresenta un istanza mentre slot-name è un simbolo.
	Restituisce il valore associato a slot-name nell'istanza. Nel caso non esista slot-name per l'istanza, genera errore.

6. (<< <instance> <slot-name>+)

	Slot-name contiene nomi di slot definiti in quell'istanza. Nel caso almeno un slot-name risultasse non presente nella lista degli slot dell'istanza, genera errore.
	<<* applica << seguendo una catena, applicando il risultato della ultima computazione di << al successivo valore di slot-name in lista.