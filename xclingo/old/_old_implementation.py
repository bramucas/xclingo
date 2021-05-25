from xclingo import preprocess
import clingo
from pandas import DataFrame

import xclingo.preprocess as preprocess
from xclingo.utils import remove_prefix, find_and_remove_by_prefix
import xclingo
from more_itertools import unique_everseen


def build_causes_old(m, traces, fired_values, labels_dict, auto_tracing):
    """
    Builds a dictionary containing, for each fired atom in a model, the atoms (with values) that caused its derivation.
    It performs this crossing the info in 'traces' and 'fired_values'
    @param clingo.Model m:
    @param Dict traces: a dictionary (indexed by fired id) containing the head and the body of the original rules.
    @param Dict fired_values: a dictionary (indexed by fired id) that contains the fired values in a model.
    @param Dict labels_dict: a dictionary (indexed by atom with values) that contains their processed labels.
    @param str auto_tracing: string constant chosen by the user. Options are:
                - none : atoms and rules just have the labels found on the original program.
                - facts : rules with empty body must be additionally labeled with a string version of its head.
                - all : every rule must be additionally labeled with a string version of its head.
    @return DataFrame:
    """
    causes = []

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
            fired_body = []
            for (positive, name, variables) in traces[fired_id]['body']:
                values = xclingo.replace_by_value(var_val, variables)
                fired_body.append(clingo.Function(name, values, positive))

            # Labels
            labels = []
            if str(head) in labels_dict:  # Label from 'trace_all' sentences
                labels.extend([label for lit, label in labels_dict[str(head)] if m.is_true(lit)])

            if int(fired_id) in labels_dict and str(head) in labels_dict[int(fired_id)]:
                lit, label = labels_dict[int(fired_id)][str(head)]
                if m.is_true(lit):
                    labels.append(label)

            if (auto_tracing == "all" or (auto_tracing == "facts" and fired_body == [])) and labels == []:  # Auto-labelling labels
                labels.append(str(head))

            causes.append(
                {'fired_id': fired_id,
                 'fired_head': head,
                 'labels': labels,
                 'fired_body': fired_body})

    causes_df = DataFrame(causes)

    return causes_df


def build_labels_dict_old(c_control):
    """
    Constructs a dictionary with the processed labels for the program indexed by fired_id or the str version of an atom.
    Must be called after grounding.
    @param c_control: clingo.Control object containing the theory atoms after grounding.
    @return dict:
    """
    labels_dict = {}
    for atom in c_control.theory_atoms:
        name = atom.term.name
        if name == "trace_all":
            terms = atom.elements[0].terms
            # Replace label % placeholders by the values.
            label = str(terms[1])
            for value in terms[2:]:
                if value.type == clingo.TheoryTermType.Function:
                    if value.name == "+" and len(value.arguments) == 2:
                        value = value.arguments[0].number + value.arguments[1].number
                    elif value.name == "-" and len(value.arguments) == 2:
                        value = value.arguments[0].number - value.arguments[1].number
                label = label.replace("%", str(value), 1)

            index = xclingo._fhead_from_theory_term(terms[0])

            if index in labels_dict:
                labels_dict[index].append((atom.literal, label))
            else:
                labels_dict[index] = [(atom.literal, label)]
        elif name == "trace":
            terms = atom.elements[0].terms

            # Replace label % placeholders by the values.
            label = str(terms[2])
            for value in terms[3:]:
                if value.type == clingo.TheoryTermType.Function:
                    if value.name == "+" and len(value.arguments) == 2:
                        value = value.arguments[0].number + value.arguments[1].number
                    elif value.name == "-" and len(value.arguments) == 2:
                        value = value.arguments[0].number - value.arguments[1].number

                label = label.replace("%", str(value), 1)

            index = int(str(terms[0]))
            fired_head = xclingo._fhead_from_theory_term(terms[1])

            if index not in labels_dict:
                labels_dict[index] = {}

            labels_dict[index][fired_head] = (atom.literal, label)

    return labels_dict


def explain_program_old(original_program, n, debug_level, auto_tracing, output_format):
    # Prepares the original program and obtain an XClingoControl
    # TODO: why some trace_alls are duplicating answer sets? patch: --project
    control = preprocess.prepare_xclingo_program([f'-n {n}', "--project"], original_program, debug_level)

    control.ground([("base", [])])

    # Constructs labels
    general_labels_dict = build_labels_dict_old(control)

    explanations = ""

    # Solves and prints explanations
    with control.solve(yield_=True) as it:
        sol_n = 0
        for m in it:
            sol_n += 1
            explanations += f'Answer: {sol_n}\n'

            causes = build_causes_old(m, control.traces, xclingo.build_fired_dict(m), general_labels_dict, auto_tracing)

            if debug_level == "causes":
                explanations += f'{general_labels_dict}\n{causes.to_string()}\n\n'
                continue

            # atoms_to_explain stores the atom that have to be explained for the current model.
            fired_show_all = [remove_prefix("show_all_", a) for a in find_and_remove_by_prefix(m, 'show_all_')]
            for s in [remove_prefix("nshow_all_", a) for a in find_and_remove_by_prefix(m, 'nshow_all_')]:
                fired_show_all.append(clingo.Function(s.name, s.arguments, False))

            if control.have_explain and fired_show_all:
                atoms_to_explain = [a for a in causes['fired_head'].unique() if a in fired_show_all]
            elif control.have_explain and not fired_show_all:
                explanations += f'Any show_all rule was activated.\n'
                atoms_to_explain = []
            else:  # If there is not show_all rules then explain everything in the model.
                atoms_to_explain = causes['fired_head'].unique()

            explanations += "\n".join([
                ">> {a}\t[{n_expls}]\n{joint_expls}".format(
                    a=a, n_expls=len(expls), joint_expls="\n".join(ascii_tree_explanation(e) for e in expls)
                )
                for a, expls in [(a, build_explanations(a, causes)) for a in atoms_to_explain]]
            )
    return explanations


def _build_explanations(atom, causes, stack):
    """
    Returns a list containing all the possibles explanations for the given atom based on the given 'causes' dict.
    @param clingo.Symbol atom: the atom to be explained.
    @param Dict causes: dict containing all the possible causes for each atom in a model.
    @param List stack: the stack of calls to _build_explanations done so far at this point.
    @return List[Dict]: list of dictionaries in where each dict is an explanation for the atom.
    """
    explanations = []

    # Each alt_rule is a list of derived atoms (can be empty)
    for index, alt_rule in causes[causes.fired_head == atom][['labels', 'fired_body']].iterrows():

        if alt_rule['fired_body']:
            alt_rule_explanations = []  # Explanations of the current alt_rule.
            # Each atom in 'alt_rule' can have multiple explanations. Each combination is an atom explanation.
            for a in alt_rule['fired_body']:
                # This prevents the function to fall in an infinite loop of calls
                if a in stack:
                    continue

                a_explanations = _build_explanations(a, causes, stack + [a])

                # Initialize with empty explanation if there is nothing yet
                if not alt_rule_explanations:
                    alt_rule_explanations.append({})

                if a_explanations != [{}]:  # If a is not fact
                    for i in range(len(alt_rule_explanations)):
                        not_empty_expls = [a_e for a_e in a_explanations if a_e != {}]
                        # The atom explanations (e) are merged directly with the rest of the current alt_rule.
                        if not_empty_expls:
                            alt_rule_e = alt_rule_explanations.pop()
                            for e in not_empty_expls:
                                copy = alt_rule_e.copy()
                                copy.update(e)
                                alt_rule_explanations.insert(0, copy)

        else:
            # alt_rule == [] (empty list), then one explanation is that the atom is fact.
            alt_rule_explanations = [{}]

        if alt_rule['labels']:
            for label in alt_rule['labels']:
                for e in alt_rule_explanations:
                    explanations.append({label: e})
        else:
            explanations.extend(alt_rule_explanations)

    return list(unique_everseen(explanations))


def build_explanations(atom, causes):
    return _build_explanations(atom, causes, [atom])


def _ascii_tree_explanation(explanation, level):
    """
    @param Dict explanation: dict representing the explanation of an atom.
    @param int level: depth level used to correctly draw the branch of the tree.
    @return str: an str containing the ascii tree explanation.
    """

    tree = ""
    branch = "  |" * (level + 1) + "__"

    # Builds the tree
    if explanation:
        # Adds the root of the explanation
        if level == 0:
            tree += "  *\n"
        # One pair per child   {child1: child_e1, child2: child_e2}
        for child, chidl_e in explanation.items():
            tree += "{branch}{node}\n{subtree}".format(branch=branch, node=str(child),
                                                       subtree=_ascii_tree_explanation(chidl_e, level+1))
    elif level == 0:
        tree += "\t1\n"

    return tree


def ascii_tree_explanation(explanation):
    """
    @param Dict explanation: an explanation
    @return str: an str containing the ascii tree explanation.
    """
    return _ascii_tree_explanation(explanation, 0)
