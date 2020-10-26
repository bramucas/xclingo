import sys
import argparse
import clingo

from causes import FiredAtom, FiredRule, Label
from clingo_utilities import find_by_prefix, remove_prefix, find_and_remove_by_prefix, solve_operations
import old_implementation

import translation


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

            rule_labels = set()
            # labels from 'trace'
            if int(fired_id) in labels_dict and str(head) in labels_dict[int(fired_id)]:
                lit, label = labels_dict[int(fired_id)][str(head)]
                if m.is_true(lit):
                    rule_labels.add(label)
            # Auto-labelling labels
            if (auto_tracing == "all" or (auto_tracing == "facts" and fired_body == [])) and rule_labels == []:
                rule_labels.add(str(head))

            rule_cause = FiredRule(fired_id, rule_labels, lazy_causes(causes, fired_body))
            try:
                causes[head].add_alternative_cause(rule_cause)
            except KeyError:
                causes[head] = FiredAtom(
                    head,
                    set([label for lit, label in labels_dict[str(head)] if m.is_true(lit)]) if str(head) in labels_dict else set(),
                    {rule_cause})

    return causes


def lazy_causes(causes, fired_body):
    for lit in fired_body:
        yield causes[lit]


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


def build_labels_dict(c_control):
    """
    Constructs a dictionary with the processed labels for the program indexed by fired_id or the str version of an atom.
    Must be called after grounding.
    @param c_control: clingo.Control object containing the theory atoms after grounding.
    @return dict:
    """
    labels_dict = dict()
    for atom in c_control.theory_atoms:
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


def explain_program(original_program, n, debug_level, auto_tracing):
    control = translation.prepare_xclingo_program([f'-n {n}', "--project"], original_program, debug_level)
    control.ground([("base", [])])

    # Constructs labels
    general_labels_dict = build_labels_dict(control)

    explanations = ""

    # Solves and prints explanations
    with control.solve(yield_=True) as it:
        sol_n = 0
        for m in it:
            sol_n += 1
            explanations += f'Answer: {sol_n}\n'

            causes = build_causes(m, control.traces, build_fired_dict(m), general_labels_dict, auto_tracing)

            if debug_level == "causes":
                explanations += f'{general_labels_dict}\n{causes}\n\n'
                continue

            # atoms_to_explain stores the atom that have to be explained for the current model.
            fired_show_all = [remove_prefix("show_all_", a) for a in find_and_remove_by_prefix(m, 'show_all_')]
            for s in [remove_prefix("nshow_all_", a) for a in find_and_remove_by_prefix(m, 'nshow_all_')]:
                fired_show_all.append(clingo.Function(s.name, s.arguments, False))

            if control.have_explain and fired_show_all:
                atoms_to_explain = fired_show_all
            elif control.have_explain and not fired_show_all:
                explanations += f'Any show_all rule was activated.\n'
                atoms_to_explain = []
            else:  # If there is not show_all rules then explain everything in the model.
                atoms_to_explain = causes.keys()

            explanations += "\n\n".join(causes[a].text_explanation(include_header=True) for a in atoms_to_explain)

    return explanations


def main():
    # Handles arguments of xclingo
    parser = argparse.ArgumentParser(description='Tool for debugging and explaining ASP programs')
    parser.add_argument('--debug-level', type=str, choices=["none", "magic-comments", "translation", "causes"], default="none",
                        help="Points out the debugging level. Default: none.")
    parser.add_argument('--auto-tracing', type=str, choices=["none", "facts", "all"], default="none",
                        help="Automatically creates traces for the rules of the program. Default: none.")
    parser.add_argument('--imp', type=str, choices=["old", "new"],
                        default="new",
                        help="Warning: development option.")
    parser.add_argument('-n', default=1, type=int, help="Number of answer sets.")
    parser.add_argument('infile', nargs='+', type=argparse.FileType('r'), default=sys.stdin, help="ASP program")
    args = parser.parse_args()

    # Reads input files
    original_program = ""
    for file in args.infile:
        original_program += file.read()

    explain_func = explain_program if args.imp == "new" else old_implementation.explain_program_old

    print(explain_func(original_program, args.n, args.debug_level, args.auto_tracing))


if __name__ == "__main__":
    main()
