%%%% -*- Mode:Prolog -*-
%%%% OOA.pl

%%%% Membri del gruppo
%%%% Saeed Afifa 835367
%

:- dynamic class/1.
:- dynamic superclass/2.
:- dynamic slot_value_in_class/3.
:- dynamic instance_of/2.
:- dynamic slot_value_in_instance/3.

%%%% Define class (className, parents, slot value)
%



define_class(ClassName, Parents, SlotValues) :-
    atom(ClassName),
    remove_duplicates(Parents, NewParents),
    associate_superclasses(ClassName, NewParents),
    assertz(class(ClassName)),
    associate_slots_to_class(ClassName, SlotValues).


associate_superclasses(_, []).

associate_superclasses(ClassName, [ParentClass | Parents]) :-
    is_class(ParentClass),
    assertz(superclass(ClassName, ParentClass)),
    associate_superclasses(ClassName, Parents).


associate_slots_to_class(_, []).

associate_slots_to_class(ClassName, [Slot | Slots]) :-
    extract_slot_data(Slot, SlotName, Value),
    atom(SlotName),
    assertz(slot_value_in_class(ClassName, SlotName, Value)),
    associate_slots_to_class(ClassName, Slots).

%%%% rimuove duplicati

remove_duplicates(Parents, NewParents) :-
    sort(Parents, NewParents).

%%%% verifico se la lista dei parents contiene effettivamente dei nomi
%%%% di classi

validate_parents([], []).

validate_parents([X | Parents], [X | ParentsValidated]) :-
    atom(X),
    is_class(X),
    validate_parents(Parents, ParentsValidated).

% new che prende in ingresso solo due parametri

new(InstanceName, ClassName) :-
    new(InstanceName, ClassName, []).

%%%% new instance (nome_istanza, nome_classe, slot_values) -

new(InstanceName, ClassName, SlotValues) :-
    atom(InstanceName),
    is_class(ClassName),
    assertz(instance_of(InstanceName, ClassName)),
    findall(Superclasses, superclass(ClassName, Superclasses),
            Set),
    associate_slots_to_instance(InstanceName, SlotValues,
                               [ClassName | Set]).

/* get_all_slots([], SlotNames).

get_all_slots([S | Superclasses], [Set | SlotNames]) :-
    findall(Slots, slot_value_in_class(S, Slots, _), Set),
    get_all_slots(Superclassese, SlotNames).
*/


associate_slots_to_instance(_, [], _).

associate_slots_to_instance(InstanceName, [Slot | SlotValue],
                           Superclasses) :-
    extract_slot_data(Slot, SlotName, Value),
    atom(SlotName),
    is_defined_slot(SlotName, Superclasses),
    assertz(slot_value_in_instance(InstanceName, SlotName,
                                   Value)),
    associate_slots_to_instance(InstanceName, SlotValue, Superclasses).

is_defined_slot(SlotName, [Class | _]) :-
    slot_value_in_class(Class, SlotName, _), !.

is_defined_slot(SlotName, [_ | Superclasses]) :-
    is_defined_slot(SlotName, Superclasses).

% verifico se un dato slot è presente nella definizione della classe o
% della superclasse. Per farlo bisogna trovare tramite findall tutti gli
% elementi della lista nella classe dell'istanza e in più cercare anche
% nei parents.
%

extract_slot_data(Slot, SlotName, Value) :-
    Slot =.. Slot_data,
    nth0(1, Slot_data, SlotName),
    nth0(2, Slot_data, Value).


%%%% is class(nome_classe)

is_class(ClassName) :-
    atom(ClassName),
    class(ClassName).

%%%% is instance
%classname è nome della superclasse

% nel caso fosse un simbolo

is_instance(Value) :-
    atom(Value),
    instance_of(Value, _).


is_instance(Value, ClassName) :-
    instance_of(Value, Class),
    superclass(Class, ClassName).

%%%% inst

inst(InstanceName, Instance) :-
   Instance = instance_of(InstanceName, _).


%%%% slot

slot(InstanceName, SlotName, Result) :-
    atom(SlotName),
    instance_of(InstanceName, _),
    slot_value_in_instance(InstanceName,
                           SlotName,
                           Result).


%%%% slotx
% applico slot all'istanza e al primo SlotNametrovato. Poi il risultato
% lo applico ricorsivamente al secondo elemento, ovvero:
% slot(risultato1, slot, risultato2).
%

slotx(InstanceName, [SlotName], Result) :-
    slot(InstanceName, SlotName, Result).

slotx(InstanceName, [First | SlotNames],
      Result) :-
    instance_of(InstanceName, _),
    slot(InstanceName, First, PartialResult),
    slotx(PartialResult, SlotNames, Result).
