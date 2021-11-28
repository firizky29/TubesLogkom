:- include('map.pl').
:- include('item.pl').
% :- include('farming.pl').
:- include('fishing.pl').
% :- include('ranching.pl').
:- include('house.pl').
:- include('market.pl').
:- include('player.pl').
:- include('quest.pl').


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
    write('this is your current status, keep up your good work and have fun!\n'),
    write('=================================================================\n'),
    playerRole(Role),
    roleDisplay(Role, PlayerRole),
    playerLevel(Level),
    fishingExp(FishExp),
    farmingExp(FarmExp),
    ranchingExp(RanchExp),
    fishingLevel(FishLevel),
    ranchingLevel(RanchLevel),
    farmingLevel(FarmLevel),
    money(Gold),
    playerExp(Exp),
    reqexp(Level, ReqExp),
    
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

