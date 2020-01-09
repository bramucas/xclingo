
import re
import sys
import argparse
import clingo

from pandas import DataFrame
from itertools import chain
from more_itertools import unique_everseen
from clingo_utilities import find_by_prefix, body_variables, add_prefix, remove_prefix, find_and_remove_by_prefix

rule_counter = 0
traces = {}


def preprocess_program(program):
    """
    Performs a set of different process phases to a given program and return the modified result. This phases are:
     - label_rule magic comments translation.
    @param str program: the program that is intended to be process.
    @return str: the modification of the given program after the different phases.
    """
    preprocessed_program = translate_label_rules(program)

    return preprocessed_program


def translate_label_rules(program):
    """
    Replaces the 'label_rule' magic comments in the given program for a version of the rules labelled with theory atoms.
    @param str program: the program that is intended to be modified.
    @return str: the modified program.
    """
    for hit in re.findall("(%!label_rule \{(.*)\}[ ]*\n[ ]*([a-z][a-zA-Z]*(\(.*\))?[ ]*:-[ ]*.*).)", program):
        # 0: original match  1: label_parameters  2: complete original rule  3: parameters of the head (useless)
        program = program.replace(
            hit[0],
            "{rule}, &label_rule{{{label_parameters}}}.\n".format(rule=hit[2], label_parameters=hit[1])
        )

    return program


def get_multiple_label_rules(program):
    """
    Returns a list with the multiple label sentences found in the given program.
    @param str program:
    @return:
    """
    multiple_label_rules = ""
    for hit in re.findall("%!label_atoms \{(.*)\} (([a-z][a-zA-Z]*)(\(.*\))?([ ]*:-[ ]*(.*))?.)", program):
        # 0: "label",v1,v2  1: complete rule  2: name  3: arguments  4: separator and body  5: body.
        multiple_label_rules += "&label_atoms{{{name}{arguments},{parameters} : }} :- {name}{arguments}{rest_body}.\n".\
            format(name=hit[2], arguments=hit[3], parameters=hit[0], rest_body="," + hit[5] if hit[5] else "")
    return multiple_label_rules


def get_explain_sentences(program):
    """
    Returns a list with the explain sentences found in the given program.
    @param str program:
    @return:
    """
    explain_sentences_string = ""
    for hit in re.findall("%!explain ([a-z][a-zA-Z]*(\(.*\))?([ ]*:-[ ]*.*)?.)", program):
        explain_sentences_string += str(hit[0])

    return explain_sentences_string


def handle_body_labels(body_asts):
    """
    @param List[clingo.ast.AST] body_asts:
    @return (label_body, literals, other): tuple containing the list of label theory atoms, the symbolic atoms and
    the rest (respectively).
    """
    label_body = []
    literals = []
    other = []

    for ast in body_asts:
        if ast['atom'].type == clingo.ast.ASTType.TheoryAtom:
            label_body.append(ast)
        elif ast['atom'].type == clingo.ast.ASTType.SymbolicAtom:
            literals.append(ast)
        else:
            other.append(ast)

    return label_body, literals, other


def add_to_base(generated_rules, builder, t_option):
    """
    @param str generated_rules: the rules that will be added to the base program.
    @param clingo.ProgramBuilder builder: builder of the clingo control object that will receive the generated rules.
    @param bool t_option: if true, the rules will not be added to the program. They will be printed by stdout instead.
    @return None:
    """
    if t_option:
        print(generated_rules)
        return

    # Adds the generated rules to the base program
    try:
        clingo.parse_program("#program base." + generated_rules, lambda new_ast: builder.add(new_ast))
    except RuntimeError as error:
        if str(error) == "syntax error":
            print("Translation error:\n\n{0}".format(generated_rules))
            exit(0)


def generate_label_atoms_rules(ast, builder, t_option):
    # Generate the multiple label rule for the given ast and adds it to the base program
    if ast.type == clingo.ast.ASTType.Rule:
        generated_rule = "{head}:-{body}.".format(
            head=str(ast['head']),
            body=",".join([str(add_prefix("holds_", lit)) for lit in ast['body']]))

        add_to_base(generated_rule, builder, t_option)


def generate_explain_rules(ast, builder, t_option):
    # Generates the explain rule for the given ast and adds it to the base program.
    if ast.type == clingo.ast.ASTType.Rule:
        # starts with explain
        generated_rules = "explain_{head}:-{body}.".format(
            head=str(ast['head']),
            body=",".join([str(add_prefix("holds_", lit)) for lit in [ast['head']] + ast['body']]))

        add_to_base(generated_rules, builder, t_option)


def generate_fired_holds_rules(ast, builder, t_option):
    """
    Generates the label rules (useless for now), the fired rules and the holds rules for the given ast rule and adds
    them to the 'base' program via the given builder.

    @todo: individual label rules must be generated from 'magic comments' and not from theory atoms.

    @param clingo.ast.AST ast: the AST from which the rules will be generated
    @param clingo.ProgramBuilder builder: builder of the clingo control object that will receive the generated rules.
    @param bool t_option:
    @return: None
    """
    global rule_counter
    rule_counter += 1

    if ast.type == clingo.ast.ASTType.Rule:

        if str(ast['head']).startswith("explain_"):
            generated_rules = str(ast)
        else:
            # Separates the &label literals in the body from the rest
            label_body, literals, other = handle_body_labels(ast['body'])

            # Associates fired number and function name
            global traces
            traces[rule_counter] = {
                'head': (str(ast['head']['atom']['term']['name']), ast['head']['atom']['term']['arguments']),
                'arguments': list(unique_everseen(map(str, ast['head']['atom']['term']['arguments'] + body_variables(ast['body'])))),
                'body': [(lit['atom']['term']['name'], lit['atom']['term']['arguments']) for lit in literals if lit['sign'] == clingo.ast.Sign.NoSign]
            }

            if ast['head'].type == clingo.ast.ASTType.TheoryAtom:  # For label rules
                generated_rules = "%{comment}\n{head} :- {body}.\n".\
                    format(comment=str(ast),
                           head=str(ast['head']),
                           body=",".join([str(add_prefix('holds_', lit)) for lit in literals]))
            else:
                # Generates fired rule
                fired_head = "fired_{counter}({arguments})".format(
                    counter=str(rule_counter),
                    arguments=",".join(unique_everseen(map(str, ast['head']['atom']['term']['arguments'] + body_variables(ast['body'])))))
                if literals or other:
                    fired_rule = "{head} :- {body}.".format(
                        head=fired_head,
                        body=",".join([str(add_prefix('holds_', lit)) for lit in literals] + list(map(str, other))))
                else:
                    fired_rule = fired_head + "."

                # Generates holds rule
                holds_rule = "holds_{name}({arguments}) :- {body}.".\
                    format(name=str(ast['head']['atom']['term']['name']),
                           arguments=",".join(map(str, ast['head']['atom']['term']['arguments'])),
                           body=fired_head)

                # Generates label rules
                label_rules = ""
                for label_ast in label_body:
                    label_rules += "&label_rule{{{fired_id},{label_parameters}}} :- {body}.\n".format(
                        fired_id=str(rule_counter),
                        label_parameters=",".join([str(e) for e in label_ast['atom']['elements']]),
                        body=fired_head)

                # Generates a comment
                comment = "%" + str(ast)

                generated_rules = comment + "\n" + fired_rule + "\n" + holds_rule + "\n" + label_rules

        add_to_base(generated_rules, builder, t_option)


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
            fired_body = [clingo.Function(name, [var_val[str(v)] for v in variables]) for (name, variables) in traces[fired_id]['body']]

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


def build_explanations(atom, causes):
    """
    Returns a list containing all the possibles explanations for the given atom based on the given 'causes' dict.
    @param clingo.Symbol atom: the atom to be explained.
    @param Dict causes: dict containing all the possible causes for each atom in a model.
    @return List[Dict]: list of dictionaries in where each dict is an explanation for the atom.
    """
    explanations = []

    # Each alt_rule is a list of derived atoms (can be empty)
    for index, alt_rule in causes[causes.fired_head == atom][['labels', 'fired_body']].iterrows():

        if alt_rule['fired_body']:
            alt_rule_explanations = [{}]  # Explanations of the current alt_rule.
            # Each atom in 'alt_rule' can have multiple explanations. Each combination is an atom explanation.
            for a in alt_rule['fired_body']:
                a_explanations = build_explanations(a, causes)

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

    return explanations


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
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin, help="ASP program")
    args = parser.parse_args()

    # Gets clingo control object (with '-n 0')
    control = clingo.Control(["-n 0", "--keep-facts"])

    original_program = args.infile.read()

    # Pre-processing original program
    explain_sentences = get_explain_sentences(original_program)
    label_atoms_sentences = get_multiple_label_rules(original_program)
    preprocessed_program = preprocess_program(original_program)

    # Sets theory atom &label and parses/handles input program
    with control.builder() as builder:
        clingo.parse_program("#program base. #theory label_rule {t { }; &label_rule/0: t, any}.", lambda ast: builder.add(ast))
        clingo.parse_program("#program base. #theory label_atoms {t { }; &label_atoms/0: t, any}.", lambda ast: builder.add(ast))
        clingo.parse_program("#program base." + explain_sentences, lambda ast: generate_explain_rules(ast, builder, args.t))
        clingo.parse_program("#program base." + label_atoms_sentences, lambda ast: generate_label_atoms_rules(ast, builder, args.t))
        clingo.parse_program("#program base." + preprocessed_program, lambda ast: generate_fired_holds_rules(ast, builder, args.t))

    # JUST FOR DEBUGGING TODO: delete this
    if args.t:
        exit(0)

    control.ground([("base", [])])

    labels_dict = build_labels_dict(control)

    # Solves and prints explanations
    with control.solve(yield_=True) as it:
        sol_n = 0
        for m in it:
            sol_n += 1
            print("Answer: " + str(sol_n))

            fired_explains = [remove_prefix("explain_", a) for a in find_and_remove_by_prefix(m, 'explain_')]
            causes = build_causes(traces, build_fired_dict(m), labels_dict, args.auto_labelling)

            if explain_sentences and fired_explains:
                atoms_to_explain = [a for a in causes['fired_head'].unique() if a in fired_explains]
            elif explain_sentences and not fired_explains:
                print("Any explain rule was activated.")
                atoms_to_explain = []
            else:
                atoms_to_explain = causes['fired_head']

            for a in atoms_to_explain:
                print(">> {}\n".format(a))
                for e in build_explanations(a, causes):
                    print(ascii_tree_explanation(e))

            print()


if __name__ == "__main__":
    main()
