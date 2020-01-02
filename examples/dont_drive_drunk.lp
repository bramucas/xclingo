#theory label {t { }; &label/0: t, any}.

drive :- &label{d}.
drunk :- &label{k}.
resist :- &label{r}.

punish :- &label{m},
    resist.
punish :- &label{l},
    drive, drunk.

prison :- &label{e},
    punish.