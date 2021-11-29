:- dynamic(animal_buy/3).
cheat :- 
    % initMap,
    retract(playerLoc(_, _)),
    tile(X,Y,marketplace),
    asserta(playerLoc(X,Y)), !.

market :- 
    playerLoc(X,Y),
    tile(X,Y,marketplace),
    write('What do you want to do?'), nl,
    write('1. Buy'), nl,
    write('2. Sell'), nl, !. 

market :-
    write('>> Anda tidak sedang berada di Market !'), nl,
    nl, !.

buy :- 
    playerLoc(X,Y),
    tile(X,Y,marketplace),
    write('Apa yang ingin anda beli?'), nl,
    nl,
    price(bibit_wortel, PRICE_WORTEL),
    write('1. Bibit wortel ('), write(PRICE_WORTEL), write(' golds)'), nl,
    price(bibit_lobak, PRICE_LOBAK),
    write('2. Bibit lobak ('), write(PRICE_LOBAK), write(' golds)'), nl,
    price(bibit_kentang, PRICE_KENTANG),
    write('3. Bibit kentang ('), write(PRICE_KENTANG), write(' golds)'), nl,
    price(bibit_bawang, PRICE_BAWANG),
    write('4. Bibit bawang ('), write(PRICE_BAWANG), write(' golds)'), nl,
    price(bibit_tomat, PRICE_TOMAT),
    write('5. Bibit tomat ('), write(PRICE_TOMAT), write(' golds)'), nl, 
    price(ayam, PRICE_AYAM),
    write('6. Ayam ('), write(PRICE_AYAM), write(' golds)'), nl,
    price(domba, PRICE_DOMBA),
    write('7. Domba ('), write(PRICE_DOMBA), write(' golds)'), nl,
    price(sapi, PRICE_SAPI),
    write('8. Sapi ('), write(PRICE_SAPI), write(' golds)'), nl,
    inventory(shovel,equipment,LV_SHOVEL), 
    inventory(fishing_rod,equipment,LV_ROD),
    A is LV_SHOVEL+1, B is LV_ROD+1,
    (
        price_upgrade_to(shovel,A,PRICE_UPGRADE_SHOVEL),A < 4, write('9. Level '), write(A), write(' shovel ('), write(PRICE_UPGRADE_SHOVEL), write(' golds)'); 
        A >= 4, write('9. Shovel anda sudah mencapai max level')
    ), nl,
    (
        price_upgrade_to(fishing_rod,B,PRICE_UPGRADE_ROD), write('10.Level '), write(B), write(' fishing rod ('), write(PRICE_UPGRADE_ROD), write(' golds)');
        A >= 4, write('10.Fishing rod anda sudah mencapai max level')
    ), nl,
    write('11.Exit'), nl,
    nl,
    write('Masukkan nomor barang yang ingin dibeli!'), nl,
    nl,
    write('>> '),
    read(C), 
    nl,
    (
    C =:= 1, buy_choice(bibit_wortel);
    C =:= 2, buy_choice(bibit_lobak);
    C =:= 3, buy_choice(bibit_kentang);
    C =:= 4, buy_choice(bibit_bawang);
    C =:= 5, buy_choice(bibit_tomat);
    C =:= 6, buyanimal_choice(ayam);
    C =:= 7, buyanimal_choice(domba);
    C =:= 8, buyanimal_choice(sapi);
    C =:= 9, upgrade_choice(shovel, A);
    C =:= 10, upgrade_choice(fishing_rod, B);
    C =:= 11, write('Terimakasih telah berkunjung ke shop !!');
    write('Masukan anda salah!'), nl, nl, buy), 
    !.

buy :-  
    write('>> Anda tidak sedang berada di Market !'), nl,
    nl, !.

buy_choice(ITEM) :-
    write('Berapa banyak '), write(ITEM), write(' yang ingin anda beli?'), nl,
    nl, write('>> '),
    read(X),
    nl,
    price(ITEM, PRICE),
    A is X*PRICE,
    money(MONEY),
    (MONEY >= A,
    MONEY_AFTER is MONEY-A,
    retract(money(_)),
    asserta(money(MONEY_AFTER)),
    retract(inventory(ITEM,TYPE,Y)), Z is X+Y,    
    asserta(inventory(ITEM,TYPE,Z)),
    write(ITEM), write(' sebanyak '), write(X), write(' telah berhasil dibeli !'), !; 
    write('Uang anda tidak mencukupi !!')).

buyanimal_choice(ITEM) :-
    animal_count(ITEM,Y),
    Y > 5,
    write(ITEM), write(' sudah mencapai max capacity (5)'),
    !.
    
buyanimal_choice(ITEM) :-
    write('Berapa banyak '), write(ITEM), write(' yang ingin anda beli?'), nl,
    nl, write('>> '),
    read(X),
    nl,
    price(ITEM, PRICE),
    A is X*PRICE,
    money(MONEY),
    (MONEY >= A,
    MONEY_AFTER is MONEY-A,
    retract(money(_)),
    asserta(money(MONEY_AFTER)),
    day(DAY),
    (
        animal_buy(ITEM,COUNT,DAY),
        retract(animal_buy(ITEM,COUNT,DAY)), NEWCOUNT is COUNT+X,
        asserta(animal_buy(ITEM,NEWCOUNT,DAY));
        asserta(animal_buy(ITEM,X,DAY))
    ),
    retract(animal_count(ITEM,Y)), Z is X+Y,  
    asserta(animal_count(ITEM,Z)),
    write(ITEM), write(' sebanyak '), write(X), write(' telah berhasil dibeli !'), !; 
    write('Uang anda tidak mencukupi !!')).

upgrade_choice(ITEM, LV) :-
    price_upgrade_to(ITEM,LV,PRICE),
    money(MONEY),
    (MONEY >= PRICE,
    MONEY_AFTER is MONEY-PRICE,
    retract(money(_)),
    asserta(money(MONEY_AFTER)),
    retract(inventory(ITEM,TYPE,Y)), Z is 1+Y,    
    asserta(inventory(ITEM,TYPE,Z)),
    write(ITEM), write(' telah berhasil di upgrade ke level '), write(LV), write(' !! '), !; 
    write('Uang anda tidak mencukupi !!')).

tampilinventory :- 
    forall(inventory(X, fish, _A), writeinvent(X,_, _A)),
    forall(inventory(Y, gardening, _B), writeinvent(Y,_, _B)),
    forall(inventory(Z, produce, _C), writeinvent(Z,_, _C)),
    !.

sell :- 
    playerLoc(X,Y),
    tile(X,Y,marketplace), 
    write('Anda memiliki beberapa item di inventory :'),nl,nl,
    tampilinventory,
    nl, write('Apa yang ingin anda jual? (nama item)'),nl,nl,
    write('>> '),read(ITEM), nl,
    sell_choice(ITEM),
    !.
    

sell :-
    write('Anda tidak sedang berada di Market !').

plusSell(PRICE,TYPE,PLUS) :-
    playerLevel(TYPE,LVL),
    playerLevel(total,LVL_TOT),
    (
        playerRole(TYPE),
        PLUS is (LVL*PRICE*45)//100 + LVL_TOT*5;
        PLUS is (LVL*PRICE*25)//100 + LVL_TOT*5
    ).

sell_choice(ITEM) :-
    write('Berapa banyak '), write(ITEM), write(' yang ingin anda jual?'), nl,
    nl, write('>> '),
    read(X),
    nl,
    inventory(ITEM,_TYPE,Y),
    itemType(ITEM,I_TYPE),
    price(ITEM, PRICE),
    money(MONEY),
    (
        X =< Y,
        plusSell(PRICE,I_TYPE,PLUS),
        MONEY_GAIN is X*PRICE+PLUS,
        MONEY_AFTER is MONEY+MONEY_GAIN,
        retract(money(_)),
        asserta(money(MONEY_AFTER)),
        retract(inventory(ITEM,_TYPE,Y)), Z is Y-X,    
        asserta(inventory(ITEM,_TYPE,Z)),
        write(ITEM), write(' sebanyak '), write(X), write(' telah berhasil dijual seharga '), write(MONEY_GAIN), write(' gold !'),
        nl,nl, write('Uang anda sekarang : '), write(MONEY_AFTER), write(' gold'), goalGame(MONEY_AFTER);
        write('Jumlah barang di inventory kamu kurang dari '), write(X)
    ), !.