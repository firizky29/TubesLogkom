:- dynamic(widthMap/1).
:- dynamic(heightMap/1).
:- dynamic(playerLoc/2).
:- dynamic(tile/3).
:- dynamic(listOfEmptyTile/1).

tileSymbol(border, '#').
tileSymbol(empty, '-').
tileSymbol(marketplace, 'M').
tileSymbol(ranch, 'R').
tileSymbol(house, 'H').
tileSymbol(quest, 'Q').
tileSymbol(alchemist, 'A').
tileSymbol(water, 'o').
tileSymbol(digged, '=').
tileSymbol(kentang, 'k').
tileSymbol(wortel, 'w').
tileSymbol(tomat, 't').
tileSymbol(bawang, 'b').

widthMap(0).
heightMap(0).
tile(0, 0, 0).
playerLoc(0, 0).
listOfEmptyTile([]).



initMap:-
    random(10, 32, W),
    random(10, 32, H),
    % W is 10,
    % H is 10,
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
    deleteAt(T1, (XH, YH), IdxHome, L1),
    deleteNeighborof(XH, YH, L1, T2),

    retract(tile(XH, YH, _)),
    asserta(tile(XH, YH, house)),

    % player
    retract(playerLoc(_, _)),
    asserta(playerLoc(XH, YH)),

    % build market
    length(T2, Len2),
    random(0, Len2, IdxMarket),
    deleteAt(T2, (XM, YM), IdxMarket, L2),
    deleteNeighborof(XM, YM, L2, T3),
    retract(tile(XM, YM, _)),
    asserta(tile(XM, YM, marketplace)),

    % build ranch
    length(T3, Len3),
    random(0, Len3, IdxRanch),
    deleteAt(T3, (XR, YR), IdxRanch, L3),
    deleteNeighborof(XR, YR, L3, T4),
    retract(tile(XR, YR, _)),
    asserta(tile(XR, YR, ranch)),

    length(T4, Len4),
    random(0, Len4, IdxQuest),
    deleteAt(T4, (XQ, YQ), IdxQuest, L4),
    deleteNeighborof(XQ, YQ, L4, T5),
    retract(tile(XQ, YQ, _)),
    asserta(tile(XQ, YQ, quest)),
    generateQuestTarget,

    % Build Alchemist Store
    length(T5, Len5),
    random(0, Len5, IdxAlchemist),
    deleteAt(T5, (XA, YA), IdxAlchemist, L5),
    deleteNeighborof(XA, YA, L5, T6),
    retract(tile(XA, YA, _)),
    asserta(tile(XA, YA, alchemist)),

    retract(listOfEmptyTile(_)),
    asserta(listOfEmptyTile(T6)),
    

    !.
    
generateNewQuestPlace:-
    tile(XQ, YQ, quest),
    returnDeletedCoordinate(XQ, YQ),
    listOfEmptyTile(L),
    length(L, Len),
    random(0, Len, IdxQuest),
    nth0(IdxQuest, L, (XQ_New, YQ_New)),
    append(T, [XQ, YQ], T1),
    deleteAt(L, (XQ_New, YQ_New), IdxQuest, T),
    deleteNeighborof(XQ_New, YQ_New, T1, Res),
    retract(tile(XQ, YQ, _)),
    asserta(tile(XQ, YQ, empty)),
    retract(tile(XQ_New, YQ_New, _)),
    asserta(tile(XQ_New, YQ_New, quest)),
    retract(listOfEmptyTile(_)),
    asserta(listOfEmptyTile(Res)),
    generateQuestTarget,
    !.


deleteNeighborof(X, Y, L, Res):-
    X1 is X-1,
    X2 is X+1,
    Y1 is Y-1,
    Y2 is Y+1,
    delete(L, (X1, Y), L1),
    delete(L1, (X1, Y1), L2),
    delete(L2, (X1, Y2), L3),
    delete(L3, (X2, Y), L4),
    delete(L4, (X2, Y1), L5),
    delete(L5, (X2, Y2), L6),
    delete(L6, (X, Y1), L7),
    delete(L7, (X, Y2), Res), !.

returnDeletedCoordinate(X, Y):-
    listOfEmptyTile(L),
    X1 is X-1,
    X2 is X+1,
    Y1 is Y-1,
    Y2 is Y+1,
    append(L, [(X1, Y)], L1),
    append(L1, [(X1, Y1)], L2),
    append(L2, [(X1, Y2)], L3),
    append(L3, [(X2, Y)], L4),
    append(L4, [(X2, Y1)], L5),
    append(L5, [(X2, Y2)], L6),
    append(L6, [(X, Y1)], L7),
    append(L7, [(X, Y2)], Res), 
    retractall(listOfEmptyTile(_)),
    asserta(listOfEmptyTile(Res)),
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


printCoor(X, Y):-
    playerLoc(XP, YP),
    X is XP,
    Y is YP,
    write('P'),
    !.

printCoor(X, Y):-
    tile(X, Y, Plant),
    itemType(Plant, farm),
    plantData(X,Y, Plant, _, DayAbleToHarvest),
    day(Day),
    DayAbleToHarvest =< Day,
    tileSymbol(Plant, CharPlant),
    lower_upper(CharPlant, CharPlantHarvest),
    write(CharPlantHarvest),
    !.

printCoor(X, Y):-
    tile(X, Y, ID),
    tileSymbol(ID, CharID),
    write(CharID),
    !. 



printInfoMap:-
    playerLoc(XP, YP),
    tile(XP, YP, house),
    write('\nYou\'re currently inside your HOUSE!\n'),
    write('\nLegend:\n'),
    write('=================================================================\n'),
    write('P : Your current position\n'),
    write('M : marketplace\n'),
    write('R : Ranch\n'),
    write('Q : Active quest\n'),
    write('A : Potion store\n'),
    write('o : Water\n'), !.

printInfoMap:-
    playerLoc(XP, YP),
    tile(XP, YP, marketplace),
    write('\nYou\'re in the marketplace, you can buy something if you want!\n'),
    write('\nLegend:\n'),
    write('=================================================================\n'),
    write('P : Your current position\n'),
    write('H : Your house\n'),
    write('R : Ranch\n'),
    write('Q : Active quest\n'),
    write('A : Potion store\n'),
    write('o : Water\n'), !.

printInfoMap:-
    playerLoc(XP, YP),
    tile(XP, YP, ranch),
    write('\nYou\'re in the ranch, let\'s take care of the farm-animals!\n'),
    write('\nLegend:\n'),
    write('=================================================================\n'),
    write('P : Your current position\n'),
    write('H : Your house\n'),
    write('M : marketplace\n'),
    write('Q : Active quest\n'),
    write('A : Potion store\n'),
    write('o : Water\n'), !.

printInfoMap:-
    playerLoc(XP, YP),
    tile(XP, YP, quest),
    write('\nyou arrived at the quest spot!, why not finish all the quests?\n'),
    write('\nLegend:\n'),
    write('=================================================================\n'),
    write('P : Your current position\n'),
    write('H : Your house\n'),
    write('M : marketplace\n'),
    write('R : Ranch\n'),
    write('A : Potion store\n'),
    write('o : Water\n'), !.


printInfoMap:-
    playerLoc(XP, YP),
    tile(XP, YP, alchemist),
    write('\nyou are in alchemist house!, this is the place where you can buy any limited edition potion(s)\n'),
    write('\nLegend:\n'),
    write('=================================================================\n'),
    write('P : Your current position\n'),
    write('H : Your house\n'),
    write('M : marketplace\n'),
    write('R : Ranch\n'),
    write('Q : Active quest\n'),
    write('o : Water\n'), !.

printInfoMap:-
    write('\nLegend:\n'),
    write('=================================================================\n'),
    write('P : Your current position\n'),
    write('H : Your house\n'),
    write('M : marketplace\n'),
    write('R : Ranch\n'),
    write('Q : Active quest\n'),
    write('A : Potion store\n'),
    write('o : Water\n'), 
    !.

map:-
    widthMap(W),
    heightMap(H),
    W1 is W-1,
    H1 is H-1,
    write('Here is your map!\n'),
    write('=================================================================\n'),
    forall(between(0, H1, I),(
        forall(between(0, W1, J), (
            printCoor(I, J)
        )),
        nl
    )), 
    
    printInfoMap,
    !.

    



    

    
    






