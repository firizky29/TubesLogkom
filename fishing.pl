:- include('map.pl').


isAroundWater(I,J,Bool):-
    tile(I,J,Type),
    Type == water,
    Bool = true.

fish :-
    tile(I,J,_),
    isAroundWater(I,J,Bool),
    Bool == true,
    % randoming
    write('You got a thing!'),nl,