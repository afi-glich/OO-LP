
Saeed Afifa 835367

	---------

Estensione Ojbect-Oriented di Prolog - OOP

Il codice prevede la defizione di classi, la creazione di istanze ad esse associate, recuperare i valori dei slot di una data istanza e l'esecuzione di metodi definiti in istanze.

Le primitive implementate a tal scopo sono:

1. define-class(<class-name>, <parents>, <slot-values>)

	Ha come input, banalmente, il nome da associare alla claase, la lista delle superclassi dalle quali eredita metodi e/o valori e infine una lista di slots definita "chiave-valore".
	Il predicato rimuove i duplicati dalla lista dei parents e verifica che siano tutte classi già esistenti (fallisce in caso contrario), e associa ogni parent alla classe nel modo seguente:

		superclass(class-name, parent).

	Allo stesso modo associa ciascuna coppia chiave-valore in slot-valuesa alla classe nel modo seguente:

		slot_value_in_class(class-name, slot-name, slot-value).

	Ogni associazione viene aggiunta alla base di conoscenza per mezzo di assertz.

2.
	1. new(<istance-name>, <class-name>, <slot-values>)

	Ha come input il nome dell'istanza, la classe di cui è istanza e una serie di valori dell'istanza.
	Il predicato si preoccupa di verificare che la class-name rappresenti una classe già definita. (altrimenti fallisce)
	Viene creata la nuova istanza nel modo seguente:

		instance_of(instance-name, class-name)

	In seguito, verifica se ciasun slot-name presente in slot-valules è definito nella classe che rappresenta l'istanza e/o in una superclasse dell'istanza. (altrimenti fallisce).
	Associa quindi l'istanza alla singola coppia di valori nel seguente modo:

		slot_value_in_instance(instance-name, slot-name, slot-value)

	Ogni associazione viene aggiunta alla base di conoscenza per mezzo di assertz.

	2. new(<instance-name>, <class-name>)

	Fa ricorso al predicato new/3 con terzo parametro = [].

3. is_class(<class-name>)

	se class-name è una classe presente nella base di conoscenza, ha successo. Altrimenti fallisce.

4. 
	1. is_instance(<value>, <class-name>)

	Il predicato verifica se value, inteso in questa implementazione come nome con il quale l'istanza è stata aggiunta alla base, rappresenta un'istanza.
	Ha quindi successo se se solo se class-name è una superclasse della classe di cui value è istanza.

	2. is_instance(<value>)

	Il funzionamento varia a seconda dei casi: 

	Ha successo se value, inteso in questa implementazione come nome con il quale l'istanza è stata aggiunta alla base, rappresenta un'istanza.


5. inst(<instance-name>, <istance>)
	
	Il predicato ha successo se instanze-name rappresenta l'istanza instance.


6. slot(<instance>, <slot-name>, <result>)

	Verifica dapprima se instance è il nome di una istanza già esistente e poi ricerca lo slot e restituisce il valore ad esso associato. Fallisce se instance non è un istanza e/o se slot-name non è uno slot esistente.

7. slotx(<instance>, <slot-names>, <result>)

	Resituisce in result il risultato dell'applicazione a catena di slot.
	Ovvero, 

		slot(instance, first-slot-name, result), 
	
	result viene usato come chiamata successiva a slot:
	
			slot(result, second-slot-name, result)

	e via dicendo...