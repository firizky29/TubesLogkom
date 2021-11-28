:- dynamic(day / 1).

day(0).

house :-
    playerLoc(X,Y),
    tile(X,Y,house),
    write('What do you want to do?'), nl,
    write('-  sleep'), nl,
    write('-  writeDiary'), nl,
    write('_  readDiary'), nl,
    write('_  exit'), !.

house :-
    write('Anda tidak sedang berada di House !').
    
sleep :- 
    playerLoc(X,Y),
    tile(X,Y,house),
    retract(day(TODAY)), TOMORROW is TODAY+1,
    asserta(day(TOMORROW)),
    write('Hari yang melelahkan, waktunya untuk tidur...'), nl,
    nl,
    random(0,4,X),
    (
        X =:= 4, peri;
        write('Hoaammmm...'), nl,
        write('Sudah hari ke-'), write(Y), write('.'),
        house
    ), !.

sleep :-
    write('Anda tidak sedang berada di House !').

peri :-
    write('Tadi malam kamu bermimpi bertemu dengan peri tidur, dan sekarang kamu punya kemampuan untuk teleportasi, mau kemana anda ingin berteleportasi?'),
    write('(dalam koordinat)'),
    
    nl, 
    
    nl,
    write('Absis >> '), read(X),
    write('Ordinat >> '), read(Y),
    retract(playerLoc(_,_)),
    asserta(playerLoc(X,Y)). 
    

/*
writeDiary :- !.

readDiary :- !.
*/