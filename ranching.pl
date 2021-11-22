:- include('map.pl').
:- dynamic(animal_count/2).
:- dynamic(last_ranch_visit/1).
ranch_animal(chicken).
ranch_animal(cow).
ranch_animal(sheep).

animal_count(chicken,0).
animal_count(cow,0).
animal_count(sheep,0).

last_ranch_visit(0).

ranch :-
    tile(X,Y,ranch),
    write('Welcome to the ranch! You have:'),nl,
    forall(ranch_animal(Animal),
           (
               animal_count(Animal, Count),write(Count),write(Animal),nl
           )
          ),
    write('What do you want to do?'),nl.

chicken :-
    tile(X,Y,ranch).
    % gotta research how chicken reproduce

sheep :-
    tile(X,Y,ranch).
    % gotta research how sheep reproduce

cow :-
    tile(X,Y,ranch).
    % gotta research how cows reproduce
    
