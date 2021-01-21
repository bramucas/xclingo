r.

%!trace_rule {"this is p"}
    p :- r.

%!trace_rule {"this is fact a(1)"}
    a(1).
a(2).

b.
b :- p.

%!trace_rule {"this is c, oh shit"}
c :- b, a(X).


%!trace {"this is fact b"} b.
%!trace {"This is also fact a(%)",X} a(X).
%!trace {"r here!"} r.
