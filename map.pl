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
    % random(10, 32, W),
    % random(10, 32, H),
    W is 30,
    H is 25,
    retract(widthMap(_)),
    asserta(widthMap(W)),
    retract(heightMap(_)),
    asserta(heightMap(H)),
    retractall(listOfEmptyTile(_)),
    asserta(listOfEmptyTile([])),
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
        forall((between(1, Wmax1, Y2), tile(X2, Y2, empty), 
                X3 is X2-1, X4 is X2+1, Y3 is Y2-1, Y4 is Y2+1, 
                tile(X3, Y2, empty), tile(X4, Y2, empty), tile(X2, Y3, empty), tile(X2, Y4, empty),
                tile(X3, Y3, empty), tile(X3, Y4, empty), tile(X4, Y3, empty), tile(X4, Y4, empty)), (
            listOfEmptyTile(L),
            append(L, [(X2, Y2)], L_New),
            asserta(listOfEmptyTile(L_New)),
            retract(listOfEmptyTile(L))    
        ))    
    )), 

    % build house
    listOfEmptyTile(T1),
    length(T1, Len1),
    random(0, Len1, IdxHome),
    deleteAt(T1, (XH, YH), IdxHome, T2),
    % XH1 is XH-1,
    % XH2 is XH+1,
    % YH1 is YH-1,
    % YH2 is YH+1,
    % delete(L1, (XH1, XH), T2),
    retract(tile(XH, YH, _)),
    asserta(tile(XH, YH, house)),

    % player
    initPlayerLoc, 

    % build market
    length(T2, Len2),
    random(0, Len2, IdxMarket),
    deleteAt(T2, (XM, YM), IdxMarket, T3),
    retract(tile(XM, YM, _)),
    asserta(tile(XM, YM, marktetplace)),

    % build ranch
    length(T3, Len3),
    random(0, Len3, IdxRanch),
    deleteAt(T3, (XR, YR), IdxRanch, T4),
    retract(tile(XR, YR, _)),
    asserta(tile(XR, YR, ranch)),

    retract(listOfEmptyTile(_)),
    asserta(listOfEmptyTile(T4)),

    !.
    % Generate player location and home
    % Wmax2 is (W-3),
    % random(1, Hmax1, X2),
    % random(1, Wmax2, Y2),
    % retract(playerLoc(_, _)),
    % asserta(playerLoc(X2,Y2)),
    % YH is Y2 + 1,
    



% pleyerPos():-

initPlayerLoc:-
    tile(X, Y, house),
    playerLoc(XP, YP),
    Y1 is Y-1,
    tile(X, Y1, empty),
    retract(tile(X,Y1,empty)),
    asserta(tile(XP, YP, empty)),
    asserta(tile(X, Y1, player)),
    retract(playerLoc(_, _)),
    asserta(playerLoc(X, Y)), !.

initPlayerLoc:-
    tile(X, Y, house),
    playerLoc(XP, YP),
    Y1 is Y+1,
    tile(X, Y1, empty),
    retract(tile(X,Y1,empty)),
    asserta(tile(XP, YP, empty)),
    asserta(tile(X, Y1, player)), 
    retract(playerLoc(_, _)),
    asserta(playerLoc(X, Y)),
    !.


initPlayerLoc:-
    tile(X, Y, house),
    playerLoc(XP, YP),
    X1 is X-1,
    tile(X1, Y, empty),
    retract(tile(X1,Y,empty)),
    asserta(tile(XP, YP, empty)),
    asserta(tile(X1, Y, player)), 
    retract(playerLoc(_, _)),
    asserta(playerLoc(X, Y)),
    !.


initPlayerLoc:-
    tile(X, Y, house),
    playerLoc(XP, YP),
    X1 is X+1,
    tile(X1, Y, empty),
    retract(tile(X1,Y,empty)),
    asserta(tile(XP, YP, empty)),
    asserta(tile(X1, Y, player)), 
    retract(playerLoc(_, _)),
    asserta(playerLoc(X, Y)),
    !.



setPlayerLoc(X, Y):-
    tile(X, Y, empty),
    playerLoc(XP, YP),
    retract(tile(XP,YP,player)),
    retract(tile(X,Y,empty)),
    asserta(tile(XP, YP, empty)),
    asserta(tile(X, Y, player)), 
    retract(playerLoc(XP, YP)),
    asserta(playerLoc(X, Y)),
    !.

setPlayerLoc(X, Y):-
    tile(X, Y, _),
    retract(playerLoc(_, _)),
    asserta(playerLoc(X, Y)),
    !.

radBound(X, Y):-
    widthMap(W),
    heightMap(H),
    Bound is min(W, H),
    Bound =< 10,
    X is 1, 
    Y is 2,
    !.

radBound(X, Y):-
    widthMap(W),
    heightMap(H),
    Bound is min(W, H),
    Bound =< 15,
    X is 2, 
    Y is 3,
    !.

radBound(X, Y):-
    X is 3, 
    Y is 4,
    !.


buildPond(X, Y):-
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

    



    

    
    






