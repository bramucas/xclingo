
person(gabriel).
person(clare).

drive(gabriel).
resist(gabriel).
alcohol(gabriel, 40).

drive(clare).
alcohol(clare, 0).


punish(P) :- drive(P), alcohol(P,A), A>30.
punish(P) :- resist(P).

%!label_rule {"% has been sentenced to %",P,prison}
sentence(P, prison) :-  punish(P).

%!label_rule {"% is innocent.",P}
sentence(P, innocent) :-person(P), not sentence(P, prison).

%!explain sentence(P, X).

%!label_atoms {"% was driving",P} drive(P).
%!label_atoms {"% was drunk",P} alcohol(P,A) :- A>30.
%!label_atoms {"% has resisted to authority",P} resist(P).


%%% TODO:

%!weak
%:- constraint_body.

