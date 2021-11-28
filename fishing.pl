:- dynamic(fishListGenerator/1).

fishListGenerator([]).

rarity(arwana, 10). % semakin besar semakin tidak langka
rarity(gurame, 15).
rarity(lele, 30).
rarity(nila, 25).
rarity(mujair, 20).

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

countEmpty(X):-
    playerRole(fisherman),
    fishListGenerator(L),
    length(L, Len),
    X is 50*Len div 100, !.

countEmpty(X):-
    fishListGenerator(L),
    length(L, Len),
    X is 80*Len div 100, !.

fishGenerator:-
    forall((inventory(Fish, fish, _), rarity(Fish, Rarity), between(1, Rarity, _)), (
        fishListGenerator(L),
        append(L, [Fish], L_New),
        asserta(fishListGenerator(L_New)),
        retract(fishListGenerator(L))
    )), 
    countEmpty(X),
    forall(between(1, X, _), (
        fishListGenerator(L),
        append(L, [empty], L_New),
        asserta(fishListGenerator(L_New)),
        retract(fishListGenerator(L))
    )),
    !.

fish :-
    isAroundWater,
    fishListGenerator(L),
    length(L, Len),
    random(0,Len,Idx),
    nth0(Idx, L, FishFished),
    gotFishInterface(FishFished), !.

fish :-
    write('\nAre you going to catch a worm or something? you can only FISH near the pond\n'), !.

gotFishInterface(empty):-
    write('oh no, unfortunately you didn\'t get anything, try again will you?'), !.

gotFishInterface(FishFished):-
    addProgress(FishFished, 1),
    retract(inventory(FishFished, fish, Previous)),
    New is Previous + 1,
    asserta(inventory(FishFished, fish, New)),
    write('Amazing! you got a(n) '),
    write(FishFished),
    write('!'), nl, !.

gotFishInterface(FishFished):-
    retract(inventory(FishFished, fish, Previous)),
    New is Previous + 1,
    asserta(inventory(FishFished, fish, New)),
    write('Amazing! you got a(n) '),
    write(FishFished),
    write('!'), nl, !.