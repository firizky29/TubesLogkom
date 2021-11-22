:- dynamic(carrot_seed / 1).
:- dynamic(gameState / 1). /* gameState(isGameOn/Off) */
:- include('map.pl').

gameState(0).

turnOnGame :-
    retract(gameState(_)),
    asserta(gameState(1)).

/* Rule */

start :- 
    gameState(0),
    write(' _   _                           _      _    _                    '), nl,
    write('| | | | __ _ _ ____   _____  ___| |_   | \\  / | ___   ___  _  __  '), nl,
    write('| |_| |/ _` | \'__\\ \\ / / _ \\/ __| __|  |  \\/  |/ _ \\ / _ \\| |/  | '), nl,
    write('|  _  | (_| | |   \\ V /  __/\\__ \\ |_   | |\\/| | (_) | (_) |  /| | '), nl,
    write('|_| |_|\\__,_|_|    \\_/ \\___||___/\\__|  |_|  |_|\\___/ \\___/|_| |_| '), nl,
    nl,
    write('I Got Scammed By My Client And Have to Restart My Life As A Farmer'), nl,
    nl,
    write('           A Farmers Life is Not That Bad, I Think'), nl,
    nl,
    write('=================================================================='), nl,
    nl,
    write('                   Permainan telah dimulai'), nl,
    nl,
    write('>> Ketik help untuk mengecek command-command yang tersedia!'), 
    turnOnGame, !.
  
start :-
    write('Kamu sudah memulai game!').

help :-
    write('Daftar command :'), nl,
    nl,
    write('1.  map'), nl,
    write('2.  w'), nl,
    write('3.  a'), nl,
    write('4.  s'), nl,
    write('5.  d'), nl,
    write('6.  market'), nl,
    write('7.  house'), nl,
    write('8.  ranch'), nl,
    write('9.  fish'), nl,
    write('10. dig'), nl,
    write('11. plant'), nl,
    write('12. harvest'), nl,
    write('13. inventory'), nl,
    write('14. status').
