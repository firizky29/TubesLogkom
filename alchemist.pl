:- dynamic(stock/2).

stock(0, 0).

cheatPotion:-
    playerLoc(XP, YP),
    tile(XA, YA, alchemist),
    retract(playerLoc(XP, YP)),
    asserta(playerLoc(XA, YA)), !.

initStock:-
    retractall(stock(_, _)),
    asserta(stock(farmPotion, 2)),
    asserta(stock(fishPotion, 4)),
    asserta(stock(ranchPotion, 3)),
    asserta(stock(bottleExp, 1)),
    asserta(stock(fatigueCure, 25)), !.

potion:- 
    playerLoc(X,Y),
    tile(X,Y,alchemist),
    findall(St, stock(_, St), L1),
    sum_list(L1, Sum),
    Sum > 0,
    write('Welcome to the potion store! this is our offer\n'),
    write('=================================================================\n'),
    findall(Items, inventory(Items, alchemist, _), L), 
    length(L, Len),
    forall((between(1, Len, I), nth1(I, L, Item), inventory(Item, alchemist, _), price(Item, Price), stock(Item, Stock)), (
        write(I), write('. '), write(Item), write(' | Price: '), write(Price), write(' | Stock: '), write(Stock), nl
    )), 
    write('Type what potion you want to buy:\n'),
    write('\n>>>  '),
    read(Potion),
    getPotion(Potion),
    !.

potion:-
    playerLoc(X,Y),
    findall(St, stock(_, St), L1),
    sum_list(L1, Sum),
    Sum =< 0,
    tile(X,Y,alchemist),
    write('\nOh no we run out of stock today, come back later\n'), !.


getPotion(ITEM) :-
    write('How much do you wish to buy?'), nl,
    nl, write('>>> '),
    read(X),
    stock(ITEM, STOCK),
    (
        X > STOCK,
        write('The stock is not enough for the request'), nl, !;
        capacity(Cap),
        NewCap is X + Cap,
        (
            NewCap > 100, 
            write('Your inventory excess its capacity!!'),!;
            price(ITEM, PRICE),
            A is X*PRICE,
            money(MONEY),
            (
                MONEY >= A,
                MONEY_AFTER is MONEY-A,
                retract(money(_)),
                asserta(money(MONEY_AFTER)),
                Stock is STOCK-X,
                retract(stock(ITEM, _)),
                asserta(stock(ITEM, Stock)),
                retract(inventory(ITEM,alchemist,Y)), Z is X+Y,    
                asserta(inventory(ITEM,alchemist,Z)),
                write('You bought '),write(X),write(' '), write(ITEM), write('(s)'), nl, !;
                write('You dont have enough money\n')
            )
        )
    ), !.
    
    

getPotion(_):-
    write('It\'s not a valid request\n'), !.

restock:-
    forall(inventory(Items, alchemist, _), stock(Items, 0), (
        random(1,3,Stock),
        retract(stock(Items, _)),
        asserta(stock(Items, Stock))
    )), !.

