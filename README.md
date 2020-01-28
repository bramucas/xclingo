# xclingo
Explains the conclusions of logic programs.


### Python requirements

* Python 3.* or more.
* Python libraries:
  * [clingo module for python](https://potassco.org/clingo/).
  * pandas
  * more_itertools


### Warning

The complete clingo syntax is not supported yet. For example:

* Pools (i. e. ```p(a;b;c)```) are not supported yet.
* Aggregates and choice rules (i. e. ```1 {student(X): person(X) } 2```) are not supported yet. 

### Usage


```
usage: xclingo.py [-h]
                  [--debug-level {none,magic-comments,translation,causes}]
                  [--auto-tracing {none,facts,all}]
                  infile [infile ...]

Tool for debugging and explaining ASP programs

positional arguments:
  infile                ASP program

optional arguments:
  -h, --help            show this help message and exit
  --debug-level {none,magic-comments,translation,causes}
                        Points out the debugging level. Default: none.
  --auto-tracing {none,facts,all}
                        Automatically creates traces for the rules of the
                        program. Default: none.
```

### Examples of use

xclingo can help both to debug a logic program and to justify its conclusions by providing explanations. This explanations are built from 'traces' which are associated both with the rules and the atoms in the program. This 'traces' can be handwritten by the programmer or generated automatically. For example, we can obtain the explanations of the following program (examples/basic.lp)

```
q.

p :- q.
r :- q.

s(p) :- p.
s(r) :- r.
```

using xclingo with the command:  ```python xclingo.py --auto-tracing all examples/basic.lp``` (*--auto-tracing all* will cause xclingo to leave a trace of all the rules in the given program), getting the following output:
```
Answer: 1
>> q    [1]
  *
  |__q

>> p    [1]
  *
  |__p
  |  |__q

>> r    [1]
  *
  |__r
  |  |__q

>> s(p) [1]
  *
  |__s(p)
  |  |__p
  |  |  |__q

>> s(r) [1]
  *
  |__s(r)
  |  |__r
  |  |  |__q
```

Without the option ```--auto-tracing all``` we would get the following output insteead:

```
Answer: 1
>> q    [1]
        1

>> p    [1]
        1

>> r    [1]
        1

>> s    [1]
        1
```

since there are no traces for any rule or atom.


### Leaving custom traces

The user can manually leave a trace for a concrete rule using a ```%!trace_rule``` comment right before the rule we want to leave a trace for. Modifying the code in the following way:

```
q.

%!trace_rule {"p"}
    p :- q.
%!trace_rule {"r"}
    r :- q.

%!trace_rule {"s(p)"}
    s(p) :- p.
%!trace_rule {"s(r)"}
    s(r) :- r.
```

and excuting xclingo (```python xclingo.py examples/basic.lp```), will result in the following output:

```
Answer: 1
>> q    [1]
        1

>> p    [1]
  *
  |__"p"

>> r    [1]
  *
  |__"r"

>> s(p) [1]
  *
  |__"s(p)"
  |  |__"p"

>> s(r) [1]
  *
  |__"s(r)"
  |  |__"r"
```

Note that the explanation of the atom *q* is *1* since there is no traces for the rule that entails *q* in the program.

It's is also possible to leave a trace for a desired set of atoms at once using ```%!trace``` comment. For example, it is possible to leave a trace for the atoms ```s(r)``` and ```s(p)``` modifying the program in the following way:

```
q.

%!trace_rule {"p"}
    p :- q.
%!trace_rule {"r"}
    r :- q.

s(p) :- p.
s(r) :- r.

%!trace {"s"} s(X).  % It will afect to s(r) and s(p) and any other s/1 in the program.
```

What will produce the output:

```
Answer: 1
>> q    [1]
        1

>> p    [1]
  *
  |__"p"

>> r    [1]
  *
  |__"r"

>> s(p) [1]
  *
  |__"s"
  |  |__"p"

>> s(r) [1]
  *
  |__"s"
  |  |__"r"

```

Note that, while in the first example **each rule is being associated with a different trace**, in the second **all the atoms s(X) (X being anything) are being associated with the same trace "s"**.

Also, *%!trace* comments can add a condition in order to define the set of atoms that the user is leaving a trace for. For example we could change our previous *%!trace* by these two
```
%!trace {"s(r)"} s(X) : X=r.  % It will just affect to s(r)
%!trace {"s(p)"} s(X) : X=p.  % It will just affect to s(p)
```

### Showing only some atoms

In a similar way that with *#show* sentences in clingo, xclingo supports *%!show_trace* magic comments. For example we can use ```%!show_trace s(X).``` to command xlingo to print just the traces that explain s/1 atoms. 

In the same way as with *%!trace* comments the user can define the set of atoms that it wants to be shown by using a condition like this 
```
%!show_trace s(X) : X=r.  % Only the explanation of s(r) will be shown
```

### Example: building natural language explanations and handling variables within traces

The following is an example of how to use traces for generating custom natural language explanations of the conclusions of a program and how to use the value of the variables from a rule in the text of the traces.

The following program describes how a person P can be ```innocent``` or sentenced to ```prison``` if he/she ```drive``` while being ```drunk``` (his/her blood alcohol content is over 30) or they ```resist``` authority.

```
%%%%% examples/dont_drive_drunk.lp

person(gabriel). person(clare).

drive(gabriel).
resist(gabriel).
alcohol(gabriel, 40).

drive(clare).
alcohol(clare, 0).
-resist(clare).

punish(P) :- drive(P), alcohol(P,A), A>30.
punish(P) :- resist(P).

sentence(P, prison) :-  punish(P).

%!trace_rule {"% is innocent.",P}
    sentence(P, innocent) :- person(P), not sentence(P, prison).

%%%% labels
%!trace {"% was driving",P} drive(P).
%!trace {"% BCA over 30",P} alcohol(P,A) : A>30.
%!trace {"% has resisted to authority",P} resist(P).
%!trace {"% has not resisted authority",P} -resist(P).
%!trace {"% has been sentenced to %",P,S} sentence(P,S) : S!=innocent.

%!show_trace sentence(P, X).  % Explain all sentences


%%%% Other posible show_traces (delete spaces between '%' and '!' to activate one)
%%%% Note: different show_traces add up to each other
%  !show_trace sentence(P, innocent).        % All innocent sentences
%  !show_trace sentence(P, S) : S=prison.    % All prison sentences
%  !show_trace sentence(P, S) : resist(P).   % All sentences of persons who had been resisted authority
%  !show_trace sentence(P, S) : alcohol(P,A), A>30.   % All sentences of persons who had a BAC over 30
```

```python xclingo.py examples/dont_drive_drunk.lp``` will produce the following output:
```
Answer: 1
>> sentence(gabriel,prison)     [2]
  *
  |__"gabriel has been sentenced to prison."
  |  |__"gabriel has resisted to authority"

  *
  |__"gabriel has been sentenced to prison."
  |  |__"gabriel was driving"
  |  |__"gabriel was drunk"

>> sentence(clare,innocent)     [1]
  *
  |__"clare is innocent."
```

Note how the placeholder *%* inside the traces, is replaced by the value of the variables after solving. For example, in the previous example, you can see how the comment ```%!trace {"% has been sentenced to %",P,S} sentence(P,S) : S!=innocent.``` finally results in the trace *gabriel has been sentenced to prison.* when printing the explanations.


### Watching the translation of the program

Internally, xclingo produces a translation of the original program which is what is passed to clingo to do the solving. As xclingo is still in development, unawared bugs or unsupported features can produce a bad translation which will cause clingo to fail. Using the option ```--debug-level translation``` will cause xclingo to print the translation as output, which can help out in figuring out what is happening in case of an error.

