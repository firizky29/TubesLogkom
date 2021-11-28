
:- dynamic(plantData/5).
% TILE SYMBOLS FOR PLANTS



% CONNECTION BETWEEN SEED AND PLANT
plantOfSeed(bibit_wortel, wortel).
plantOfSeed(bibit_lobak, lobak).
plantOfSeed(bibit_kentang, kentang).
plantOfSeed(bibit_bawang, bawang).
plantOfSeed(bibit_tomat, tomat).

% PLANT STATUS SO THAT IT CAN BE HARVESTED
plantData(0, 0, empty, 0, 0).


% GROWING DAYS
growDays(wortel, 3).
growDays(lobak, 4).
growDays(kentang, 4).
growDays(bawang, 2).
growDays(tomat, 3).

% REDUCE SEED COUNT IN INVENTORY
reduceSeedCount(Item, AmountUsed) :-
    inventory(Item, seed, Count),
    Count - AmountUsed >= 0,
    NewCount is Count - AmountUsed,
    retract(inventory(Item, seed, _)),
    asserta(inventory(Item, seed, NewCount)),!.

% INCREASE FARMING EXP
increaseFarmingExp(Exp):-
    inventory(shovel, _, ShovelLevel),
    playerRole(farm),
    random(30, 41, Mult),
    Exp is (Mult*ShovelLevel), !.

increaseFarmingExp(Exp):-
    inventory(shovel, _, ShovelLevel),
    random(20, 31, Mult),
    Exp is (Mult*ShovelLevel), !.


dig:-
    playerLoc(X,Y),
    tile(X,Y,empty),
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,digged)),
    write('You dug a hole!'), nl,!.

dig:-
    playerLoc(X,Y),
    tile(X,Y,digged),
    write('\nYou\'re already digged it, you just wasted your energy\n'), !.

dig:-
    write('\nAre you really going to dig the entire building? of course not :D\n'), !.


plant :-
    playerLoc(X,Y),
    tile(X,Y,digged),
    forall(inventory(_, seed, Count), Count=:=0),
    write('You have no seed. You can buy seeds at the marketplace'), nl, !.

plant:-
    playerLoc(X,Y),
    tile(X,Y,digged),
    write('You have: '),
    nl,
    forall(inventory(Seed, seed, Count), (
        writeinvent(Seed, seed, Count)
    )),
    write('Which seed do you want to plant? '),
    read(Plant),
    plantOfSeed(Seed, Plant),
    reduceSeedCount(Seed, 1),
    write('\nYou planted a '),
    write(Plant),
    write(' seed.'),
    nl,
    plantOfSeed(Seed, Plant),
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,Plant)),
    day(DayPlanted),
    growDays(Plant, GrowDays),
    asserta(plantData(X,Y,Plant,DayPlanted,DayPlanted + GrowDays)),!.


plant :-
    write('You can\'t plant on an undigged soil!'),
    nl, !.


harvest:-
    playerLoc(X,Y),
    tile(X,Y,Plant),
    inventory(Plant, gardening, PrevCount),
    plantData(X,Y,_,_,DayAbleToHarvest),
    day(Day),
    DayAbleToHarvest =< Day, 
    NewCount is PrevCount + 1,
    retract(inventory(Plant, gardening, _)),
    asserta(inventory(Plant, gardening, NewCount)),
    write('You harvested '),
    write(Plant),
    write(' .'),
    harvestGain(Plant),
    nl,
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,empty)), !.

harvest:-
    playerLoc(X,Y),
    tile(X,Y,Plant),
    plantData(X,Y,Plant,_,DayAbleToHarvest),
    day(Day),
    DayAbleToHarvest > Day, 
    write('You cannot harvest '),
    write(Plant),
    write(' .'),
    nl,
    write('You have to wait until day '),
    write(DayAbleToHarvest),
    write(' to harvest '),
    write(Plant),
    !.

harvestGain(Item):-
    addProgress(Item, 1),
    increaseFarmingExp(Exp),
    gainExp(farm, Exp),
    TotalExp is (Exp*120) div 100,
    gainExp(total, TotalExp),
    write('You gained '),
    write(TotalExp),
    write(' Exp.\n'),
    write('You gained '),
    write(TotalExp),
    write(' Exp and '),
    write(Exp),
    write(' Exp. \n How cool is that?\n'),
    !.

harvestGain(Item):-
    increaseFarmingExp(Exp),
    gainExp(farm, Exp),
    TotalExp is (Exp*120) div 100,
    gainExp(total, TotalExp),
    write('You gained '),
    write(TotalExp),
    write(' Exp.\n'),
    write('You gained '),
    write(TotalExp),
    write(' Exp and '),
    write(Exp),
    write(' Exp. \n How cool is that?\n'),
    !.


