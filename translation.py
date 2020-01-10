from clingo import Control, parse_program, ast
import re
from more_itertools import unique_everseen
from clingo_utilities import body_variables


class XClingoProgramControl(Control):
    """
    Extends Control class with xclingo functions and parameters.
    """
    _rule_counter = None
    traces = None
    havesat_explain = None

    def __init__(self, *args):
        self.rule_counter = 0
        self.traces = {}
        self.have_explain = False
        super().__init__(*args)

    def count_rule(self):
        current = self.rule_counter
        self.rule_counter += 1
        return current


class XClingoAST(ast.AST):

    def __init__(self, ast):
        super().__init__(ast.type, **dict(ast.items()))

    def is_trace_all_rule(self):
        return self['head']['atom'].type == ast.ASTType.BooleanConstant and self['head']['atom']['value'] == False

    def is_show_all_rule(self):
        return (self['head'].type == ast.ASTType.TheoryAtom and self['head']['term']['name'] == "label_atoms") \
            or (str(self['head']).startswith("explain_"))

    def add_prefix(self, prefix):
        """
        It will try to add a prefix to this AST. It can raise an exception if the action has no sense (this depends on
        the type of the AST. Also, the result of executing this method is different depending on the type.
        @todo: change this function to use get_function() instead making so many comprobations

        @param str prefix: the prefix that is intended to be added to the AST.
        @return None:
        """



        # Handle classic negation
        if self.type == ast.ASTType.UnaryOperation and self['atom']['term']['operator'] == ast.UnaryOperator.Minus:
            self['atom']['term']['argument']['name'] = prefix + self['atom']['term']['argument']['name']
            return
        # Literals (but just symbolic atoms)
        elif self.type == ast.ASTType.Literal:
            atom = XClingoAST(self['atom'])
            atom.add_prefix(prefix)
            self['atom'] = atom
            return
        elif self.type == ast.ASTType.SymbolicAtom and self['term'].type == ast.ASTType.Function:
            self['term']['name'] = prefix + self['term']['name']
        # Rules
        elif self.type == ast.ASTType.Rule:
            # Rules with body
            if self['body']:
                # Adds the prefix to all the asts in the body but not to the head
                new_body = []
                for b_ast in self['body']:
                    xb_ast = XClingoAST(b_ast)
                    xb_ast.add_prefix(prefix)
                    new_body.append(xb_ast)
                self['body'] = new_body
                return
            # Facts (rules without body)
            else:
                # Adds the prefix to the ast of the head
                x_ast = XClingoAST(self['head'])
                x_ast.add_prefix(prefix)
                self['head'] = x_ast
        # It has no sense to add a prefix to this AST
        else:
            return

    def get_function(self):
        if self.type in (ast.ASTType.Function, ast.ASTType.TheoryFunction):
            return self

        if self.type == ast.ASTType.SymbolicAtom:
            return XClingoAST(self['term']).get_function()

        if self.type == ast.ASTType.UnaryOperation:
            return XClingoAST(self['argument']).get_function()

        if self.type == ast.ASTType.Literal:
            return XClingoAST(self['atom']).get_function()

        if self.type in (ast.ASTType.Comparison, ast.ASTType.BooleanConstant, ast.ASTType.Comparison):
            return

        raise RuntimeError()


def _translate_label_rules(program):
    """
    Replaces the 'label_rule' magic comments in the given program for a version of the rules labelled with theory atoms.
    @param str program: the program that is intended to be modified.
    @return str:
    """
    for hit in re.findall("(%!trace \{(.*)\}[ ]*\n[ ]*([a-z][a-zA-Z]*(?:\(.*\))?[ ]*:-[ ]*.*).)", program):
        # 0: original match  1: label_parameters  2: complete original rule
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
    for hit in re.findall("(%!trace_all \{(.*)\} ([a-z][a-zA-Z]*(?:\(.*\))?)(?:[ ]*:-[ ]*(.*))?\.)", program):
        # 0: original match 1: "label",v1,v2  2: head  3: body.
        program = program.replace(
            hit[0],
            "&label_atoms{{{head},{parameters} : }} :- {head}{rest_body}.\n".format(
                head=hit[2], parameters=hit[1], rest_body="," + hit[3] if hit[3] else "")
        )

    return program


def _translate_explains(program):
    """
    Replaces 'explain' magic comments in the given program for a rule version of those magic comments.
    @param str program:
    @return:
    """
    for hit in re.findall("(%!show_all (([a-z][a-zA-Z]*(?:\(.*\)))(?:[ ]*:-[ ]*(.*))?\.))", program):
        # 0: original match  1: rule  2: head of the rule  3: body of the rule
        program = program.replace(
            hit[0],
            "{prefix}{head}:-{head}{body}.".format(prefix="explain_", head=hit[2], body="," + hit[3] if hit[3] else "")
        )

    return program


def _handle_body_labels(body_asts):
    """
    Divides the given body (list of clingo.rule_ast) into label theory atoms, normal literals and the rest.
    @param List[clingo.rule_ast.AST] body_asts:
    @return (label_body, literals, other): tuple containing the list of label theory atoms, the symbolic atoms and
    the rest (respectively).
    """
    label_body = []
    rest = []

    for b_ast in body_asts:
        if b_ast['atom'].type == ast.ASTType.TheoryAtom:
            label_body.append(b_ast)
        else:
            rest.append(XClingoAST(b_ast))

    return label_body, rest


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
        parse_program("#program base." + rules_to_add, lambda new_ast: builder.add(new_ast))
    except RuntimeError as error:
        if str(error) == "syntax error":
            print("Translation error:\n\n{0}".format(rules_to_add))
            exit(0)


def _translate_to_fired_holds(rule_ast, control, builder, t_option):
    """
    Generates the label rules (useless for now), the fired rules and the holds rules for the given rule_ast rule and adds
    them to the 'base' program via the given builder.

    @param ast.AST rule_ast: the AST from which the rules will be generated
    @param clingo.ProgramBuilder builder: builder of the clingo control object that will receive the generated rules.
    @param bool t_option:
    @return: None
    """
    rule_ast = XClingoAST(rule_ast)

    if rule_ast.type == ast.ASTType.Rule:

        if rule_ast.is_show_all_rule() or rule_ast.is_trace_all_rule():
            # It is a constraint
            if rule_ast['body']:
                rule_ast.add_prefix("holds_")
                translated_rule = str(rule_ast)
            else:
                translated_rule = str(rule_ast['head']) + "."

            generated_rules = translated_rule + "\n"
        else:
            rule_counter = control.count_rule()

            # Separates the &label literals in the body from the rest
            label_body, rest_body = _handle_body_labels(rule_ast['body'])

            head_ast = XClingoAST(rule_ast['head'])
            head_function = head_ast.get_function()

            name_args_pairs = [ (l.get_function()['name'], l.get_function()['arguments'])
                     for l in rest_body if l.type == ast.ASTType.Literal and l['atom'].type == ast.ASTType.SymbolicAtom and l['sign'] == ast.Sign.NoSign ]

            control.traces[rule_counter] = {
                'head': (str(head_function['name']), head_function['arguments']),
                'arguments': list(unique_everseen(map(str, head_function['arguments'] + body_variables(rule_ast['body'])))),
                'body': name_args_pairs
            }

            # Generates fired rule
            fired_head = "fired_{counter}({arguments})".format(
                counter=str(rule_counter),
                arguments=",".join(unique_everseen(map(str, head_function['arguments'] + body_variables(rule_ast['body']))))
            )

            if rest_body:
                for a in rest_body:
                    a.add_prefix('holds_')
                fired_rule = "{head} :- {body}.".format(
                    head=fired_head,
                    body=",".join(map(str, rest_body)))
            else:
                fired_rule = fired_head + "."

            # Generates holds rule
            head_ast.add_prefix('holds_')
            holds_rule = "{head} :- {body}.".format(head=str(head_ast), body=fired_head)

            # Generates label rules
            label_rules = ""
            for label_ast in label_body:
                label_rules += "&label_rule{{{fired_id},{label_parameters}}} :- {body}.\n".format(
                    fired_id=str(rule_counter),
                    label_parameters=",".join([str(e) for e in label_ast['atom']['elements']]),
                    body=fired_head)

            # Generates a comment
            comment = "%" + str(rule_ast)

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
        parse_program("#program base. #theory label_rule {t { }; &label_rule/0: t, any}.",
                             lambda ast: builder.add(ast))
        parse_program("#program base. #theory label_atoms {t { }; &label_atoms/0: t, any}.",
                             lambda ast: builder.add(ast))
        # Handle xclingo sentences
        parse_program("#program base." + translated_program,
                             lambda ast: _translate_to_fired_holds(ast, control, builder, t_option))

    return control
