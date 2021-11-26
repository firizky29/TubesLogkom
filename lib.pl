/* Deklarasi Fakta */
length([], 0).
 
/* Deklarasi Rules */ 
length([A|B], X):-
    length(B, X1),
    X is X1+1, !.

isEmpty([]).
appendList(X,L,[X|L]).

insertAt(A, E, 1, [E|A]). 
/* Deklarasi Rules */ 
insertAt([X|A], E, P, [X|L1]):-
    P > 1,
    P1 is P-1,
    insertAt(A, E, P1, L1), !.

elmt([X|_], 0, X).
elmt([_|Tail], Idx, X):-
    Idx > 0,
    elmt(Tail, New_Idx, X),
    New_Idx is Idx-1, !.

indexOf([X|Tail], X, 1).
indexOf([H|Tail], X, Idx):-
    New_Idx is Idx-1,
    indexOf(Tail, X, New_Idx),
    !.


% list pair
printList([]) :- !.
printList([X-Y|[]]) :- write(X), write(' '), write(Y), printList([]),!.
printList([X-Y|Tail]) :-
    write(X), write(' '), write(Y) ,write(','), printList(Tail),!.


