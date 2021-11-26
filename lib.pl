/* Deklarasi Fakta */

isEmpty([]).
appendList(X,L,[X|L]).

insertAt(A, E, 0, [E|A]). 
/* Deklarasi Rules */ 
insertAt([X|A], E, P, [X|L1]):-
    P > 0,
    P1 is P-1,
    insertAt(A, E, P1, L1), !.

deleteAt([E|A], E, 0, A). 
/* Deklarasi Rules */ 
deleteAt([H|A], E, P, [H|L1]):-
    P > 0,
    P1 is P-1,
    deleteAt(A, E, P1, L1), !.

elmt([X|_], 0, X).
elmt([_|Tail], Idx, X):-
    Idx > 0,
    elmt(Tail, New_Idx, X),
    New_Idx is Idx-1, !.

indexOf([X|_], X, 0).
indexOf([_|Tail], X, Idx):-
    Idx > 0,
    New_Idx is Idx-1,
    indexOf(Tail, X, New_Idx),
    !.


% list pair
printList([]) :- !.
printList([X-Y|[]]) :- write(X), write(' '), write(Y), printList([]),!.
printList([X-Y|Tail]) :-
    write(X), write(' '), write(Y) ,write(','), printList(Tail),!.


