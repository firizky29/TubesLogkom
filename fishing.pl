:- dynamic(fishListGenerator/1).

fishListGenerator([]).

rarity(arwana, 10). % semakin besar semakin tidak langka
rarity(gurame, 15).
rarity(lele, 30).
rarity(nila, 25).
rarity(mujair, 20).

increaseFishingExp(Item, Exp):-
    inventory(fishing_rod, _, FishingRodLevel),
    playerRole(fish),
    fishListGenerator(L),
    length(L, Len),
    rarity(Item, X),
    Rarity is floor((Len-X)*100/Len),
    random(30, 41, Mult),
    Percentage is (100 + Rarity),
    Exp is (Percentage*Mult*FishingRodLevel) div 100, !.

increaseFishingExp(Item, Exp):-
    inventory(fishing_rod, _, FishingRodLevel),
    fishListGenerator(L),
    length(L, Len),
    rarity(Item, X),
    Rarity is floor((Len-X)*100/Len),
    random(20, 31, Mult),
    Percentage is (100 + Rarity),
    Exp is (Percentage*Mult*FishingRodLevel) div 100, !.


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


fish:-
    inventory(fishing_rod, _, 0),
    write('\nYou have to buy a fishing rod before you fish, you can buy it at the marketplace\n'), !.

fish:-
    playerEnergy(Energy),
    Energy < 10,
    write('You run out of energy!, go to home to get some sleep immediately!\n'), !.

fish :-
    isAroundWater,
    fishListGenerator(L),
    length(L, Len),
    random(0,Len,Idx),
    nth0(Idx, L, FishFished),
    lossEnergy(fish),
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
    write('!'), nl, 
    increaseFishingExp(FishFished, Exp),
    gainExp(fish, Exp),
    TotalExp is (Exp*120) div 100,
    gainExp(total, TotalExp),
    write('You gained '),
    write(TotalExp),
    write(' Exp and '),
    write(Exp),
    write(' Fishing Exp. \n Amazing!\n'),
    !.

gotFishInterface(FishFished):-
    retract(inventory(FishFished, fish, Previous)),
    New is Previous + 1,
    asserta(inventory(FishFished, fish, New)),
    write('Amazing! you got a(n) '),
    write(FishFished),
    write('!'), nl, 
    increaseFishingExp(FishFished, Exp),
    gainExp(fish, Exp),
    TotalExp is (Exp*120) div 100,
    gainExp(total, TotalExp),
    write('You gained '),
    write(TotalExp),
    write(' Exp and '),
    write(Exp),
    write(' Fishing Exp. \n Amazing!\n'),
    !.