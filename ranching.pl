:- include('map.pl').
:- dynamic(animal_count/2).
:- dynamic(last_ranch_visit/1).

ranch_animal(ayam).
ranch_animal(sapi).
ranch_animal(domba).

animal_count(ayam,0).
animal_count(sapi,0).
animal_count(domba,0).

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

ayam :-
    tile(X,Y,ranch).
    % gotta research how ayam reproduce

domba :-
    tile(X,Y,ranch).
    % gotta research how domba reproduce

sapi :-
    tile(X,Y,ranch).
    % gotta research how sapis reproduce
    
