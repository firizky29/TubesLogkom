:- dynamic(questTarget/2). %questTarget(type, target)
:- dynamic(questTargetItem/2). %questTargetItem(type, item)
:- dynamic(questProgress/2).


questTarget(_, 0).
questProgress(_, 0).

targetBound(1, 1, 6).  %difficulty, lower bound target, upper bound target
targetBound(2, 5, 11).
targetBound(3, 10, 16).
targetBound(4, 15, 21).
targetBound(5, 20, 26).
targetBound(6, 25, 31).

questItemType(fish, fish).
questItemType(gardening, farm).
questItemType(produce, ranch).


generateDifficulty(Type, Difficulty):-
    playerRole(Type),
    playerLevel(Type, Level),
    Level =< 3,
    Difficulty is 2, !.

generateDifficulty(Type, Difficulty):-
    playerRole(Type),
    playerLevel(Type, Level),
    Level =< 5,
    Difficulty is 3, !.

generateDifficulty(Type, Difficulty):-
    playerRole(Type),
    playerLevel(Type, Level),
    Level =< 7,
    Difficulty is 4, !.

generateDifficulty(Type, Difficulty):-
    playerRole(Type),
    playerLevel(Type, Level),
    Level =< 9,
    Difficulty is 5, !.

generateDifficulty(Type, Difficulty):-
    playerRole(Type),
    Difficulty is 6, !.

generateDifficulty(Type, Difficulty):-
    playerLevel(Type, Level),
    Level =< 3,
    Difficulty is 1, !.

generateDifficulty(Type, Difficulty):-
    playerLevel(Type, Level),
    Level =< 5,
    Difficulty is 2, !.

generateDifficulty(Type, Difficulty):-
    playerLevel(Type, Level),
    Level =< 7,
    Difficulty is 3, !.

generateDifficulty(Type, Difficulty):-
    playerLevel(Type, Level),
    Level =< 9,
    Difficulty is 4, !.

generateDifficulty(_, Difficulty):-
    Difficulty is 5, !.

generateItem(Qtype, Item):-
    questItemType(Type, Qtype),
    findall(Items, inventory(Items, Type, _), L),
    length(L, Len),
    random(0, Len, Idx),
    nth0(Idx, L, Item), !.


allQuestCompleted:- 
    (playerRole(Type)), \+ (questProgress(Type, X), questTarget(Type, Y), X < Y).

generateQuestTarget:-
    generateDifficulty(fish, DifficultyFish),
    targetBound(DifficultyFish, Low1, Up1),
    random(Low1, Up1, Fish),
    generateDifficulty(ranch, DifficultyRanch),
    targetBound(DifficultyRanch, Low2, Up2),
    random(Low2, Up2, Ranch),
    generateDifficulty(farm, DifficultyFarm),
    targetBound(DifficultyFarm, Low3, Up3),
    random(Low3, Up3, Farm),
    retractall(questTarget(_,_)),
    asserta(questTarget(fish, Fish)),
    asserta(questTarget(ranch, Ranch)),
    asserta(questTarget(farm, Farm)),
    retractall(questProgress(_, _)),
    asserta(questProgress(fish, 0)),
    asserta(questProgress(ranch, 0)),
    asserta(questProgress(farm, 0)),
    generateItem(fish, FishItem),
    generateItem(ranch, RanchItem),
    generateItem(farm, FarmItem),
    retractall(questTargetItem(_,_)),
    asserta(questTargetItem(fish, FishItem)),
    asserta(questTargetItem(ranch, RanchItem)),
    asserta(questTargetItem(farm, FarmItem)),
    !.

quest:-
    allQuestCompleted,
    playerLoc(XP, YP),
    tile(XP, YP, quest),
    write('\nWow! you\'ve completed all the quests, type \'reward\' to claim your reward(s)\n'), !.

quest:-
    playerLoc(XP, YP),
    tile(XP, YP, quest),
    write('these are the quests you need to complete, cheers :D \n'),
    write('=================================================================\n'),
    findall(Items, questTargetItem(_, Items), L),
    forall((between(1, 3, I), nth1(I, L, Item), questTargetItem(Type, Item), questProgress(Type, A), questTarget(Type, B)), (
        write(I), write('. '), write(Item), write(' : '), write(A), write('/'), write(B), nl
    )), !.

quest:-
    allQuestCompleted,
    write('\nCongratulations! You\'ve completed all the quests, go to \'Q\' tile to claim your reward(s)\n'), !.

quest:-
    write('\nYou have (an) active quest(s), to find out what quest(s) to be completed, please come to the \'Q\' tile'), !.


