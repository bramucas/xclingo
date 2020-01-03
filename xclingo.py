
import sys
import argparse
import clingo
from more_itertools import unique_everseen
from clingo_utilities import find_by_prefix, body_variables, add_prefix

rule_counter = 0
traces = {}


def handle_body_labels(body_asts):
    '''
    @param List[clingo.ast.AST] body_asts:
    @return (label_body, literals, other): tuple containing the list of label theory atoms, the symbolic atoms and
    the rest (respectively).
    '''
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


def generate_rules(ast, builder, t_option):
    '''
    Generates the label rules (unuseful for now), the fired rules and the holds rules for the given ast rule and adds them
    to the 'base' program via the given builder.

    @todo: label rules must be generated from 'magic comments' and not from theory atoms.

    @param clingo.ast.AST ast: the AST from which the rules will be generated
    @param clingo.ProgramBuilder: builder of the clingo control object that will receive the generated rules.
    @return: None
    '''
    global rule_counter
    rule_counter += 1

    if ast.type == clingo.ast.ASTType.Rule:
        # Separates the &label literals in the body from the rest
        label_body, literals, other = handle_body_labels(ast['body'])

        # Associates fired number and function name
        global traces
        traces[rule_counter] = {'head':(str(ast['head']['atom']['term']['name']), ast['head']['atom']['term']['arguments']),
                                'arguments' : list(unique_everseen(map(str, ast['head']['atom']['term']['arguments'] + body_variables(ast['body'])))),
                                'body': [(lit['atom']['term']['name'], lit['atom']['term']['arguments']) for lit in literals if lit['sign']==clingo.ast.Sign.NoSign] }

        if ast['head'].type == clingo.ast.ASTType.TheoryAtom:  # For label rules
            generated_rules = "%{comment}\n{head} :- {body}.\n".\
                format(comment=str(ast),
                       head=str(ast['head']),
                       body=",".join([str(add_prefix('holds_', lit)) for lit in literals]))
        else:
            # Generates fired rule
            fired_head = "fired_{counter}({arguments})".format(counter=str(rule_counter), arguments=",".join(unique_everseen(map(str, ast['head']['atom']['term']['arguments'] + body_variables(ast['body'])))))
            if literals or other:
                fired_rule = "{head} :- {body}.".format(head=fired_head, body= ",".join([str(add_prefix('holds_', lit)) for lit in literals] + list(map(str,other))))
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
                label_rules += "{head} :- {body}.\n".format(head=str(label_ast), body=fired_head)

            # Generates a comment
            comment = "%" + str(ast)

            generated_rules = comment + "\n" + fired_rule + "\n" + holds_rule + "\n" + label_rules

        if t_option:
            print(generated_rules)
            return

        # Adds the generated rules to the base program
        try:
            clingo.parse_program("#program base." + generated_rules, lambda new_ast: builder.add(new_ast))
        except RuntimeError as error:
            if str(error) == "syntax error":
                print("Error de traducción:\n\n{0}".format(generated_rules))
                exit(0)


def build_fired_dict(m):
    '''
    Build a dictionary containing, for each fired id, the list of the different fired values in that given model.
    @param clingo.Model m: the model that contains the fired atoms.
    @return Dict: a dictionary with the different fired values indexed by fired id.
    '''
    fired_values = dict()

    for f in find_by_prefix(m, "fired_"):
        fired_id = int(f.name.split("fired_")[1])
        if fired_id in fired_values:
            fired_values[fired_id].append(f.arguments)
        else:
            fired_values[fired_id] = [f.arguments]

    return fired_values


def build_causes(traces, fired_values):
    '''
    Builds a dictionary containing, for each fired atom in a model, the atoms (with values) that caused its derivation.
    It performs this crossing the info in 'traces' and 'fired_values'
    @param Dict traces: a dictionary (indexed by fired id) containing the head and the body of the original rules.
    @param Dict fired_values: a dictionary (indexed by fired id) that contains the fired values in a model.
    @return Dict:
    '''
    causes = dict()

    for id, fired_values_list in fired_values.items():
        for fired_values in fired_values_list:
            # id -> se ha disparado ese fired una vez por cada valor en fired_values_list
            # fired_values -> los valores con los que se ha disparado

            # Bindear nombres de variables y valores (basado en el orden)
            var_val = dict()
            for i in range(0,len(fired_values)):
                var_val[traces[id]['arguments'][i]] = fired_values[i]

            # Reconstruir las causas usando los valores y el cuerpo
            (name, variables) = traces[id]['head']
            head = clingo.Function(name, [var_val[str(v)] for v in variables])
            fired_body = [clingo.Function(name, [var_val[str(v)] for v in variables] ) for (name, variables) in traces[id]['body']]
            if head in causes:
                causes[head].append(fired_body)
            else:
                causes[head] = [fired_body]

    return causes


def build_explanations(atom, causes):
    '''
    Returns a list containing all the possibles explanations for the given atom based on the given 'causes' dict.
    @param clingo.Symbol atom: the atom to be explained.
    @param Dict causes: dict containing all the possible causes for each atom in a model.
    @return List[Dict]: list of dictionaries in where each dict is an explanation for the atom.
    '''
    explanations = []

    for alternative in causes[atom]:  # Each alternative is a list of derived atoms
        if alternative:
            possible_explanations = [{}]  # Initialize with an empty explanation
            for a in alternative:  # Each atom in 'alternative' can have multiple explanations. Each combination is an atom explanation.
                a_explanations = build_explanations(a, causes)
                for i in range(len(possible_explanations)):
                    p_e = possible_explanations.pop()
                    for e in a_explanations:
                        copy = p_e.copy()
                        copy[a] = e
                        possible_explanations.insert(0,copy)
            explanations.extend(possible_explanations)
        else:
            # alternative == [] (empty list), then one explanation is that the atom is fact.
            explanations.append(1)

    return explanations


def main():
    # Handles arguments of xclingo
    parser = argparse.ArgumentParser(description='Tool for debugging and explaining ASP programs')
    parser.add_argument('-t', action='store_true', default=False,
                        help="If enabled, the program will just show the translation of the input program")
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin, help="ASP program")
    args = parser.parse_args()

    # Gets clingo control object (with '-n 0')
    control = clingo.Control(["-n 0", "--keep-facts"])

    # Sets theory atom &label and parses/handles input program
    with control.builder() as builder:
        clingo.parse_program("#program base. #theory label {t { }; &label/0: t, any}.", lambda ast: builder.add(ast))
        clingo.parse_program("#program base." + args.infile.read(), lambda ast: generate_rules(ast, builder, args.t))

    # JUST FOR DEBUGGING TODO: delete this
    if args.t:
        exit(0)

    control.ground([("base", [])])

    # Extracts &label atoms and process labels
    # for atom in control.theory_atoms:
    #     if atom.term.name == "label" and len(atom.term.arguments) == 0:  # '&label' atoms with 0 arguments
    #         #DUDA: ¿atom.elements always a list of len = 1?
    #         # Replace % placeholders by the values.
    #         for e in atom.elements:
    #             message = str(e.terms[0])
    #             for t in e.terms[1:]:
    #                 message = message.replace("%", str(t), 1)

    # Solves and prints explanations
    with control.solve(yield_=True) as it:
        sol_n = 0
        for m in it:
            sol_n += 1
            print("Answer: " + str(sol_n))

            causes = build_causes(traces, build_fired_dict(m))

            for fired_atom in causes.keys():
                print(fired_atom)
                for e in build_explanations(fired_atom, causes):
                    print("\t" + str(e))

            print()


if __name__ == "__main__":
    main()
