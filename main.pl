:- include('lib.pl').
:- include('map.pl').
:- include('item.pl').
:- include('player.pl').
:- include('quest.pl').
:- include('farming.pl').
:- include('market.pl').
:- include('fishing.pl').
:- include('ranching.pl').
:- include('alchemist.pl').
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
    Idx > 0,
    Idx < 4,
    initPlayer(Idx), 
    printRole(Idx),
    initMap,
    fishGenerator,
    initStock,
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
    write('1.  map          : untuk menampilkan peta '), nl,
    write('2.  w            : bergerak ke atas '), nl,
    write('3.  a            : bergerak ke bawah '), nl,
    write('4.  s            : bergerak ke kiri '), nl,
    write('5.  d            : bergerak ke kanan '), nl,
    write('6.  market       : masuk ke dalam market (harus berada di market) '), nl,
    write('7.  house        : masuk ke dalam house (harus berada di house) '), nl,
    write('8.  ranch        : masuk ke dalam ranch (harus berada di ranch) '), nl,
    write('9.  fish         : untuk memulai fishing '), nl,
    write('10. dig          : untuk menggali lahan kosong (lalu akan ditanami tanaman) '), nl,
    write('11. plant        : untuk menanam tanaman '), nl,
    write('12. harvest      : untuk panen '), nl,
    write('13. inventory    : untuk memperlihatkan isi inventory '), nl,
    write('14. status       : untuk memperlihatkan status player '), !.


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
    write('\nYou moved north'), nl, 
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
    write('\nYou moved south'), nl,
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
    write('\nYou moved west'), nl, 
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
    write('\nYou moved east'), nl, 
    !.


% END GAME
goalGame(MONEY) :-
    MONEY >= 20000,
    write('\nCongratulations! You have finally reached the goal of this farm-thingy!'), nl,
    write('Now all of your debts can finally be paid'), nl,
    write('\n\nIn the end, all this journey is valuable for you, \nand you will continue to work hard no matter what the conditions you are in'),
    retract(gameState(_)),
    asserta(gameState(0)),
    retract(inGameState(_)),
    asserta(inGameState(0)),
    !.

goalGame(_):-
    !.

failGame(DAY) :-
    DAY >= 120,
    write('oh no, because the time limit has passed,') ,
    write('\nthe debt lenders unexpectedly force you to collect your debt directly to your farm.'),
    write('You have worked hard, but in the end result is all that matters.'),nl,
    write('May God bless you in the future with kind people!'),nl,
    retract(gameState(_)),
    asserta(gameState(0)),
    retract(inGameState(_)),
    asserta(inGameState(0)),
    !.

failGame(_):- !.