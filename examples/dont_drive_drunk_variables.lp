
person(gabriel).
person(clare).

drive(gabriel).
resist(gabriel).
alcohol(gabriel, 40).

drive(clare).
alcohol(clare, 0).


punish(P) :- drive(P), alcohol(P,A), A>30.
punish(P) :- resist(P).

%!trace {"% has been sentenced to prison.",P}
sentence(P, prison) :-  punish(P).

%!trace {"% is innocent.",P}
sentence(P, innocent) :-person(P), not sentence(P, prison).

%!show_all sentence(P, X).

%!trace_all {"% was driving",P} drive(P).
%!trace_all {"% was drunk",P} alcohol(P,A) :- A>30.
%!trace_all {"% has resisted to authority",P} resist(P).


%%% TODO:

%!weak
%:- constraint_body.


%  %!trace
%  %!show_all
%  %!trace_all
%
%
