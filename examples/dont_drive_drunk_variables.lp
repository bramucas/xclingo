
person(gabriel).
person(clare).

drive(gabriel).
resist(gabriel).
alcohol(gabriel, 40).

%!trace {"% has driven a car",P} drive(P).
%!trace {"% was drunk",P} alcohol(P,A):A>30.

drive(clare).
alcohol(clare, 0).
-resist(clare).

%!trace_rule {"% has driven drunk",P}
punish(P) :- drive(P), alcohol(P,A), A>30.
%!trace_rule {"% has resisted to authority",P}
punish(P) :- resist(P).

%!trace_rule {"% has been sentenced to prison.",P}
sentence(P, prison) :-  punish(P).

%!trace_rule {"% is innocent.",P}
sentence(P, innocent) :- person(P), not sentence(P, prison).

%%% TODO:

%!weak
%:- constraint_body.

%!show_trace sentence(P,prison).