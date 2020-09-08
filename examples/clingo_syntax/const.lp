#const n=4.

step(1).
step(2).
step(3).
step(4).
step(5).
step(6).
step(7).
step(8).
step(9).
step(10).

n(X) :- X>=0, X<=n, step(X).
#show n/1.