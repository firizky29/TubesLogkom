
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