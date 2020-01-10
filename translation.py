import clingo
import re
from more_itertools import unique_everseen
from clingo_utilities import body_variables, add_prefix


class XClingoProgramControl(clingo.Control):
    """
    Extends clingo.Control class with xclingo functions and parameters.
    """
    _rule_counter = None
    traces = None
    have_explain = None

    def __init__(self, *args):
        self.rule_counter = 0
        self.traces = {}
        self.have_explain = False
        super().__init__(*args)

    def count_rule(self):
        current = self.rule_counter
        self.rule_counter += 1
        return current


def _translate_label_rules(program):
    """
    Replaces the 'label_rule' magic comments in the given program for a version of the rules labelled with theory atoms.
    @param str program: the program that is intended to be modified.
    @return str:
    """
    for hit in re.findall("(%!label_rule \{(.*)\}[ ]*\n[ ]*([a-z][a-zA-Z]*(\(.*\))?[ ]*:-[ ]*.*).)", program):
        # 0: original match  1: label_parameters  2: complete original rule  3: parameters of the head (useless)
        program = program.replace(
            hit[0],
            "{rule}, &label_rule{{{label_parameters}}}.\n".format(rule=hit[2], label_parameters=hit[1])
        )

    return program


def _translate_label_atoms(program):
    """
    Replaces the 'label_atoms' magic comments in the given program for label_atoms rule.
    @param str program: the program that is intended to be modified
    @return str:
    """
    for hit in re.findall("(%!label_atoms \{(.*)\} (([a-z][a-zA-Z]*)(\(.*\))?([ ]*:-[ ]*(.*))?.))", program):
        # 0: original match 1: "label",v1,v2  2: complete rule  3: name  4: arguments  5: separator and body  6: body.
        program = program.replace(
            hit[0],
            "&label_atoms{{{name}{arguments},{parameters} : }} :- {name}{arguments}{rest_body}.\n".format(
                name=hit[3], arguments=hit[4], parameters=hit[1], rest_body="," + hit[6] if hit[6] else "")
        )

    return program


def _translate_explains(program):
    """
    Replaces 'explain' magic comments in the given program for a rule version of those magic comments.
    @param str program:
    @return:
    """
    for hit in re.findall("(%!explain (([a-z][a-zA-Z]*(\(.*\))?)([ ]*:-[ ]*(.*))?.))", program):
        # 0: original match  1: rule  2: head of the rule  3: parameters of the head  4: body with :-  5: body without :-
        program = program.replace(
            hit[0],
            "{prefix}{head}:-{head}{body}.".format(prefix="explain_", head=hit[2], body="," + hit[5] if hit[5] else "")
        )

    return program


def _handle_body_labels(body_asts):
    """
    Divides the given body (list of clingo.ast) into label theory atoms, normal literals and the rest.
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


def _add_to_base(rules_to_add, builder, t_option):
    """
    @param str rules_to_add: the rules that will be added to the base program.
    @param clingo.ProgramBuilder builder: builder of the clingo control object that will receive the generated rules.
    @param bool t_option: if true, the rules will not be added to the program. They will be printed by stdout instead.
    @return None:
    """
    if t_option:
        print(rules_to_add)
        return

    # Adds the generated rules to the base program
    try:
        clingo.parse_program("#program base." + rules_to_add, lambda new_ast: builder.add(new_ast))
    except RuntimeError as error:
        if str(error) == "syntax error":
            print("Translation error:\n\n{0}".format(rules_to_add))
            exit(0)


def _translate_to_fired_holds(ast, control, builder, t_option):
    """
    Generates the label rules (useless for now), the fired rules and the holds rules for the given ast rule and adds
    them to the 'base' program via the given builder.

    @param clingo.ast.AST ast: the AST from which the rules will be generated
    @param clingo.ProgramBuilder builder: builder of the clingo control object that will receive the generated rules.
    @param bool t_option:
    @return: None
    """
    if ast.type == clingo.ast.ASTType.Rule:

        if (ast['head'].type == clingo.ast.ASTType.TheoryAtom and ast['head']['term']['name'] == "label_atoms")\
                or (str(ast['head']).startswith("explain_")):
            if ast['body']:
                translated_rule = "{head} :- {translated_body}.".format(
                    head=str(ast['head']),
                    translated_body=",".join([str(add_prefix('holds_', lit)) for lit in ast['body']])
                )
            else:
                translated_rule = str(ast['head']) + "."

            generated_rules = translated_rule + "\n"
        elif (ast['head']['atom'].type == clingo.ast.ASTType.BooleanConstant and ast['head']['atom']['value'] == False):
            # It is a constraint
            label_body, literals, other = _handle_body_labels(ast['body'])

            if literals:
                translated_constraint = "{head}:-{body}.".format(
                    head=str(ast['head']),
                    body=",".join([str(add_prefix('holds_', lit)) for lit in literals])
                )
            else:
                # TODO: remove this, this case cant be
                translated_constraints = "{head}.".format(
                    head=str(ast['head'])
                )
            comment = "%" + str(ast)
            generated_rules = comment + "\n" + translated_constraint
        else:
            rule_counter = control.count_rule()

            # Separates the &label literals in the body from the rest
            label_body, literals, other = _handle_body_labels(ast['body'])

            # Finds out if head is classic negation
            try:
                is_classic_negation = (ast['head']['atom']['term'].type == clingo.ast.ASTType.UnaryOperation
                                   and ast['head']['atom']['term']['operator'] == clingo.ast.UnaryOperator.Minus)
            except KeyError:
                is_classic_negation = False

            if is_classic_negation:
                head_function = ast['head']['atom']['term']['argument']
            else:
                head_function = ast['head']['atom']['term']


            # Associates fired number and function name
            body = []
            for lit in [literal for literal in literals if literal['sign'] == clingo.ast.Sign.NoSign]:
                if (lit['atom']['term'].type == clingo.ast.ASTType.UnaryOperation
                                   and lit['atom']['term']['operator'] == clingo.ast.UnaryOperator.Minus):
                    b_fun = lit['atom']['term']['argument']
                else:
                    b_fun = lit['atom']['term']
                body.append((b_fun['name'], b_fun['arguments']))

            control.traces[rule_counter] = {
                'head': (str(head_function['name']), head_function['arguments']),
                'arguments': list(unique_everseen(map(str, head_function['arguments'] + body_variables(ast['body'])))),
                'body': body
            }

            if ast['head'].type == clingo.ast.ASTType.TheoryAtom:  # For label rules
                generated_rules = "%{comment}\n{head} :- {body}.\n".\
                    format(comment=str(ast),
                           head=str(ast['head']),
                           body=",".join([str(add_prefix('holds_', lit)) for lit in literals])
                           )
            else:
                # Generates fired rule
                fired_head = "fired_{counter}({arguments})".format(
                    counter=str(rule_counter),
                    arguments=",".join(unique_everseen(map(str, head_function['arguments'] + body_variables(ast['body']))))
                )
                if literals or other:
                    fired_rule = "{head} :- {body}.".format(
                        head=fired_head,
                        body=",".join([str(add_prefix('holds_', lit)) for lit in literals] + list(map(str, other))))
                else:
                    fired_rule = fired_head + "."

                # Generates holds rule
                holds_rule = "{operator}holds_{name}({arguments}) :- {body}.".\
                    format(
                        operator="-" if is_classic_negation else "",
                        name=str(head_function['name']),
                        arguments=",".join(map(str, head_function['arguments'])),
                        body=fired_head
                    )

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

        _add_to_base(generated_rules, builder, t_option)


def prepare_xclingo_program(original_program, t_option):
    control = XClingoProgramControl(["-n 0", "--keep-facts"])

    # Pre-processing original program
    translated_program = _translate_label_rules(original_program)
    translated_program = _translate_label_atoms(translated_program)

    aux = translated_program
    translated_program = _translate_explains(translated_program)

    control.have_explain = bool(aux != translated_program)

    # Sets theory atom &label and parses/handles input program
    with control.builder() as builder:
        # Adds theories
        clingo.parse_program("#program base. #theory label_rule {t { }; &label_rule/0: t, any}.",
                             lambda ast: builder.add(ast))
        clingo.parse_program("#program base. #theory label_atoms {t { }; &label_atoms/0: t, any}.",
                             lambda ast: builder.add(ast))
        # Handle xclingo sentences
        clingo.parse_program("#program base." + translated_program,
                             lambda ast: _translate_to_fired_holds(ast, control, builder, t_option))

    return control
