time(0..H) :- horizon(H).
step(1..H) :- horizon(H).

block(1..N) :- nblocks(N).
location(table).
location(B):-block(B).

action(move(B,table)):- block(B).
action(move(B,C)):- block(B),block(C),B!=C.

% Generate actions
o(A,I) :- action(A), not no(A,I), step(I).
no(A,I) :- action(A), not o(A,I), step(I).
someaction(I) :- o(A,I), step(I).
:- o(A,I), o(B,I), A!=B, step(I).
:- not someaction(I), step(I).

unclear(C,J) :- h(on(B),C,J),block(C),time(J).
:- o(move(B,_),I), unclear(B,I-1), step(I).
:- o(move(_,L),I), unclear(L,I-1), step(I).
:- o(move(B,table),I), h(on(B),table,I-1), step(I).

% Direct effect
c(on(B),L,I) :- o(move(B,L),I), block(B),location(L),step(I).

% Inertia
%  !trace_rule {"Block % stays on % at t=%",F,V,I}
  h(F,V,I) :- h(F,V,I-1), not c(F,I), step(I).
% Axioms for caused
  h(F,V,J) :- c(F,V,J). 
  c(F,J)   :- c(F,V,J).

% goal
:- g(on(B),L), not h(on(B),L,H), horizon(H). 
#show o/2.
%!trace {"Block % was moved to the table at t=%",A,I} o(move(A,table),I).
%!trace {"Block % was moved on top of block % at t=%",A,B,I} o(move(A,B),I):B!=table.
%!show_trace o(A,I).

%!trace {"Block % is finally on %",B,L} h(on(B),L,H):horizon(H).
%!trace {"Block % was initially on %",B,L} h(on(B),L,0).
%!show_trace h(on(B),L,H) : horizon(H).

%!trace {"Block % is finally unclear",B,J} unclear(B,J).
%!show_trace unclear(B,H):horizon(H).
