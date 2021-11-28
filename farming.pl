
:- dynamic(plantData/5).
% TILE SYMBOLS FOR PLANTS
tileSymbol(kentang, 'k').
tileSymbol(wortel, 'w').
tileSymbol(tomat, 't').
tileSymbol(bawang, 'b').


% CONNECTION BETWEEN SEED AND PLANT
plantOfSeed(bibit_wortel, wortel).
plantOfSeed(bibit_lobak, lobak).
plantOfSeed(bibit_kentang, kentang).
plantOfSeed(bibit_bawang, bawang).
plantOfSeed(bibit_tomat, tomat).

% PLANT STATUS SO THAT IT CAN BE HARVESTED
plantData(I, J, Plant, DayPlanted, DayAbleToHarvest).


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
    NewCount is Count - Amount,
    retract(inventory(Item, seed, _)),
    assert(inventory(Item, seed, NewCount)).



dig :-
    playerLoc(X,Y),
    tile(X,Y,Tile),
    Tile =:= empty,
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,digged)).

plant:-
    playerLoc(X,Y),
    tile(X,Y,Tile),
    Tile =:= digged,
    write('You have: '),
    nl,
    forall(inventory(Seed, seed, Count),
        (
            write('- '),
            write(Count),
            plantOfSeed(Seed, Plant),
            write(' '),
            write(Plant),
            write(' seed'),
            nl
        )
    ),
    write('Which seed do you want to plant? '),
    read(Seed),
    reduceSeedCount(Seed, 1),
    write('You planted a '),
    write(Seed),
    write(' seed.'),
    nl,
    plantOfSeed(Seed, Plant),
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,Plant)),
    retract(plantData(X,Y,_,_,_)),
    day(DayPlanted),
    growDays(Plant, GrowDays),
    asserta(plantData(X,Y,Plant,DayPlanted,DayPlanted + GrowDays)).

harvest:-
    playerLoc(X,Y),
    tile(X,Y,Tile),
    inventory(Tile, gardening, PrevCount),
    plantData(X,Y,Plant,_,DayAbleToHarvest),
    day(Day),
    DayAbleToHarvest =:= Day,
    NewCount is PrevCount + 1,
    retract(inventory(Tile, gardening, _)),
    asserta(inventory(Tile, gardening, NewCount)).
    write('You harvested '),
    write(Tile),
    write(' .'),
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,empty)).


