
:- include('item.pl').
:- dynamic(isMarket / 1).

isMarket(1).

market :-
    isMarket(0), 
    write('>> Anda tidak sedang berada di Market !'), nl,
    nl, !.

market :- 
    write('What do you want to do?'), nl,
    write('1. Buy'), nl,
    write('2. Sell'), nl. 

buy :-  
    isMarket(0), 
    write('>> Anda tidak sedang berada di Market !'), nl,
    nl, !.

buy :- 
    write('What do you want to buy?'), nl,
    write('1. Bibit wortel (50 golds)'), nl,
    write('2. Bibit lobak (50 golds)'), nl,
    write('3. Bibit kentang (50 golds)'), nl,
    write('4. Bibit bawang (50 golds)'), nl,
    write('5. Bibit tomat (50 golds)'), nl, 
    write('6. Ayam (500 golds)'), nl,
    write('7. Domba (1000 golds)'), nl,
    write('8. Sapi (1500 golds)'), nl,
    inventory(shovel,equipment,X), 
    inventory(fishing_rod,equipment,Y),
    A is X+1, B is Y+1,
    write('8. Level '), write(A), write(' shovel (300 golds)'), nl,
    write('9. Level '), write(B), write(' fishing rod (500 golds)'), nl,
    write('10.Exit'),
    nl,
    write('Masukkan nomor barang yang ingin dibeli!'), nl,
    nl,
    write('>> '),
    read(C), 
    nl,
    buy_choice(C).

buy_choice(X) :-
    X < 1,
    write('Masukkan nomor yang benar!!'), nl,
    nl,
    write('>> '),
    read(C),
    nl,
    buy_choice(C).

buy_choice(X) :-
    X > 10,
    write('Masukkan nomor yang benar!!'), nl,
    nl,
    write('>> '),
    read(C),
    nl,
    buy_choice(C).

buy_choice(1) :-
    write('How many do you want to buy?'), nl,
    read(X),
    retract(inventory(wortel,gardening,Y)), Z is X+Y,    
    asserta(inventory(wortel,gardening,Z)),
    write('>> Benih wortel sebanyak '), write(X), write(' biji telah berhasil dibeli !').

/*
buy_choice(2) :- .

buy_choice(3) :- .

buy_choice(4) :- .

buy_choice(5) :- .

buy_choice(6) :- .

buy_choice(7) :- .

buy_choice(8) :- .

buy_choice(9) :- .

*/

buy_choice(10) :-
    write('Thanks for coming.').

sell :- 
    isMarket(0), 
    write('>> Anda tidak sedang berada di Market !'), !.

sell :-
    write('Here are the items in your inventory'), nl,
    nl,
    tampilInventory(), nl,
    nl.

/*

wortel :- .

lobak :- .

kentang :- .

bawang :- .

tomat :- .

ayam :- .

domba :- .

sapi :- .

*/