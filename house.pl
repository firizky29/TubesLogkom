:- dynamic(day / 1).

% Penyimpananan save

:- dynamic(save/1).
:- dynamic(day/2).
:- dynamic(plantData/6).
:- dynamic(fishListGenerator/2).
:- dynamic(inventory/4).
:- dynamic(playerLoc/3).
:- dynamic(tile/4).
:- dynamic(listOfEmptyTile/2).
:- dynamic(animal_buy/4).
:- dynamic(playerExp/3).
:- dynamic(money/2).
:- dynamic(questTarget/3). 
:- dynamic(questTargetItem/3). 
:- dynamic(questProgress/3).
:- dynamic(animal_count/3).
:- dynamic(animal_production/3).
:- dynamic(playerEnergy/2).
:- dynamic(drainedEnergy/2).
:- dynamic(stock/3).

day(1).
save([]).

house :-
    playerLoc(X,Y),
    tile(X,Y,house),
    write('What do you want to do?'), nl,
    write('-  sleep'), nl,
    write('-  writeDiary'), nl,
    write('-  readDiary'), nl,
    write('-  exitProgram'), !.

house :-
    write('Anda tidak sedang berada di House !').
    
sleep :- 
    playerLoc(X,Y),
    tile(X,Y,house),
    retract(day(TODAY)), TOMORROW is TODAY+1,
    asserta(day(TOMORROW)),
    write('Hari yang melelahkan, waktunya untuk tidur...'), nl,
    nl,
    playerEnergy(Energy),
    playerLevel(total, Level),
    En is Level*100,
    retract(playerEnergy(_)),
    asserta(playerEnergy(En)),
    random(1, 10, Rand),
    (
        Rand > 9,
        restock, !;
        !
    ),
    random(1,4,Z),
    (
        Z =:= 1, 
        write('Sudah hari ke-'), write(TOMORROW), write('.'), 
        peri;
        write('Hoaammmm...'), nl,
        write('Sudah hari ke-'), write(TOMORROW), write('.'),
        nl, nl, nl
    ), 
    fatigue(Energy),
    failGame(TOMORROW), !.

house_choice(sleep) :-
    write('Anda tidak sedang berada di rumah!').

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

show_save([]).

show_save([H|T]) :-
    write('-  Day '), write(H), nl,
    show_save(T).

isEmpty([]).

isMember(_, [], 0).

isMember(Day, [Day|_], 1) :- !.

isMember(Day, [_|T], RES) :- isMember(Day, T, RES).

writeDiary :-
    nl,
    save(List),
    day(Day),
    (isMember(Day, List, 1),
        retractall(plantData(Day,_,_,_,_,_)),
        retractall(fishListGenerator(Day,_)),
        retractall(inventory(Day,_,_,_)),
        retractall(playerLoc(Day,_,_)),
        retractall(tile(Day,_,_,_)),
        retractall(listOfEmptyTile(Day,_)),
        retractall(animal_buy(Day,_,_,_)),
        retractall(playerExp(Day,_,_)),
        retractall(money(Day,_)),
        retractall(questTarget(Day,_,_)), 
        retractall(questTargetItem(Day,_,_)), 
        retractall(questProgress(Day,_,_)),
        retractall(animal_count(Day,_,_)),
        retractall(animal_production(Day,_,_)),
        retractall(playerEnergy(Day, _)),
        retractall(drainedEnergy(Day, _)),
        retractall(stock(Day, _,_))
    ;
        append(List, [Day], NewList),
        retract(save(_)),
        asserta(save(NewList))
    ),
    forall(plantData(A1,A2,A3,A4,A5), asserta(plantData(Day,A1,A2,A3,A4,A5))),
    forall(fishListGenerator(B), asserta(fishListGenerator(Day,B))),
    forall(inventory(C1,C2,C3), asserta(inventory(Day,C1,C2,C3))),
    forall(playerLoc(D1,D2), asserta(playerLoc(Day,D1,D2))),
    forall(tile(E1,E2,E3), asserta(tile(Day,E1,E2,E3))),
    forall(listOfEmptyTile(F), asserta(listOfEmptyTile(Day,F))),
    forall(animal_buy(G1,G2,G3), asserta(animal_buy(Day,G1,G2,G3))),
    forall(playerExp(H1,H2), asserta(playerExp(Day,H1,H2))),
    forall(money(I), asserta(money(Day,I))),
    forall(questTarget(K1,K2), asserta(questTarget(Day,K1,K2))),
    forall(questTargetItem(L1,L2), asserta(questTargetItem(Day,L1,L2))),
    forall(questProgress(M1,M2), asserta(questProgress(Day,M1,M2))),
    forall(animal_count(N1,N2), asserta(animal_count(Day,N1,N2))),
    forall(animal_production(O1,O2), asserta(animal_production(Day,O1,O2))),
    forall(playerEnergy(En), asserta(playerEnergy(Day, En))),
    forall(drainedEnergy(Dr), asserta(drainedEnergy(Day, Dr))),
    forall(stock(Items, Stock), asserta(stock(Day, Items, Stock))),
    retract(save(_)),
    asserta(save(NewList)),
    write('Game anda telah tersimpan pada diary ! Tetap semangat !'), nl,
    !.

readDiary :- 
    nl,
    save(List),
    isEmpty(List),
    write('Diary anda masih kosong !'),
    !.

readDiary :-
    nl,
    save(List),
    write('Daftar Diary anda : '), nl,
    show_save(List),
    write('Anda ingin mengulang pada hari ke ? ketik \'exit\' untuk keluar '), nl,
    nl,
    write('>> '), read(Day), nl,
    (Day == exit
        ;
     (isMember(Day, List, 1),
        loadData(Day)
        ;
        write('Masukkan day yang sudah ada simpan !!'),
        readDiary),
        write('Berhasil memuat save game anda ! \nSekarang adalah hari ke-'), write(Day), nl
    ),
    !.

loadData(Day) :-
    
    % retract all
    retractall(day(_)),
    retractall(plantData(_,_,_,_,_)),
    retractall(fishListGenerator(_)),
    retractall(inventory(_,_,_)),
    retractall(playerLoc(_,_)),
    retractall(tile(_,_,_)),
    retractall(listOfEmptyTile(_)),
    retractall(animal_buy(_,_,_)),
    retractall(playerExp(_,_)),
    retractall(money(_)),
    retractall(questTarget(_,_)), 
    retractall(questTargetItem(_,_)), 
    retractall(questProgress(_,_)),
    retractall(animal_count(_,_)),
    retractall(animal_production(_,_)),
    retractall(playerEnergy(_)),
    retractall(drainedEnergy(_)),
    retractall(stock(_, _)),
    
    % assert all
    
    asserta(day(Day)),
    forall(plantData(Day,A1,A2,A3,A4,A5), asserta(plantData(A1,A2,A3,A4,A5))),
    forall(fishListGenerator(Day,B), asserta(fishListGenerator(B))),
    forall(inventory(Day,C1,C2,C3), asserta(inventory(C1,C2,C3))),
    forall(playerLoc(Day,D1,D2), asserta(playerLoc(D1,D2))),
    forall(tile(Day,E1,E2,E3), asserta(tile(E1,E2,E3))),
    forall(listOfEmptyTile(Day,F), asserta(listOfEmptyTile(F))),
    forall(animal_buy(Day,G1,G2,G3), asserta(animal_buy(G1,G2,G3))),
    forall(playerExp(Day,H1,H2), asserta(playerExp(H1,H2))),
    forall(money(Day,I), asserta(money(I))),
    forall(questTarget(Day,K1,K2), asserta(questTarget(K1,K2))),
    forall(questTargetItem(Day,L1,L2), asserta(questTargetItem(L1,L2))),
    forall(questProgress(Day,M1,M2), asserta(questProgress(M1,M2))),
    forall(animal_count(Day,N1,N2), asserta(animal_count(N1,N2))),
    forall(animal_production(Day,O1,O2), asserta(animal_production(O1,O2))),
    forall(playerEnergy(Day,En), asserta(playerEnergy(En))),
    forall(drainedEnergy(Day, Dr), asserta(drainedEnergy(Dr))), 
    forall(stock(Day, Items, Stock), asserta(stock(Items, Stock))),
    !.

fatigue(Energy):-
    playerLevel(total, Level),
    Energy< 25*Level,
    retract(drainedEnergy(X)),
    X_new is X+Level*2,
    asserta(drainedEnergy(X_new)),
    write('\nOh No, due to the excessive work yesterday, you will drain your energy a little bit faster today\n'), !.

fatigue(_):-
    retract(drainedEnergy(_)),
    asserta(drainedEnergy(2)), !.