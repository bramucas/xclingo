

import sys
import argparse
import clingo

from pandas import DataFrame
from clingo_utilities import find_by_prefix, remove_prefix, find_and_remove_by_prefix
from more_itertools import unique_everseen
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


def build_causes(traces, fired_values, labels_dict, auto_labelling):
    """
    Builds a dictionary containing, for each fired atom in a model, the atoms (with values) that caused its derivation.
    It performs this crossing the info in 'traces' and 'fired_values'
    @param Dict traces: a dictionary (indexed by fired id) containing the head and the body of the original rules.
    @param Dict fired_values: a dictionary (indexed by fired id) that contains the fired values in a model.
    @param Dict labels_dict: a dictionary (indexed by atom with values) that contains their processed labels.
    @param str auto_labelling: string constant chosen by the user. Options are:
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
            (name, variables) = traces[fired_id]['head']
            head = clingo.Function(name, [var_val[str(v)] for v in variables])

            # Computes fired_body
            fired_body = []
            for (name, variables) in traces[fired_id]['body']:
                values = []
                for v in variables:
                    if str(v) in var_val:
                        values.append(var_val[str(v)])
                    elif str(v)[0].islower():
                        values.append(clingo.Function(str(v),[]))
                fired_body.append(clingo.Function(name, values))

            #fired_body = [clingo.Function(name, [var_val[str(v)] for v in variables]) for (name, variables) in traces[fired_id]['body']]

            # Labels
            labels = labels_dict[str(head)] if str(head) in labels_dict else []
            labels.extend(labels_dict[int(fired_id)] if int(fired_id) in labels_dict else [])
            if auto_labelling == "all" or (auto_labelling == "facts" and fired_body == []):
                labels.append(str(head))

            causes.append(
                {'fired_id': fired_id,
                 'fired_head': head,
                 'labels': labels,
                 'fired_body': fired_body})

    causes_df = DataFrame(causes)

    return causes_df


def build_labels_dict(c_control):
    # Extracts &label atoms and process labels
    labels_dict = {}
    for atom in c_control.theory_atoms:
        if atom.term.name in ["label_atoms", "label_rule"] and len(atom.term.arguments) == 0:  # '&label_atoms' atoms with 0 arguments
            # Replace % placeholders by the values.
            for e in atom.elements:
                label = str(e.terms[1])
                for t in e.terms[2:]:
                    label = label.replace("%", str(t), 1)

                if atom.term.name == "label_atoms":
                    to_be_labelled = str(e.terms[0])
                elif atom.term.name == "label_rule":
                    to_be_labelled = int(str(e.terms[0]))

                if to_be_labelled in labels_dict:
                    labels_dict[to_be_labelled].append(label)
                else:
                    labels_dict[to_be_labelled] = [label]

    return labels_dict


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
                else:
                    stack.append(a)

                a_explanations = _build_explanations(a, causes, stack)

                # Initialize with empty explanation if there is nothing yet
                if not alt_rule_explanations:
                    alt_rule_explanations.append({})

                if a_explanations != [{}]:  # If a is not fact
                    for i in range(len(alt_rule_explanations)):
                        # The atom explanations (e) are merged directly with the rest of the current alt_rule.
                        a_expl = alt_rule_explanations.pop()
                        for e in [a_e for a_e in a_explanations if a_e != {}]:
                            copy = a_expl.copy()
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
    branch = "  |" * (level + 1) + "--"

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


def main():
    # Handles arguments of xclingo
    parser = argparse.ArgumentParser(description='Tool for debugging and explaining ASP programs')
    parser.add_argument('-t', action='store_true', default=False,
                        help="If enabled, the program will just show the translation of the input program")
    parser.add_argument('--auto-labelling', type=str, choices=["none", "facts", "all"], default="none",
                        help="Automatically creates labels for the rules of the program. Default: none.")
    parser.add_argument('infile', nargs='+', type=argparse.FileType('r'), default=sys.stdin, help="ASP program")
    args = parser.parse_args()

    # Reads input files
    original_program = ""
    for file in args.infile:
        original_program += file.read()

    # Prepares the original program and obtain an XClingoControl
    control = translation.prepare_xclingo_program(original_program, args.t)

    # JUST FOR DEBUGGING TODO: delete this
    if args.t:
        exit(0)

    control.ground([("base", [])])

    # Constructs labels
    labels_dict = build_labels_dict(control)

    # Solves and prints explanations
    with control.solve(yield_=True) as it:
        sol_n = 0
        for m in it:
            sol_n += 1
            print("Answer: " + str(sol_n))

            fired_explains = [remove_prefix("explain_", a) for a in find_and_remove_by_prefix(m, 'explain_')]
            causes = build_causes(control.traces, build_fired_dict(m), labels_dict, args.auto_labelling)

            if control.have_explain and fired_explains:
                atoms_to_explain = [a for a in causes['fired_head'].unique() if a in fired_explains]
            elif control.have_explain and not fired_explains:
                print("Any explain rule was activated.")
                atoms_to_explain = []
            else:
                atoms_to_explain = causes['fired_head']

            for a in atoms_to_explain:
                print(">> {}".format(a), end='')
                a_explanations = build_explanations(a, causes)
                print("\t[{}]".format(len(a_explanations)))
                for e in a_explanations:
                    print(ascii_tree_explanation(e))

            print()


if __name__ == "__main__":
    main()
