%%%% -*- Mode:Prolog -*-
%%%% OOA.pl

%%%% Membri del gruppo
%%%% Saeed Afifa 835367
%


%%%% Define class (classname, parents, slot value)

define_class(Name, Parents, Slots) :-
    atom(Name),
    remove_duplicates(Parents, NewParents),
    validate_parents(NewParents, ParentsValidated),
    assertz(superclass(ParentsValidated)),
    assertz(class(Name, Slots)).

%%%% rimuove duplicati

remove_duplicates(Parents, NewParents) :-
    sort(Parents, NewParents).

%%%% verifico se la lista dei parents contiene effettivamente dei nomi
%%%% di classi

validate_parents([], []).

validate_parents([X | Rest], [X | ParentsValidated]) :-
    atom(X),
    is_class(X),
    validate_parents(Rest, ParentsValidated).

%%%% new instance (nome_istanza, nome_classe, slot_values) -

new(Instance_name, Class_name) :-
    atom(Instance_name),
    is_class(Class_name),
    assert(instance(Instance_name, Class_name)).


%%%% is class(nome_classe)

is_class(Name) :-
    atom(Name),
    class(Name, _, _).

%%%% is instance
%classname è nome della superclasse
is_instance(Instance_name, Class_name) :-
    instance(Instance_name, Class_name).

is_instance(Instance_name) :-
    is_instance(Instance_name, _).

%%%% inst

inst(Instance_name, Instance) :-
    Instance == instance(Instance_name, _).











