q.

%!trace_rule {"p"}
    p :- q.
%!trace_rule {"r"}
    r :- q.

s(p) :- p.
s(r) :- r.

%!trace {"s(r)"} s(X) : X=r.
%!trace {"s(p)"} s(X) : X=p.