
plength(1).

time(0..L) :- plength(L).

fluent(F) :- domain(F,_X).
domain(s1,open). domain(s1,closed).
domain(s2,open). domain(s2,closed).
domain(light,on). domain(light,off).
domain(protect,on). domain(protect,off).
domain(relayline,on). domain(relayline,off).

agent(close(s1)).
action(Y):-agent(Y).

% Inertia
h(F,V,T) :- h(F,V,T-1), not -h(F,V,T), time(T),T>0.

% any value not holding is -h
-h(F,V,T) :- h(F,W,T), domain(F,V), domain(F,W), W!=V, time(T).

% Direct effects
h(s1,closed,T) :- o(close(s1),T), time(T),T>0.

% Indirect effects
%!trace_rule {"The relay is pulling at %",T}
    h(relayline,on,T)   :- h(s1,closed,T), time(T).

%!trace_rule {"The relay is not pulling at %",T}
    h(relayline,off,T)  :- h(s1,open,T), time(T).

h(s2,closed,T)  :- h(relayline,on,T), time(T).

h(light,on,T)    :- h(s2,closed,T), time(T).
h(light,off,T)   :- h(s2,open,T), time(T).

% Executability
:- o(close(S),T), h(S,closed,T-1), time(T),T>0.

%initial state
h(light, off, 0).
h(protect, on, 0).
h(relayline, off, 0).
h(s1, opened, 0).
h(s2, opened, 0).

o(close(s1), 1).

% Completing the initial state
%   1 {h(F,V,0):domain(F,V)} 1 :- fluent(F).
h(F,V,0) :- domain(F,V), not -h(F,V,0).

%!show_trace h(light,V,1).
%!show_trace h(relayline,V,1).
%!show_trace o(A,B).

%!trace {"The light is % at %",V,T} h(light,V,T) : T>0.
%!trace {"s1 is % at %",V,T} h(s1,V,T).
%!trace {"s2 is % at %",V,T} h(s2,V,T).
%!trace {"% was initially %",F,V} h(F,V,0).
%!trace {"Agent closed s1 at %", T} o(close(s1), T).