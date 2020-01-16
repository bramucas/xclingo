
person(gabriel).
person(clare).

drive(gabriel).
resist(gabriel).
alcohol(gabriel, 40).

drive(clare).
alcohol(clare, 0).
-resist(clare).

punish(P) :- drive(P), alcohol(P,A), A>30.
punish(P) :- resist(P).

%!trace {"% has been sentenced to prison.",P}
sentence(P, prison) :-  punish(P).

%!trace {"% is innocent.",P}
sentence(P, innocent) :-person(P), not sentence(P, prison).




%%% TODO:

%!weak
%:- constraint_body.


%  %!trace
%  %!show_all
%  %!trace_all
%
%
