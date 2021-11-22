:- dynamic(widthMap/1).
:- dynamic(heightMap/1).
:- dynamic(playerLoc/2).
:- dynamic(tile/3).
:- dynamic(hasActiveQuest/1).
:- include('lib.pl').


% idTile(0, border).
% idTile(1, player).
% idTile(2, empty).
% idTile(3, marktetplace).
% idTile(4, ranch).
% idTile(5, house).
% idTile(6, quest).
% idTile(7, water).
% idTile(8, digged).

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



initMap:-
    random(10, 30, W),
    random(10, 30, H),
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
    Wmax2 is (W-3),
    random(1, Hmax1, X2),
    random(1, Wmax2, Y2),
    retract(playerLoc(_, _)),
    asserta(playerLoc(X2,Y2)),
    YH is Y2 + 1,
    retract(tile(X2, YH, _)),
    asserta(tile(X2, YH, house)),
    retract(tile(X2, Y2, _)),
    asserta(tile(X2, Y2, player)).

% % generate pond (under construction)
% random(1, Wmax1, X1),
% random(1, Hmax1, Y1),
% buildPond(X1, Y1).


buildPond(X, Y):-
    widthMap(W),
    heightMap(H),
    random(15, 20, Percentage1),
    UpperRadius is Y-((Percentage1*Y) div 100),
    random(15, 20, Percentage2),
    BottomRadius is Y+((Percentage2*(H-Y)) div 100),
    random(15, 20, Percentage3),
    MinRightRadius is X+((Percentage3*(W-X)) div 100),
    random(21, 30, Percentage4),
    MinLeftRadius is X-((Percentage4*X) div 100),
    random(21, 30, Percentage5),
    MaxRightRadius is (X+(Percentage5*(W-X)) div 100),
    random(15, 20, Percentage6),
    MaxLeftRadius is X-((Percentage6*X) div 100),
    write(MinLeftRadius), nl, write(MaxLeftRadius), nl,
    write(MinRightRadius), nl, write(MaxRightRadius), nl,
    forall(between(UpperRadius, BottomRadius, I),(
        random(MinLeftRadius, MaxLeftRadius, Left),
        random(MinRightRadius, MaxRightRadius, Right),
        write(Left), write(' '), write(Right), nl,
        forall(between(Left, Right, J),(
            retract(tile(I, J, _)),
            asserta(tile(I, J, water))
        ))
    )).

    

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

    



    

    
    






