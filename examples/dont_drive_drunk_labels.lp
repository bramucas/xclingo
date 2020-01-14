%!show_all sentence(P, X).

%!trace_all {"% was driving",P} drive(P).
%!trace_all {"% was drunk",P} alcohol(P,A) :- A>30.
%!trace_all {"% has resisted to authority",P} resist(P).
%!trace_all {"% has not resisted to authority",P} -resist(P).
