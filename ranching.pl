
:- dynamic(animal_count/2).
:- dynamic(last_ranch_visit_chicken/1).
:- dynamic(last_ranch_visit_cow/1).
:- dynamic(last_ranch_visit_sheep/1).

animal_buy(ayam,0,0).
animal_buy(sapi,0,0).
animal_buy(domba,0,0).


ranch_animal(ayam).
ranch_animal(sapi).
ranch_animal(domba).

animal_count(ayam,0).
animal_count(sapi,0).
animal_count(domba,0).

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
    write('You have no animal, you can buy it in the market!'), nl, !.

ranch :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    write('Welcome to the ranch! You have:'),nl,
    forall(ranch_animal(Animal),
           (
               displayAnimal(Animal)
           )
          ),
    write('What do you want to do?'),nl,
    read(Animal),
    viewAnimal(Animal),!.

% TODO: change egg production logic to depend on chickens's age
% Priority2 as it need to track every buys

daily_production_limit(ayam, 3).
daily_production_limit(sapi, 3).
daily_production_limit(domba, 1).

production(Animal,M) :-
    day(D),
    M is 0,
    forall(animal_buy(Animal, Count, DayBuy), (
        random(P),
        Diff is D - DayBuy,
        daily_production_limit(Animal, Limit),
        M is M + Count * Diff * round(Limit * P)
    )), !.

increaseRanchingExp(ProductionCount, M) :-
    M is ProductionCount * 4, 
    gainExp(ranch, M), !.

    
viewAnimal(ayam) :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    production(ayam,M),
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
    increaseRanchingExp(M, NewExp),
    write('You gain '),
    write(NewExp),
    write(' exp.'),nl,!.

viewAnimal(ayam) :-
    write('Your chicken lays no eggs today <(＿　＿)>'),nl,!.

viewAnimal(domba) :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    production(domba,M),
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
    increaseRanchingExp(M, NewExp),
    write('You gain '),
    write(NewExp),
    write(' exp.'),nl,!.

viewAnimal(domba) :-
    write('Your sheep create no wools today <(＿　＿)>'),nl,!.

viewAnimal(sapi) :-
    playerLoc(X,Y),
    tile(X,Y,ranch),
    production(sapi,M),
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
    increaseRanchingExp(M, NewExp),
    write('You gain '),
    write(NewExp),
    write(' exp.'),nl,!.

viewAnimal(sapi) :-
    write('Your cow not produce milks today <(＿　＿)>'),nl,!.

viewAnimal(_) :-
    write('No animal like that here!'),nl,!.