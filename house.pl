:- dynamic(day / 1).

day(1).

house :-
    playerLoc(X,Y),
    tile(X,Y,house),
    write('What do you want to do?'), nl,
    write('-  sleep'), nl,
    write('-  exit'), nl,
    nl,
    write('>> '), read(COMMAND),
    house_choice(COMMAND), !.

house :-
    write('Anda tidak sedang berada di House !').
    
house_choice(sleep) :- 
    playerLoc(X,Y),
    tile(X,Y,house),
    retract(day(TODAY)), TOMORROW is TODAY+1,
    asserta(day(TOMORROW)),
    write('Hari yang melelahkan, waktunya untuk tidur...'), nl,
    nl,
    random(1,4,Z),
    (
        Z =:= 1, peri;
        write('Hoaammmm...'), nl,
        write('Sudah hari ke-'), write(TOMORROW), write('.'),
        nl, nl, house
    ), !.

house_choice(sleep) :-
    write('Anda tidak sedang berada di hehe !').

house_choice(exit).

peri :-
    write('Tadi malam kamu bermimpi bertemu dengan peri tidur, dan sekarang kamu punya kemampuan untuk teleportasi'),nl,
    write('Mau kemana kamu ingin berteleportasi?'), nl,
    write('1. Special Location'), nl,
    write('2. Coordinate'), nl,
    nl,
    write('>> '),
    read(A), nl,
    (A=:=1, 
        write('- marketplace\n'),
        write('- ranch\n'),
        write('- quest\n'), nl,
        write('>> '), read(PLACE), nl,
        tile(X1,Y1,PLACE),
        retract(playerLoc(_,_)),
        asserta(playerLoc(X1,Y1)),
        write('Anda berhasil teleport ke '), write(PLACE);
    A=:=2, 
        teleport
    ).
    
teleport :- 
    write('Absis >> '), read(X),
    write('Ordinat >> '), read(Y),
    nl,
    cektile(Y,X,RES),
    (RES =:= 0,
        write('Masukan anda salah !! Masukkan koordinat dengan benar !!'), nl,
        nl,
        teleport
        ;
    RES =:= 1,
        retract(playerLoc(_,_)),
        asserta(playerLoc(Y,X)),
        write('Anda berhasil teleport ke ('), write(X), write(','), write(Y), write(')')
    ). 

cektile(X,Y,RES) :-
    tile(X,Y,water), RES is 0, !.

cektile(X,Y,RES) :-
    tile(X,Y,_), RES is 1, !.

cektile(_,_,0).