:- dynamic(widthMap/1).
:- dynamic(heightMap/1).
:- dynamic(playerLoc/2).
:- dynamic(tile/3).
:- dynamic(hasActiveQuest/1).
:- dynamic(listOfEmptyTile/1).
:- include('lib.pl').


tileSymbol(border, '#').
tileSymbol(player, 'P').
tileSymbol(empty, '-').
tileSymbol(marktetplace, 'M').
tileSymbol(ranch, 'R').
tileSymbol(house, 'H').
tileSymbol(quest, 'Q').
tileSymbol(water, 'o').
tileSymbol(digged, '=').

widthMap(0).
heightMap(0).
hasActiveQuest(0).
tile(0, 0, 0).
playerLoc(0, 0).
listOfEmptyTile([]).



initMap:-
    random(10, 32, W),
    random(10, 32, H),
    retract(widthMap(_)),
    asserta(widthMap(W)),
    retract(heightMap(_)),
    asserta(heightMap(H)),
    buildMap, !.

buildMap:-
    widthMap(W),
    heightMap(H),

    Wmax is W-1,
    Hmax is H-1,
    % generate border
    retractall(tile(_,_,_)),
    forall(between(0, Wmax, X),(
        asserta(tile(0, X, border)),
        asserta(tile(Hmax, X, border))
    )),
    forall(between(0, Hmax, Y),(
        asserta(tile(Y, 0, border)),
        asserta(tile(Y, Wmax, border))
    )),
    % generate land
    Wmax1 is (W-2),
    Hmax1 is (H-2),
    forall(between(1, Hmax1, X1), (
        forall(between(1, Wmax1, Y1), (
            asserta(tile(X1, Y1, empty))
        ))
    )),

    % generate pond
    PondW is (W-4),
    PondH is (H-4),
    Xmin1 is min(4, PondW),
    Xmax1 is max(4, PondW),
    Ymin1 is min(4, PondH),
    Ymax1 is max(4, PondH),
    random(Xmin1, Xmax1, X1),
    random(Ymin1, Ymax1, Y1),
    buildPond(X1, Y1),
    forall(between(1, Hmax1, X2), (
        forall((between(1, Wmax1, Y2), tile(X2, Y2, empty)),(

            listOfEmptyTile(L),
            append(L, [(X2, Y2)], L_New),
            asserta(listOfEmptyTile(L_New)),
            retract(listOfEmptyTile(L))    
        ))    
    )), !.
    % Generate player location and home
    % Wmax2 is (W-3),
    % random(1, Hmax1, X2),
    % random(1, Wmax2, Y2),
    % retract(playerLoc(_, _)),
    % asserta(playerLoc(X2,Y2)),
    % YH is Y2 + 1,
    % retract(tile(X2, YH, _)),
    % asserta(tile(X2, YH, house)),
    % retract(tile(X2, Y2, _)),
    % asserta(tile(X2, Y2, player)).



% % generate pond (under construction)
% random(1, Wmax1, X1),
% random(1, Hmax1, Y1),
% buildPond(X1, Y1).
radBound(X, Y):-
    widthMap(W),
    heightMap(H),
    Bound is W*H,
    Bound =< 200,
    X is 2, 
    Y is 3,
    !.

radBound(X, Y):-
    widthMap(W),
    heightMap(H),
    X is 2, 
    Y is 4,
    !.



buildPond(X, Y):-
    widthMap(W),
    heightMap(H),
    radBound(X1, Y1),
    random(X1, Y1, Radius),
    Ymin is Y-Radius,
    Ymax is Y+Radius,
    forall(between(Ymin, Ymax, I), (
        Xmin is floor(X - sqrt(Radius*Radius-(I-Y)*(I-Y))),
        Xmax is floor(X + sqrt(Radius*Radius-(I-Y)*(I-Y))),
        forall(between(Xmin, Xmax, J), (
            retract(tile(I, J, _)),
            asserta(tile(I, J, water))
        ))
    )),
    !.
    

map:-
    widthMap(W),
    heightMap(H),
    W1 is W-1,
    H1 is H-1,
    forall(between(0, H1, I),(
        forall(between(0, W1, J), (
            tile(I, J, ID),
            tileSymbol(ID, CharID),
            write(CharID) 
        )),
        nl    
    )).

    



    

    
    






