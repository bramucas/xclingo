time(0..L) :- plength(L).

fluent(F) :- domain(F,_X).
domain(s1,open). domain(s1,closed).
domain(s2,open). domain(s2,closed).
domain(light,on). domain(light,off).
domain(protect,on). domain(protect,off).
domain(relayline,on). domain(relayline,off).

agent(toggle(s1)).
action(Y):-agent(Y).

% Inertia
%chungo2 !trace_rule {"% persited % at %",F,V,T}
h(F,V,T) :- h(F,V,T-1), not c(F,T), time(T),T>0.

c(F,T)   :- c(F,V,T).
h(F,V,T) :- c(F,V,T).

%chungo1 !trace {"the value of % is % at %",F,V,T} h(F,V,T).


% Direct effects
%!trace_rule {"s1 is closed at %",T}
c(s1,closed,T) :- o(toggle(s1),T), h(s1,open,T-1), time(T),T>0.

%!trace_rule {"s1 is open at %",T}
c(s1,open,T) :- o(toggle(s1),T), h(s1,closed,T-1), time(T),T>0.

% try using negation not h(s1,open,T-1)

% Indirect effects
%!trace_rule {"The relay is working at %",T}
    c(relayline,on,T)   :- h(s1,closed,T), not h(relay,broken,T), time(T).

%!trace_rule {"The relay is not working at %",T}
    c(relayline,off,T)  :- h(s1,open,T), time(T).

%!trace_rule {"s2 is closed at %",T}
c(s2,closed,T)  :- h(relayline,on,T), time(T).

%!trace_rule {"the light is on at %",T}
c(light,on,T)    :- h(s2,closed,T), not h(bulb,broken,T), time(T).
%!trace_rule {"the light is off at %",T}
c(light,off,T)   :- h(s2,open,T), time(T).

% Completing the initial state
%   1 {h(F,V,0):domain(F,V)} 1 :- fluent(F).
h(F,V,0) :- domain(F,V), not -h(F,V,0).
% any value not holding is -h
-h(F,V,0) :- h(F,W,0), domain(F,V), W!=V.


%!show_trace h(light,V,T) : plength(T).
%!show_trace h(relayline,V,T): plength(T).

%!trace {"% was initially %",F,V} h(F,V,0) : F!=relayline, F!=light.
%!trace {"The agent toggled s1 at %", T} o(toggle(s1), T).

#show o/2.
#show h/3.
