isAroundWater:-
    playerLoc(XP, YP),
    X1 is XP-1,
    tile(X1, YP, water), 
    !.

isAroundWater:-
    playerLoc(XP, YP),
    X2 is XP+1,
    tile(X2, YP, water),
    !.

isAroundWater:-
    playerLoc(XP, YP),
    Y1 is YP-1, 
    tile(XP, Y1, water),
    !.

isAroundWater:-
    playerLoc(XP, YP),
    Y2 is YP+1,
    tile(XP, Y2, water), 
    !.

getFish(R, empty):-
    R =< 20, !.
getFish(R, arwana):-
    R > 20,
    R =< 30, !.
getFish(R, gurame):-
    R > 30,
    R =< 45, !.
getFish(R, lele):-
    R > 45,
    R =< 75, !.
getFish(R, nila):-
    R > 75,
    R =< 100, !.
getFish(R, mujair):-
    R > 100, !.

fish :-
    isAroundWater,
    random(0,120,R),
    getFish(R, FishFished),
    % write(FishFished),
    % retract(inventory(FishFished, fish, Previous)),
    % New is Previous + 1,
    % asserta(inventory(FishFished, fish, New)),
    write('You got a '),
    write(FishFished),
    write('!'),nl,!.