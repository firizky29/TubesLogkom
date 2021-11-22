:- include('map.pl').


isAroundWater(I,J,Bool):-
    tile(I-1,J,Type),
    Type == water,
    Bool = true.
isAroundWater(I,J,Bool):-
    tile(I+1,J,Type),
    Type == water,
    Bool = true.
isAroundWater(I,J,Bool):-
    tile(I,J-1,Type),
    Type == water,
    Bool = true.
isAroundWater(I,J,Bool):-
    tile(I,J+1,Type),
    Type == water,
    Bool = true.

fish :-
    tile(I,J,_),
    isAroundWater(I,J,Bool),
    Bool == true,
    % randoming
    write('You got a thing!'),nl,