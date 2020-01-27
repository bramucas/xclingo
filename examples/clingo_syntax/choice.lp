person(david). person(gabriel). person(manuel).

like_child(gabriel; manuel).
like_animals(david; manuel).

son_names(s1;s2;s3;s4;s5).
possible_pets(cat;dog;bird;fish;snake).

0 {son(S, X): like_child(X), son_names(S);  pet(P, X): like_animals(X), possible_pets(P)} 2 :- person(X).

#show pet/2.
#show son/2.

:- son(_X, david).
:- pet(_X, gabriel).