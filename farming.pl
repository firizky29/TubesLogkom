:- include('map.pl').

% next ditambah
tileSymbol(cornPlant, 'c').
tileSymbol(carrotPlant, 'w').
plant(cornPlant).
plant(wortelPlant).

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
    % print seed yang ada di inventory
    forall(),
    read(Seed),
    write('You planted a '),
    write(Seed),
    write(' seed.'),
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,cornPlant)).

harvest:-
    playerLoc(X,Y),
    tile(X,Y,Tile),
    plant(Tile),
    write('You harvested '),
    write(Tile),
    write(' .'),
    retract(tile(X,Y,_)),
    asserta(tile(X,Y,empty)).


