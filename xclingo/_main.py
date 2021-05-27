import clingo
from clingo import parse_program

import xclingo.translation as translation

from xclingo.explain import XclingoSymbol, FiredRule, Label
from xclingo.utils import find_by_prefix, remove_prefix, find_and_remove_by_prefix, solve_operations


def build_fired_dict(m):
    """
    Build a dictionary containing, for each fired id, the list of the different fired values in that given model.
    @param clingo.Model m: the model that contains the fired atoms.
    @return Dict: a dictionary with the different fired values indexed by fired id.
    """
    fired_values = dict()

    for f in find_by_prefix(m, "fired_"):
        fired_id = int(f.name.split("fired_")[1])
        if fired_id in fired_values:
            fired_values[fired_id].append(f.arguments)
        else:
            fired_values[fired_id] = [f.arguments]

    return fired_values


def replace_by_value(var_val, variables):
    values = []
    for v in variables:

        if v.type == clingo.ast.ASTType.Variable:
            values.append(var_val[str(v)])
        elif v.type == clingo.ast.ASTType.Symbol:
            if v['symbol'].type == clingo.SymbolType.Number:
                values.append(int(str(v)))
            else:
                values.append(clingo.Function(v['symbol'].name, v['symbol'].arguments, v['symbol'].positive))
        elif v.type == clingo.ast.ASTType.Function:

            values.append(clingo.Function(
                v['name'],
                replace_by_value(var_val, v['arguments']))
            )
        elif v.type == clingo.ast.ASTType.BinaryOperation:
            operators = []
            for k in v.child_keys:
                if v[k].type == clingo.ast.ASTType.Variable:
                    operators.append(var_val[str(v[k])])
                elif v[k].type == clingo.ast.ASTType.Symbol and v[k]['symbol'].type == clingo.SymbolType.Number:
                    operators.append(v[k]['symbol'])

            if v['operator'] == clingo.ast.BinaryOperator.Minus:
                values.append(operators[0].number - operators[1].number)
            elif v['operator'] == clingo.ast.BinaryOperator.Plus:
                values.append(operators[0].number + operators[1].number)
            elif v['operator'] == clingo.ast.BinaryOperator.Multiplication:
                values.append(operators[0].number * operators[1].number)
            elif v['operator'] == clingo.ast.BinaryOperator.Division:
                values.append(operators[0].number / operators[1].number)

    return values


def build_causes(m, traces, fired_values, labels_dict, auto_tracing):
    """
    Builds a set of Causes objects wich contains an entry for each true (derived) atom in the model m. This is
    done by crossing 'traces' info and 'fired_values'.
    @param clingo.Model m:
    @param Dict traces: a dictionary (indexed by fired id) containing the head and the body of the original rules.
    @param Dict fired_values: a dictionary (indexed by fired id) that contains the fired values in a model.
    @param Dict labels_dict: a dictionary (indexed by atom with values) that contains their processed labels.
    @param str auto_tracing: string constant chosen by the user. Options are:
                - none : atoms and rules just have the labels found on the original program.
                - facts : rules with empty body must be additionally labeled with a string version of its head.
                - all : every rule must be additionally labeled with a string version of its head.
    @return set:
    """
    causes = {}

    for fired_id, fired_values_list in fired_values.items():
        for fired_values in fired_values_list:
            # fired_id -> that 'fired' rule was fired once for each value in fired_values_list
            # fired_values -> the values that were fired

            # Bind variable names and its values (order-based)
            var_val = dict()
            for i in range(0, len(fired_values)):
                var_val[traces[fired_id]['arguments'][i]] = fired_values[i]

            # Build the causes using fired values and the original body
            (positive, name, variables) = traces[fired_id]['head']
            head = clingo.Function(name, [var_val[str(v)] for v in variables], positive)

            # Computes fired_body
            fired_body = set()
            for (positive, name, variables) in traces[fired_id]['body']:
                values = replace_by_value(var_val, variables)
                fired_body.add(clingo.Function(name, values, positive))

            rule_labels = list()
            # labels from 'trace_rule'
            if int(fired_id) in labels_dict and str(head) in labels_dict[int(fired_id)]:
                lit, label = labels_dict[int(fired_id)][str(head)]
                if m.is_true(lit):
                    rule_labels.append(label)
            # Auto-labelling labels
            if (len(rule_labels)==0 and (str(head) not in labels_dict)) and (auto_tracing == "all" or (auto_tracing == "facts" and not fired_body)):
                rule_labels.append(str(head))

            rule_cause = FiredRule(fired_id, labels=rule_labels, causes_dict=causes, clingo_atoms=fired_body)
            try:
                causes[head].add_alternative_cause(rule_cause)
            except KeyError:
                causes[head] = XclingoSymbol(
                    head,
                    list([label for lit, label in labels_dict[str(head)] if m.is_true(lit)]) if str(head) in labels_dict else list(),
                    [rule_cause])

    return causes


def _fhead_from_theory_term(theory_term):

    is_classic_negation = theory_term.name == "-" and len(theory_term.arguments) == 1

    if is_classic_negation:
        theory_term = theory_term.arguments[0]

    # Process arguments
    arguments = []
    for arg in theory_term.arguments:
        if arg.type == clingo.TheoryTermType.Function:
            if arg.name == "+" and len(arg.arguments) == 2:
                arguments.append(str(arg.arguments[0].number + arg.arguments[1].number))
            elif arg.name == "-" and len(arg.arguments) == 2:
                arguments.append(str(arg.arguments[0].number - arg.arguments[1].number))
            else:
                arguments.append(str(arg))
        else:
            arguments.append(str(arg))

    fired_head = "{sign}{name}{arguments}".format(
        sign="-" if is_classic_negation else "",
        name=theory_term.name,
        arguments="({})".format(",".join(arguments)) if arguments else ""
    )

    return fired_head


def find_atoms_to_explain(m, fired_atoms):
    fired_show_all = [remove_prefix("show_all_", a) for a in find_and_remove_by_prefix(m, 'show_all_')]
    for s in [remove_prefix("nshow_all_", a) for a in find_and_remove_by_prefix(m, 'nshow_all_')]:
        fired_show_all.append(clingo.Function(s.name, s.arguments, False))

    return fired_show_all if fired_show_all else fired_atoms.keys()

class XclingoModel:

    def __init__(self, model, fired_atoms=set(), atoms_to_explain=set()):
        if not isinstance(model, clingo.Model):
            raise TypeError
        # internal model attributes    
        self._model = model
        self.context = self._model.context
        self.cost = self._model.cost
        self.number = self._model.number
        self.optimality_proven = self._model.optimality_proven
        self.thread_id = self._model.thread_id
        self.type = self._model.type

        # XclingoModel attributes
        self._xclingo_symbols = fired_atoms
        self.atoms_to_explain = atoms_to_explain

    def xclingo_symbols(self, yield_=True, only_show_all=True):
        if only_show_all:
            if yield_:
                for a, fa in self._xclingo_symbols.items():
                    if a in self.atoms_to_explain:
                        yield fa
            else:
                return [self._xclingo_symbols[a] for a in self._xclingo_symbols if a in self.atoms_to_explain] 
        else:
            if yield_:
                for a, fa in self._xclingo_symbols.items():
                    yield fa
            else:
                return self._xclingo_symbols.values()

    # Model calls
    def contains(self, atom):
        return self._model.contains(atom)

    def extend(self, symbols):
        return self._model.extend(symbols)

    def is_true(self, literal):
        return self._model.is_true(literal)

    def symbols(self, atoms=False, terms=False, shown=False, csp=False, complement=False):
        return self._model.symbols(atoms, terms, shown, csp, complement)

class XclingoControl(clingo.Control):
    """
    Extends Control class with xclingo functions and parameters.
    """
    _rule_counter = None
    traces = None
    labels_dict = None
    have_explain = None

    def __init__(self, *args):
        self.rule_counter = 0
        self.traces = {}
        labels_dict = {}
        self.have_explain = False
        super().__init__(*args)

    def count_rule(self):
        current = self.rule_counter
        self.rule_counter += 1
        return current

    def __build_labels_dict(self):
        """
        Constructs a dictionary with the processed labels for the program indexed by fired_id or the str version of an atom.
        Must be called after grounding.
        @param c_control: clingo.Control object containing the theory atoms after grounding.
        @return dict:
        """
        labels_dict = dict()
        for atom in self.theory_atoms:
            name = atom.term.name
            terms = atom.elements[0].terms

            if name == "trace_all":
                label = Label(str(terms[1]), solve_operations(terms[2:]))
                index = _fhead_from_theory_term(terms[0])
                if index in labels_dict:
                    labels_dict[index].append((atom.literal, label))
                else:
                    labels_dict[index] = [(atom.literal, label)]

            elif name == "trace":
                label = Label(str(terms[2]), solve_operations(terms[3:]))
                index = int(str(terms[0]))
                fired_head = _fhead_from_theory_term(terms[1])

                if index not in labels_dict:
                    labels_dict[index] = {}

                labels_dict[index][fired_head] = (atom.literal, label)

        return labels_dict

    def ground(self, *args):
        super().ground(*args)
        self.labels_dict = self.__build_labels_dict()

    def solve(self, yield_=True, auto_tracing="none"):
        with super().solve(yield_=yield_) as it:
            sol_n = 0
            for m in it:
                sol_n += 1
                fired_atoms = build_causes(m, self.traces, build_fired_dict(m), self.labels_dict, auto_tracing)
                atoms_to_explain = find_atoms_to_explain(m, fired_atoms)
                yield XclingoModel(m, fired_atoms, atoms_to_explain)


def prepare_xclingo_program(clingo_arguments, original_program, debug_level):
    control = XclingoControl(clingo_arguments)

    # Pre-processing original program
    translated_program = translation.translate_trace(original_program)
    translated_program = translation.translate_trace_all(translated_program)

    aux = translated_program
    translated_program = translation.translate_show_all(translated_program)

    control.have_explain = bool(aux != translated_program)

    # Prints translated_program and exits
    if debug_level == "magic-comments":
        print(translated_program)
        exit(0)

    # Sets theory atom &label and parses/handles input program
    with control.builder() as builder:
        # Adds theories
        parse_program("""#program base. 
                        #theory trace {
                            t { 
                                - : 7, unary;
                                + : 6, binary, left; 
                                - : 6, binary, left 
                            }; 
                            &trace/0: t, any}.""",
                      lambda ast_object: builder.add(ast_object))
        parse_program("""#program base. 
                        #theory trace_all {
                            t { 
                                - : 7, unary; 
                                + : 6, binary, left; 
                                - : 6, binary, left 
                            }; 
                            &trace_all/0: t, any}.""",
                      lambda ast_object: builder.add(ast_object))
        # Handle xclingo sentences
        parse_program(
            "#program base." + translated_program,
            lambda ast_object: translation.translate_to_fired_holds(ast_object, control, builder, debug_level == "translation")
        )

    # Translation was printed during _translate_to_fired_holds so we can now exit
    if debug_level == "translation":
        exit(0)

    return control