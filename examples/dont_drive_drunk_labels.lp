%!show_trace sentence(P, X).

%!trace {"% was driving",P} drive(P).
%!trace {"% was drunk",P} alcohol(P,A) : A>30.
%!trace {"% has resisted to authority",P} resist(P).
%!trace {"% has not resisted to authority",P} -resist(P).
