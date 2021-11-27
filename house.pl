:- dynamic(isHouse / 1).
:- dynamic(day / 1).

day(0).
isHouse(0).

house :-
    isHouse(y),
    write('What do you want to do?'), nl,
    write('-  sleep'), nl,
    write('-  writeDiary'), nl,
    write('_  readDiary'), nl,
    write('_  exit'), !.

house :-
    write('>> Anda tidak sedang berada di House').
    
sleep :- 
    write('Hari yang melelahkan, waktunya untuk tidur...'), nl,
    nl,
    write('Hoaammmm...'), nl,
    retract(day(X)), Y is X+1,
    asserta(day(Y)),
    write('Sudah hari ke-'), write(Y), write('.'),
    house.

writeDiary :- !.

readDiary :- !.