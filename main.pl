:- include('lib.pl').
:- include('map.pl').
:- include('item.pl').
:- include('player.pl').
:- include('quest.pl').
% :- include('farming.pl').
:- include('market.pl').
:- include('fishing.pl').
% :- include('ranching.pl').
:- include('house.pl').


:- dynamic(gameState / 1). /* gameState(isGameOn/Off) */
:- dynamic(inGameState/1).

gameState(0).
inGameState(0).

turnOnGame :-
    retract(gameState(_)),
    asserta(gameState(1)), !.

inGameOn:-
    retract(inGameState(_)),
    asserta(inGameState(1)), !.

/* Rule */
startGame :-
    gameState(0),
    write('    _   _                           _          _'), nl,
    write('   | | | | __ _ _ ____   _____  ___| |_    ___| |_  __ _ _ __'), nl,
    write('   | |_| |/ _` | \'__\\ \\ / / _ \\/ __| __|  / __| __|/ _` | \'__|'), nl,
    write('   |  _  | (_| | |   \\ V /  __/\\__ \\ |_   \\__ \\ |_| (_| | |'), nl,
    write('   |_| |_|\\__,_|_|    \\_/ \\___||___/\\__|  |___/\\__|\\__,_|_|'), nl,
    nl,
    write('I Got Scammed By My Client And Have to Restart My Life As A Farmer'), nl,
    nl,
    write('           A Farmers Life is Not That Bad, I Think'), nl,
    nl,
    write('=================================================================='), nl,
    nl,
    write('                   Welcome to Harvest Star!'), nl,
    nl,
    write('>> Type \'start\' to start the game'),
    nl,
    turnOnGame, !.
    
startGame :-
    write('\nYou\'re currently in game! you can\'t start what has been started\n'), !.

start :- 
    gameState(1),
    inGameState(0),
    write('\n=================================================================\n'),
    write('you just got scammed by your client and have a huge debt :(, you decided to work on your grandpa\'s farm\n'),
    write('On this farm there are three main jobs that you can choose (your choice determines the specialty you will get): \n'),
    write('1. Fisherman\n'),
    write('2. Farmer\n'),
    write('3. Rancher\n\n'),
    write('Select from 1 to 3: '),
    read(Idx),
    initPlayer(Idx), 
    printRole(Idx),
    initMap,
    inGameOn,
    !.

start :-
    gameState(1),
    inGameState(1),
    write('\nYou\'re currently in game! you can\'t start what has been started\n'), !.

start :-
    gameState(0),
    write('\nyou need to type \'startGame\' first before actually play the game\n'), !.


help :-
    gameState(0),
    write('\ntype \'startGame\' to start the game\n'), !.

help :-
    inGameState(0),
    write('\ntype \'start\' if you wish to play the game\n'), !.

help :-
    write('this is your list of commands, have fun!'), nl,
    write('=================================================================\n'),
    write('1.  map          : '), nl,
    write('2.  w            : '), nl,
    write('3.  a            : '), nl,
    write('4.  s            : '), nl,
    write('5.  d            : '), nl,
    write('6.  market       : '), nl,
    write('7.  house        : '), nl,
    write('8.  ranch        : '), nl,
    write('9.  fish         : '), nl,
    write('10. dig          : '), nl,
    write('11. plant        : '), nl,
    write('12. harvest      : '), nl,
    write('13. inventory    : '), nl,
    write('14. status       : '), !.


status :-
    inGameState(1),
    write('this is your current status, keep up your good work and have fun!\n'),
    write('=================================================================\n'),
    playerRole(Role),
    roleDisplay(Role, PlayerRole),
    playerLevel(total, Level),
    playerLevel(fish, FishLevel),
    playerLevel(ranch, RanchLevel),
    playerLevel(farm, FarmLevel),
    playerExp(total, Exp),
    playerExp(fish, FishExp),
    playerExp(ranch, RanchExp),
    playerExp(farm, FarmExp),
    reqexp(total, Level, ReqExp),
    money(Gold),

    write('Job              : '), write(PlayerRole), nl,
    write('Level            : '), write(Level), nl,
    write('Farming level    : '), write(FarmLevel), nl,
    write('Farming Exp      : '), write(FarmExp), nl,
    write('Fishing level    : '), write(FishLevel), nl,
    write('Fishing Exp      : '), write(FishExp), nl,
    write('Ranching level   : '), write(RanchLevel), nl,
    write('Ranching Exp     : '), write(RanchExp), nl,
    write('Exp              : '), write(Exp), write('/'), write(ReqExp), nl,
    write('Gold             : '), write(Gold), nl, !.

status :-
    inGameState(0),
    write('\nwhat status? You haven\'t started the game yet\n'), !.


w :- 
    inGameState(0),
    write('you haven\'t started the game yet!'), !.

w :-
    playerLoc(X, _),
    (X =:= 1),
    write('You can\'t go beyond borders'), nl, !.

w:-
    playerLoc(X, Y),
    X1 is X-1,
    tile(X1, Y, water),
    write('You can\'t swim, can you? stop playing around!'), nl, !.

w:- 
    playerLoc(X, Y),
    X1 is X-1,
    retract(playerLoc(_, _)),
    asserta(playerLoc(X1, Y)),
    !.

s :- 
    inGameState(0),
    write('you haven\'t started the game yet!'), !.

s :-
    playerLoc(X, _),
    heightMap(H),
    (X =:= (H-2)),
    write('You can\'t go beyond borders'), nl, !.

s:-
    playerLoc(X, Y),
    X1 is X+1,
    tile(X1, Y, water),
    write('You can\'t swim, can you? stop playing around!'), nl, !.

s:- 
    playerLoc(X, Y),
    X1 is X+1,
    retract(playerLoc(_, _)),
    asserta(playerLoc(X1, Y)),
    !.

a :- 
    inGameState(0),
    write('you haven\'t started the game yet!'), !.

a :-
    playerLoc(_, Y),
    (Y =:= 1),
    write('You can\'t go beyond borders'), nl, !.

a:-
    playerLoc(X, Y),
    Y1 is Y-1,
    tile(X, Y1, water),
    write('You can\'t swim, can you? stop playing around!'), nl, !.

a:- 
    playerLoc(X, Y),
    Y1 is Y-1,
    retract(playerLoc(_, _)),
    asserta(playerLoc(X, Y1)),
    !.

d :-
    inGameState(0),
    write('you haven\'t started the game yet!'), !.

d :-
    playerLoc(_, Y),
    widthMap(W),
    (Y =:= W-2),
    write('You can\'t go beyond borders'), nl, !.

d:-
    playerLoc(X, Y),
    Y1 is Y+1,
    tile(X, Y1, water),
    write('You can\'t swim, can you? stop playing around!'), nl, !.

d:- 
    playerLoc(X, Y),
    Y1 is Y+1,
    retract(playerLoc(_, _)),
    asserta(playerLoc(X, Y1)),
    !.

