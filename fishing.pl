
inventory(arwana, fish, 1).
inventory(gurame, fish, 1).
inventory(lele, fish, 1).
inventory(mujair, fish, 1).
inventory(nila, fish, 1).

isAroundWater:-
    tile(XP, YP, player),
    X1 is XP-1,
    X2 is XP+1,
    Y1 is YP-1, 
    Y2 is YP+1,
    (tile(X1, YP, water); (tile(X2, YP, water)); (tile(XP, Y1, water)); tile(XP, Y2, water)), !.

getFish(FishFished):-
    random(0,120,R),
    R =< 20,
    FishFished is empty, !.
getFish(FishFished):-
    random(0,120,R),
    R > 20,
    R =< 30,
    FishFished is arwana, !.
getFish(FishFished):-
    random(0,120,R),
    R > 30,
    R =< 45,
    FishFished is gurame, !.
getFish(FishFished):-
    random(0,120,R),
    R > 45,
    R =< 75,
    FishFished is lele, !.
getFish(FishFished):-
    random(0,120,R),
    R > 75,
    R =< 100,
    FishFished is nila, !.
getFish(FishFished):-
    random(0,120,R),
    R > 100,
    FishFished is mujair, !.

fish :-
    isAroundWater,
    getFish(FishFished),
    retract(inventory(FishFished, fish, Previous)),
    New is Previous + 1,
    assert(inventory(FishFished, fish, New)),
    write('You got a '),
    write(FishFished),
    write('!'),nl,!.