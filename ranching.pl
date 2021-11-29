:- dynamic(animal_count/2).
:- dynamic(animal_production/2).

animal_production(sapi, 0).
animal_production(domba, 0).
animal_production(ayam, 0).

animal_buy(ayam,0,0).
animal_buy(sapi,0,0).
animal_buy(domba,0,0).

ranch_animal(ayam).
ranch_animal(sapi).
ranch_animal(domba).

animal_count(ayam,0).
animal_count(sapi,0).
animal_count(domba,0).

itemExp(susu, 10).
itemExp(telur, 5).
itemExp(sutra, 12).

displayAnimal(X):-
    animal_count(X,Y),
    Y > 0,
    write(Y),write(' '),write(X),nl.
    displayAnimal(_):-
    !.

ranchCheat :-
    retract(playerLoc(_, _)),
    tile(X,Y,ranch),
    asserta(playerLoc(X,Y)), !.

ranch :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    forall(animal_count(_, Count), Count=:=0),
    write('You have no animal, you can buy it at the marketplace!'), nl, !.

ranch :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    write('Welcome to the ranch! You have:'),nl,
    forall(ranch_animal(Animal), (
        displayAnimal(Animal)
    )),
    write('What animal do you want to inspect? (type the kind of animal to be inspected)'),nl,
    write('>>> '),
    read(Animal),
    viewAnimal(Animal),!.


daily_production_limit(ayam, 3).
daily_production_limit(sapi, 3).
daily_production_limit(domba, 1).

production(Animal) :-
    day(D),
    forall(animal_buy(Animal, Count, DayTaken), (
        random(P),
        animal_production(Animal, X),
        Diff is D - DayTaken,
        daily_production_limit(Animal, Limit),
        Y is X + Count * Diff * round(Limit * P),
        retract(animal_production(Animal, X)),
        asserta(animal_production(Animal, Y))
    )), !.

production_return(Animal):-
    day(D),
    findall(Count, animal_buy(Animal, Count, _), L),
    sum_list(L, Counts),
    retractall(animal_buy(Animal, _, _)),
    asserta(animal_buy(Animal, Counts, D)), 
    retract(animal_production(Animal, _)),
    asserta(animal_production(Animal, 0)),
    !.

increaseRanchingExp(ProductionCount, Exp, Item) :-
    itemExp(Item, Gain),
    Exp is ProductionCount * Gain, !.

viewAnimal(_) :-
    capacity(Capacity),
    Capacity >= 100,
    write('You have no capacity to store the products yield by animal, better sell or throw some first!'), nl, !.

viewAnimal(ayam) :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    production(ayam),
    animal_production(ayam,M),
    M > 0,
    write('Your chicken lays '),
    write(M),
    write(' eggs.'),nl,
    inventory(telur, produce, ExistingEggs),
    NewEggs is ExistingEggs + M,
    retract(inventory(telur, produce, _)),
    asserta(inventory(telur, produce, NewEggs)),
    write('Now, you have '),
    write(NewEggs),
    write(' eggs.'),nl,
    animalGain(telur, M),
    production_return(ayam),
    !.

viewAnimal(ayam) :-
    write('Your chicken lays no eggs today <(＿　＿)>'),nl,!.

viewAnimal(domba) :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    production(domba),
    animal_production(domba,M),
    M > 0,
    write('Your sheep produces '),
    write(M),
    write(' kg of wool.'),nl,
    inventory(sutra, produce, ExistingWool),
    NewWool is ExistingWool + M,
    retract(inventory(sutra, produce, _)),
    asserta(inventory(sutra, produce, NewWool)),
    write('Now, you have '),
    write(NewWool),
    write(' kg of wool.'),nl,
    animalGain(sutra, M), 
    production_return(domba),
    !.

viewAnimal(domba) :-
    write('Your sheep create no wools today <(＿　＿)>'),nl,!.

viewAnimal(sapi) :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    production(sapi),
    animal_production(sapi,M),
    M > 0,
    write('Your cow produces '),
    write(M),
    write(' litres of milk.'),nl,
    inventory(susu, produce, ExistingMilk),
    NewMilk is ExistingMilk + M,
    retract(inventory(susu, produce, _)),
    asserta(inventory(susu, produce, NewMilk)),
    write('Now, you have '),
    write(NewMilk),
    write(' litres of milk.'),nl,
    animalGain(susu, M), 
    production_return(sapi),
    !.

viewAnimal(sapi) :-
    write('Your cow is\'nt producing any milk today <(＿　＿)>'),nl,!.

viewAnimal(_) :-
    write('No animal like that here!'),nl,!.

animalGain(Item, M):-
    addProgress(Item, 1),
    increaseRanchingExp(M, Exp, Item),
    gainExp(ranch, Exp),
    TotalExp is (Exp*120) div 100,
    gainExp(total, TotalExp),
    write('You gained '),
    write(TotalExp),
    write(' Exp and '),
    write(Exp),
    write(' Ranching Exp. \nAwesome!\n'),
    !.

animalGain(Item, M):-
    increaseRanchingExp(M, Exp, Item),
    gainExp(ranch, Exp),
    TotalExp is (Exp*120) div 100,
    gainExp(total, TotalExp),
    write('You gained '),
    write(TotalExp),
    write(' Exp and '),
    write(Exp),
    write(' Ranching Exp. \nAwesome!\n'),
    !.