:- dynamic(itemType / 1).
:- dynamic(inventory / 3).
% Item Type
itemType(arwana,fish).
itemType(gurame,fish).
itemType(lele,fish).
itemType(mujair,fish).
itemType(nila,fish).
% itemType(gardening).
itemType(wortel,farm).
itemType(lobak,farm).
itemType(kentang,farm).
itemType(bawang,farm).
itemType(tomat,farm).
% itemType(equipment).
% itemType(seed).
% itemType(produce).
itemType(telur,ranch).
itemType(sutra,ranch).
itemType(susu,ranch).

itemType(farmPotion, alchemist).
itemType(fishPotion, alchemist).
itemType(ranchPotion, alchemist).
itemType(bottleExp, alchemist).
itemType(fatigueCure, alchemist).


% Inventory 
inventory(arwana, fish, 0).
inventory(gurame, fish, 0).
inventory(lele, fish, 0).
inventory(mujair, fish, 0).
inventory(nila, fish, 0).
inventory(wortel, gardening, 0).
inventory(lobak, gardening, 0).
inventory(kentang, gardening, 0).
inventory(bawang, gardening, 0).
inventory(tomat, gardening, 0).
inventory(fishing_rod,equipment,0).
inventory(shovel,equipment,0).
inventory(bibit_wortel, seed, 0).
inventory(bibit_lobak, seed, 0).
inventory(bibit_kentang, seed, 0).
inventory(bibit_bawang, seed, 0).
inventory(bibit_tomat, seed, 0).
inventory(telur, produce, 0).
inventory(sutra, produce, 0).
inventory(susu, produce, 0).
inventory(farmPotion, alchemist, 0).
inventory(fishPotion, alchemist, 0).
inventory(ranchPotion, alchemist, 0).
inventory(bottleExp, alchemist, 0).
inventory(fatigueCure, alchemist, 0).

% Harga Jual
price(arwana, 100).
price(gurame, 26).
price(lele, 14).
price(mujair, 18).
price(nila, 16).	
price(wortel, 10).
price(lobak, 8).
price(kentang, 12).
price(bawang, 16).
price(tomat, 8).
price(telur, 100).
price(sutra, 150).
price(susu, 200).
% Harga Beli
price(bibit_wortel, 5).
price(bibit_lobak, 4).
price(bibit_kentang, 6).
price(bibit_bawang, 8).
price(bibit_tomat, 4).
price(ayam, 200).
price(domba, 300).
price(sapi, 400).

price(farmPotion, 5000).
price(fishPotion, 5000).
price(ranchPotion, 5000).
price(bottleExp, 6500).
price(fatigueCure, 500).


%  Harga Upgrade Equipment
price_upgrade_to(shovel,1,200).
price_upgrade_to(shovel,2,400).
price_upgrade_to(shovel,3,800).
price_upgrade_to(fishing_rod,1,200).
price_upgrade_to(fishing_rod,2,400).
price_upgrade_to(fishing_rod,3,800).

writeinvent(NAME, equipment, LV) :-
    inventory(NAME, equipment, LV),
    LV > 0,
    write('-  Level '), write(LV), write(' '), write(NAME), nl, !. 

writeinvent(NAME, seed, COUNT) :-
    inventory(NAME, seed, COUNT),
    COUNT > 0,
    write('-  '), write(COUNT), write(' '), write(NAME), nl, !. 

writeinvent(NAME, _, COUNT) :-
    COUNT > 0,
    write('-  '), write(COUNT), write(' '), write(NAME), nl. 

writeinvent(_, _, _) :-
    !. 

inventory :- 
    forall(inventory(_,_,Count), Count =:= 0),
    write('-. Inventory Kosong !'),!;
    capacity(CAP),
    write('Your inventory ('), write(CAP), write(')'), nl, nl,
    forall(inventory(X, _, _A), writeinvent(X, _, _A)),!.
    
capacity(X) :- 
    findall(CountAll, inventory(_, _, CountAll), LAll),
    sum_list(LAll, ALL),
    findall(CountEq, inventory(_,equipment,CountEq), LEq),
    sum_list(LEq, Eq),
    findall(1, inventory(_,equipment,0), LEqNull),
    sum_list(LEqNull, EqNull),
    X is ALL - Eq + 2 - EqNull.

throwItem :-
    inventory,
    capacity(Cap),
    Cap > 0,
    nl, write('Apa yang ingin anda buang? (nama item)'), nl, nl,
    write('>> '),read(ITEM), nl,
    (ITEM == fishing_rod, 
        write('Equiment tidak dapat dibuang');
     ITEM == shovel, 
        write('Equiment tidak dapat dibuang');
     throw_choice(ITEM)
    ),
    !.

throwItem.

usePotion :-
    forall(inventory(_,alchemist,Count), Count =:= 0),
    write('-. You dont have any potion(s)!'),!;
    findall(Items, (inventory(Items, alchemist, Y), Y>0), L), 
    length(L, Len),
    forall((between(1, Len, I), nth1(I, L, Item), inventory(Item, alchemist, X)), (
        write(I), write('. '), write(Item), write(' | Count: '), write(X), nl
    )),
    write('Type the name of potion you wish to use?\n'),
    write('\n>>> '),
    read(Potion), 
    effectPotion(Potion),
    !.

effectPotion(ranchPotion):-
    gainExp(ranch, 1000),
    write('Wow, you gained 1000 ranching Exp!\n'), 
    retract(inventory(ranchPotion, _, X)),
    X_New is X-1,
    asserta(inventory(ranchPotion, _, X_New)),
    !.

effectPotion(fishPotion):-
    gainExp(fish, 1000),
    write('Wow, you gained 1000 fishing Exp!\n'), 
    retract(inventory(fishPotion, _, X)),
    X_New is X-1,
    asserta(inventory(fishPotion, _, X_New)),
    !.

effectPotion(farmPotion):-
    gainExp(farm, 1000),
    write('Wow, you gained 1000 farming Exp!\n'), 
    retract(inventory(farmPotion, _, X)),
    X_New is X-1,
    asserta(inventory(farmPotion, _, X_New)),
    !.

effectPotion(bottleExp):-
    gainExp(total, 2000),
    write('Wow, you gained 2000 Exp!\n'), 
    retract(inventory(bottleExp, _, X)),
    X_New is X-1,
    asserta(inventory(bottleExp, _, X_New)),
    !.

effectPotion(fatigueCure):-
    retract(drainedEnergy(_)),
    asserta(drainedEnergy(2)),
    playerLevel(total, Level),
    En is Level*100,
    retract(playerEnergy(_)),
    asserta(playerEnergy(En)),
    write('\nYou cured from the fatigue! cool!\n'),
    retract(inventory(fatigueCure, _, X)),
    X_New is X-1,
    asserta(inventory(fatigueCure, _, X_New)),  !.

effectPotion(_):-
    write('It is not a valid potion'), !.

throw_choice(ITEM) :-
    inventory(ITEM,_TYPE,Y),
    write('Berapa banyak '), write(ITEM), write(' yang ingin anda buang?'), nl,
    nl, write('>> '),
    read(X),
    nl,
    (   
        Y >= X,
        retract(inventory(ITEM,_TYPE,Y)), Z is Y-X,    
        asserta(inventory(ITEM,_TYPE,Z)),
        write(ITEM), write(' sebanyak '), write(X), write(' telah berhasil dibuang');
        write('Jumlah barang di inventory kamu kurang dari '), write(X)
    ), !.

throw_choice(_) :- 
    write('Barang tersebut tidak ada !'), !.