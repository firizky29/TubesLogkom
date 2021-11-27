
:- dynamic(playerRole/1).
:- dynamic(playerLevel/1).
:- dynamic(fishingExp/1).
:- dynamic(ranchingExp/1).
:- dynamic(farmingExp/1).
:- dynamic(fishingLevel/1).
:- dynamic(ranchingLevel/1).
:- dynamic(farmingLevel/1).
:- dynamic(money/1).
:- include('map.pl').

playerLevel(0).
fishingExp(0).
farmingExp(0).
ranchingExp(0).
fishingLevel(0).
ranchingLevel(0).
farmingLevel(0).
money(0).

% fakta-fakta dari player
idRole(1, fisherman).
idRole(2, farmer).
idRole(3, rancher).
% reqexp(level, N) : reqierementXP

reqexp(0, 0).
reqexp(1, 300).
reqexp(2, 700).
reqexp(3, 1500).
reqexp(4, 3100).
reqexp(5, 6300).
reqexp(6, 12700).
reqexp(7, 25500).
reqexp(8, 51100).
reqexp(9, 102300).
reqexp(10, 204500).

playerRole(0).

% Move Player
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

    
initPlayer(Idx):-
    retract(playerRole(_)),
    idRole(Idx, Role),
    asserta(playerRole(Role)), 
    retract(playerLevel(_)),
    asserta(playerLevel(0)),
    retract(fishingExp(_)),
    asserta(fishingExp(0)),
    retract(farmingExp(_)),
    asserta(farmingExp(0)),
    retract(ranchingExp(_)),
    asserta(ranchingExp(0)),
    retract(fishingLevel(_)),
    asserta(fishingLevel(0)),
    retract(farmingLevel(_)),
    asserta(farmingLevel(0)),
    retract(ranchingLevel(_)),
    asserta(ranchingLevel(0)),
    retract(money(_)),
    asserta(money(1000)),
    !.

printRole(Idx):-
    idRole(Idx, fisherman),
    write('\nYou\' choose fisherman, let\'s start farming!\n'), !.

printRole(Idx):-
    idRole(Idx, farmer),
    write('\nYou\' choose farmer, let\'s start farming!'), !.

printRole(Idx):-
    idRole(Idx, rancher),
    write('\nYou\' choose rancher, let\'s start farming!'), !.


