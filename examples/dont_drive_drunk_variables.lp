% Uncomment if using gringo/clingo
% theory label {t { }; &label/0: t, any}.

person(gabriel) :- not person(clare).
person(clare) :- not person(gabriel).

drive(gabriel).
resist(gabriel).
alcohol(gabriel, 40).

drive(clare).
alcohol(clare, 0).

punish(P) :- &label{"% has driven drunk", P, caca(P,A)},
    drive(P), alcohol(P,A), A>30.

punish(P) :- &label{"% has resisted to authority", P},
    resist(P).

%!label {"% has been sentenced to prison", P}
sentence(P, prison) :-  punish(P).

%!weak
%:- constraint_body.

sentence(P, innocent) :- &label{"% is innocent until proven guilty",P},
    person(P), not sentence(P, prison).

%-sentence(P, cristal) :- person(P).


%!explain sentence(P, X) :- P=gabriel.

% !label_atoms {"% has been sentenced to %",P,S} sentence(P,S).
%!label_atoms {"% was driving",P} drive(P).
%!label_atoms {"% was drunk",P} alcohol(P,A) :- A>30.
%!label_atoms {"% has resisted to authority",P} resist(P).
