:- include('map.pl').


isAroundWater:-
    tile(XP, YP, player),
    X1 is XP-1,
    X2 is XP+1,
    Y1 is YP-1, 
    Y2 is YP+1,
    (tile(X1, YP, water); (tile(X2, YP, water)); (tile(XP, Y1, water)); tile(XP, Y2, water)), !.

fish :-
    isAroundWater,
    % randoming
    write('You got a thing!'),nl,!.