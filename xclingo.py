
import sys
import argparse
import clingo
import itertools


class Observer:
    def rule(self, is_choice, head, body):
       print("[" + str(is_choice) + "] " + str(head) + " :- " + str(body))


rule_counter = 0
traces  = {}


def holds_prefix(atom):
    # Returns the 'holds' version of the given atom while handling negation.
    if atom.startswith("not"):
        return atom.replace("not ", "not holds_")
    else:
        return "holds_" + atom


def handle_body_labels(body_asts):
    # Separates the asts within the body depending on their type (labels, literals, other).
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


def body_variables(body_asts):
    # Returns a list containing the name of the variables used in the given body.
    vars = []

    for ast in body_asts:
        if ast['atom'].type == clingo.ast.ASTType.SymbolicAtom:
            for a in ast['atom']['term']['arguments']:
                if a.type == clingo.ast.ASTType.Variable:
                    vars.append(a)
        elif ast['atom'].type == clingo.ast.ASTType.Comparison:
            if ast['atom']['left'].type == clingo.ast.ASTType.Variable:
                vars.append(ast['atom']['left'])
            if ast['atom']['right'].type == clingo.ast.ASTType.Variable:
                vars.append(ast['atom']['right'])

    return vars


def unique(list):
    unique = []

    for e in list:
        if e not in unique:
            unique.append(e)

    return unique


def generate_rules(ast, builder, t_option):
    """
    Generates the label rules, the fired rules and the holds rules for the given ast and adds it to the 'base'
    program via the given builder.

    :param ast: the AST from which the rules will be generated
    :param builder: clingo's control builder
    :return: None
    """
    global rule_counter
    rule_counter += 1

    if ast.type == clingo.ast.ASTType.Rule:
        # Separates the &label literals in the body from the rest
        label_body, literals, other = handle_body_labels(ast['body'])

        # Associates fired number and function name
        global traces
        traces[rule_counter] = {'head':(str(ast['head']['atom']['term']['name']), ast['head']['atom']['term']['arguments']),
                                'arguments' : unique(map(str, ast['head']['atom']['term']['arguments'] + body_variables(ast['body']))),
                                'body': [(lit['atom']['term']['name'], lit['atom']['term']['arguments']) for lit in literals if lit['sign']==clingo.ast.Sign.NoSign] }

        if ast['head'].type == clingo.ast.ASTType.TheoryAtom:
            generated_rules = "%{comment}\n{head} :- {body}.\n".\
                format(comment=str(ast),
                       head=str(ast['head']),
                       body=",".join(map(holds_prefix, map(str, literals))))
        else:
            # Generates fired rule
            fired_head  =  "fired_{counter}({arguments})".format(counter=str(rule_counter), arguments=",".join(unique(map(str, ast['head']['atom']['term']['arguments'] + body_variables(ast['body'])))))
            if literals or other:
                fired_rule = "{head} :- {body}.".format(head=fired_head, body= ",".join( list(map(holds_prefix, map(str, literals))) + list(map(str,other))))
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


def replace_by_fired_values(name_value, variables):
    fired_values = []

    for v in variables:
        fired_values.append(name_value[str(v)])

    return fired_values


def fired_body(name_value, original_body):
    fired_body = []

    for (name, variables) in original_body:
        fired_body.append(clingo.Function(name, replace_by_fired_values(name_value, variables)))

    return fired_body


def build_causes(traces, fireds):
    causes = dict()

    for id, fired_values_list in fireds.items():
        for fired_values in fired_values_list:
            # id -> se ha disparado ese fired una vez por cada valor en fired_values_list
            # fired_values -> los valores con los que se ha disparado

            # Bindear nombres de variables y valores
            name_value = dict()
            for i in range(0,len(fired_values)):
                name_value[traces[id]['arguments'][i]] = fired_values[i]

            # Reconstruir las explicaciones
            (name, variables) = traces[id]['head']
            head = clingo.Function(name, replace_by_fired_values(name_value, variables))
            try:
                causes[head].append(fired_body(name_value, traces[id]['body']))
            except KeyError:
                causes[head] = [fired_body(name_value, traces[id]['body'])]

    return causes

#TODO: remove this
def build_explanations_old(atom, causes):
    # Not stable
    explanations = []

    for alt in causes[atom]:
        e_list = []
        for c in alt:
            if e_list:
                aux = []
                for e in e_list:
                    e[c] = build_explanations(c, causes)
                    aux.append(e)
                #e_list = itertools.product(e_list, {c: build_explanations(c, causes)})
                e_list = aux
                #print(aux)
            else:
                e_list.append({c: build_explanations(c, causes)})

            explanations.append(list(e_list))

    # Expand explanations
    expanded = []
    # For each e in explanations must be one or more expanded explanations
    for e in explanations:
        print("\t"+str(e))
        #expanded.append(x)

    return expanded


def build_explanations(atom, causes):
    """
    Recursive and without cache.
    """

    explanations = []

    for alternative in causes[atom]:
        if alternative:
            alt_e = {}
            for c in alternative:
                alt_e[c] = build_explanations(c,causes)
            explanations.append(alt_e)
        else:
            # Atom is fact
            explanations.append(1)

    #TODO: to expand explanations
    # Maybe it is possible to do it during the computation. This way we avoid to iterate the explanations
    # multiple times.
    expanded = []
    for e in explanations:
        # Each e is a dict, each dict is a non expanded explanation
        pass

    return explanations


def main():
    # Handle arguments of xclingo
    parser = argparse.ArgumentParser(description='Tool for debugging and explaining ASP programs')
    parser.add_argument('-t', action='store_true', default=False,
                        help="If enabled, the program will just show the translation of the input program")
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin, help="ASP program")
    args = parser.parse_args()

    # Get clingo control object (with '-n 0')
    control = clingo.Control(["-n 0", "--keep-facts"])

    # Set theory atom &label and parse/handle input program
    with control.builder() as builder:
        clingo.parse_program("#program base. #theory label {t { }; &label/0: t, any}.", lambda ast: builder.add(ast))
        clingo.parse_program("#program base." + args.infile.read(), lambda ast: generate_rules(ast, builder, args.t))

    # JUST FOR DEBUGGING TODO: delete this
    if args.t:
        exit(0)

    # Register observer and do drounding
    #control.register_observer(Observer(), False)  # ¿Use Observer for linking labels to rules?
    control.ground([("base", [])])

    # Extract &label atoms and process labels
    for atom in control.theory_atoms:
        if atom.term.name == "label" and len(atom.term.arguments) == 0:  # '&label' atoms with 0 arguments
            #DUDA: ¿atom.elements always a list of len = 1?
            # Replace % placeholders by the values.
            for e in atom.elements:
                message = str(e.terms[0])
                for t in e.terms[1:]:
                    message = message.replace("%", str(t), 1)

    # Solve and print debug message
    with control.solve(yield_=True) as it:
        sol_n = 0
        for m in it:
            sol_n += 1
            print("Answer: " + str(sol_n))
            print("traces -------\n" + str(traces))

            fireds = dict()
            fired_symbols = [sym for sym in m.symbols(atoms=True) if str.startswith(str(sym), 'fired_')]
            for f in fired_symbols:
                try:
                    fireds[int(f.name.split("fired_")[1])].append(f.arguments)
                except KeyError:
                    fireds[int(f.name.split("fired_")[1])] = [f.arguments]

            causes = build_causes(traces, fireds)

            # Debug
            print("causes----\n" + str(causes))

            for fired_atom in causes.keys():
                print(fired_atom)
                for e in build_explanations(fired_atom, causes):
                    print("\t" + str(e))

            print()


if __name__ == "__main__":
    main()
