
%!trace_rule {"this is a rule"}
n(1).

 n(2).

b(3). b(4).

%!trace_rule {"n is %, b is %",X,Y}
switch(-s1(X);s2(Y);s3(X)) :- n(X), b(Y).

