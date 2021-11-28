
:- dynamic(playerRole/1).
:- dynamic(playerExp/2).
:- dynamic(money/1).
:- dynamic(growthExp/2).


playerRole(0).
playerExp(0, 0).
money(0).

% fakta-fakta dari player
idRole(1, fish).
idRole(2, farm).
idRole(3, ranch).
roleDisplay(fish, 'Fisherman').
roleDisplay(farm, 'Farmer').
roleDisplay(ranch, 'Rancher').
% reqexp(level, N) : reqierementXP

reqexp(_, 0, 0).
reqexp(_, 1, 300).
reqexp(_, 2, 700).
reqexp(_, 3, 1500).
reqexp(_, 4, 3100).
reqexp(_, 5, 6300).
reqexp(_, 6, 12700).
reqexp(_, 7, 25500).
reqexp(_, 8, 51100).
reqexp(_, 9, 102300).
reqexp(_, 10, 'INF').

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 1, Req),
    Exp =< Req, 
    Level is 1,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 2, Req),
    Exp =< Req, 
    Level is 2,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 3, Req),
    Exp =< Req, 
    Level is 3,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 4, Req),
    Exp =< Req, 
    Level is 4,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 5, Req),
    Exp =< Req, 
    Level is 5,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 6, Req),
    Exp =< Req, 
    Level is 6,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 7, Req),
    Exp =< Req, 
    Level is 7,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 8, Req),
    Exp =< Req, 
    Level is 8,
    !.

playerLevel(Type, Level):-
    playerExp(Type, Exp),
    reqexp(Type, 9, Req),
    Exp =< Req, 
    Level is 9,
    !.

playerLevel(Type, Level):-
    playerExp(Type, _),
    Level is 10,
    !.
    
initPlayer(Idx):-
    retract(playerRole(_)),
    idRole(Idx, Role),
    asserta(playerRole(Role)),
    retract(money(_)),
    asserta(money(1000)),
    retract(playerExp(_, _)),
    asserta(playerExp(total, 0)),
    asserta(playerExp(fish, 0)),
    asserta(playerExp(ranch, 0)),
    asserta(playerExp(farm, 0)),
    !.

printRole(Idx):-
    idRole(Idx, fish),
    write('\nYou\' choose fisherman, let\'s start farming!\n'), !.

printRole(Idx):-
    idRole(Idx, farm),
    write('\nYou\' choose farmer, let\'s start farming!'), !.

printRole(Idx):-
    idRole(Idx, ranch),
    write('\nYou\' choose rancher, let\'s start farming!'), !.

gainExp(Type, Inc):- 
    playerExp(Type, Exp),
    New_Exp is Exp + Inc,
    retract(playerExp(Type, Exp)),
    asserta(playerExp(Type, New_Exp)),
    !.



