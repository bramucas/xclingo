plength(5).

%initial state
h(light, off, 0).
h(protect, on, 0).
h(s1, open, 0).
h(s2, open, 0).

% actions
o(toggle(s1), 1).
o(toggle(s1), 4).
