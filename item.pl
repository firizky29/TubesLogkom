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
itemType(changeRole, alchemist).
itemType(bottleExp, alchemist).
itemType(fatigueCure, alchemist).


% Inventory 
inventory(arwana, fish, 0).
inventory(gurame, fish, 0).
inventory(lele, fish, 0).
inventory(mujair, fish, 0).
inventory(nila, fish, 0).
inventory(wortel, gardening, 0).
inventory(lobak, gardening, 1).
inventory(kentang, gardening, 1).
inventory(bawang, gardening, 1).
inventory(tomat, gardening, 1).
inventory(fishing_rod,equipment,1).
inventory(shovel,equipment,3).
inventory(watering,equipment,0).
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
inventory(changeRole, alchemist, 0).
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
price(changeRole, 10000).
price(bottleExp, 6500).
price(fatigueCure, 500).


%  Harga Upgrade Equipment
price_upgrade_to(shovel,1,100).
price_upgrade_to(shovel,2,100).
price_upgrade_to(shovel,3,100).
price_upgrade_to(fishing_rod,1,100).
price_upgrade_to(fishing_rod,2,100).
price_upgrade_to(fishing_rod,3,100).

writeinvent(NAME, equipment, LV) :-
    inventory(NAME, equipment, LV),
    LV > 0,
    write('-  Level '), write(LV), write(' '), write(NAME), nl, !. 

writeinvent(NAME, seed, COUNT) :-
    inventory(NAME, seed, COUNT),
    COUNT > 0,
    plantOfSeed(NAME, PLANT),
    write('-  '), write(COUNT), write(' '), write(PLANT), write(' seed'), nl, !. 

writeinvent(NAME, _, COUNT) :-
    COUNT > 0,
    write('-  '), write(COUNT), write(' '), write(NAME), nl. 

writeinvent(_, _, _) :-
    !. 

inventory :- 
    forall(inventory(_,_,Count), Count =:= 0),
    write('-. Inventory Kosong !'),!;
    forall(inventory(X, _, _A), writeinvent(X, _, _A)),!.
    