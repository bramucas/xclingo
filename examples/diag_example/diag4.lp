
plength(1).

time(0..L) :- plength(L).

fluent(F) :- domain(F,_).
domain(s1,open). domain(s1,closed).
domain(s2,open). domain(s2,closed).
domain(light,on). domain(light,off).
domain(protect,on). domain(protect,off).
domain(relayline,on). domain(relayline,off).
domain(bulb,ok). domain(bulb,broken).
domain(relay,ok). domain(relay,broken).

agent(close(s1)).

%%% Diagnostics
exog(break).
exog(surge).
%-------


action(Y):-exog(Y).
action(Y):-agent(Y).

% Inertia
h(F,V,T) :- h(F,V,T-1), not -h(F,V,T), time(T),T>0.

% any value not holding is -h
-h(F,V,T) :- h(F,W,T),domain(F,V),W!=V,time(T).

% Direct effects
h(s1,closed,T) :- o(close(s1),T), time(T),T>0.

% Indirect effects
%!trace_rule {"The relay is pulling at %",T}
  h(relayline,on,T)   :- h(s1,closed,T), h(relay,ok,T), time(T).

%!trace_rule {"The relay is not pulling at %",T}
  h(relayline,off,T)  :- h(s1,open,T), time(T).


% When damaged ....
%!trace_rule {"The relay is not pulling at %",T}
  h(relayline,off,T)  :- h(relay,broken,T), time(T).




h(s2,closed,T)  :- h(relayline,on,T), time(T).


h(light,on,T)    :- h(s2,closed,T), h(bulb,ok,T), time(T).
h(light,off,T)   :- h(s2,open,T), time(T).
%When damaged....
h(light,off,T)   :- h(bulb,broken,T), time(T).

%!trace {"The light is % at %",V,T} h(light,V,T): T>0.


% Executability
  :- o(close(S),T), h(S,closed,T-1), time(T),T>0.

% Malfunctioning
%!trace_rule {"The bulb has been damaged at %",T}
  h(bulb,broken,T) :- o(break,T), time(T),T>0.

%!trace_rule {"The relay has been damaged at %",T}
  h(relay,broken,T) :- o(surge,T), time(T),T>0.

%!trace_rule {"The bulb has been damaged at %",T}
  h(bulb,broken,T) :- o(surge,T), not h(protect,on,T-1), time(T),T>0.

% Something happening actually occurs
  o(A,I) :- obs_o(A,I), time(T),T>0.

% Check that observations hold
  :- obs_h(F,V,J), not h(F,V,J).

% Completing the initial state
%   1 {h(F,V,0):domain(F,V)} 1 :- fluent(F).

  h(F,V,0) :- domain(F,V), not -h(F,V,0).

% A history
obs_h(s1,open,0).
obs_h(s2,open,0).
obs_h(protect,on,0).
obs_h(bulb,ok,0).
obs_h(relay,ok,0).
obs_o(close(s1),1).
% Something went wrong
obs_h(light,off,1).



%!trace {"Hypothesis: there has been a power surge at %",T} o(surge,T).

%!trace {"Hypothesis: something has broken the bulb at %",T} o(break,T).

%!trace {"The agent has closed switch s1 at %",T} o(close(s1),T).



% Diagnostic module: generate exogenous actions

% { o(Z,I): exog(Z) } :- time(T),T>0.

  o(Z,T) :- time(T),T>0, exog(Z), not -o(Z,T).
  -o(Z,T) :- time(T),T>0, exog(Z), not o(Z,T).


%o(surge,1). 
%:- o(break,1).


%!show_trace h(light,V,1).
%!show_trace h(relayline,V,1).
%!show_trace o(A,B).

%!trace {"% was initially %",F,V} h(F,V,0).
