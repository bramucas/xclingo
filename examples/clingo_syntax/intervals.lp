%!trace {"Is a switch"}
    switch(1..3).

%!trace_all {"Is a button %", X} button(X).

ttrace_switch(1)

button(1..3).

%!trace {"Switch % can be toogled",S}
    can_be_toggled(S) :- switch(S).

%!trace {"Button % can be toogled",B}
    can_be_toggled(B) :- button(B).

%!show_all can_be_toggled(X).