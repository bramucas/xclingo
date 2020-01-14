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


class XClingoAST(ast.AST):

    def __init__(self, base_ast):
        super().__init__(base_ast.type)
        # Convert children that are AST
        for k in base_ast:
            if type(base_ast[k]) == ast.AST:
                self[k] = XClingoAST(base_ast[k])
            elif type(base_ast[k]) == list:  # Only the elements that are AST
                self[k] = [XClingoAST(item) if type(item) == ast.AST else item
                           for item in base_ast[k]]
            else:  # If is not AST or list(AST) then do nothing
                self[k] = base_ast[k]

    def is_constraint(self):
        """
        @return bool: True if the rule is a constraint, False if not.
        """
        return self['head']['atom'].type == ast.ASTType.BooleanConstant and self['head']['atom']['value'] == False

    def is_trace_all_rule(self):
        """
        @return bool: True if the rule is an instance of a xclingo trace_all rule, False if not.
        """
        return self['head'].type == ast.ASTType.TheoryAtom and self['head']['term']['name'] == "trace_all"

    def is_show_all_rule(self):
        """
        @return bool: True if the rule is an instance of a xclingo show_all rule, False if not.
        """
        return str(self['head']).startswith("show_all_")

    def add_prefix(self, prefix):
        """
        It will try to add a prefix to this AST. It can raise an exception if the action has no sense (this depends on
        the type of the AST). If the ast is Rule type, then the prefix will be added only to the atoms in the body if it
        has a body, or only to the atom in the head in the other case.

        @param str prefix: the prefix that is intended to be added to the AST.
        @return None:
        """
        # Rules special case
        if self.type == ast.ASTType.Rule:
            # Rules with body
            if self['body']:
                # Adds the prefix to all the asts in the body but not to the head
                for b_ast in self['body']:
                    b_ast.add_prefix(prefix)
                return
            # Facts (rules without body)
            else:
                # Adds the prefix to the ast of the head
                self['head'].add_prefix(prefix)
        else:
            fun = self.get_function()
            if fun:
                fun['name'] = prefix + fun['name']

    def get_function(self):
        """
        If the AST has a unique function inside of it (some types as Comparison can have multiple functions) then it
        will return it.
        @return XClingoAST: the function inside of the ast.
        """
        if self.type in (ast.ASTType.Function, ast.ASTType.TheoryFunction):
            return self

        if self.type == ast.ASTType.SymbolicAtom:
            return self['term'].get_function()

        if self.type == ast.ASTType.UnaryOperation:
            return self['argument'].get_function()

        if self.type == ast.ASTType.Literal:
            return XClingoAST(self['atom']).get_function()

        if self.type in (ast.ASTType.Comparison, ast.ASTType.BooleanConstant):
            return None

        print(self)
        print(self.type)
        raise RuntimeError(str(self.type) + "  do not have Function.")


def _translate_label_rules(program):
    """
    Replaces the 'label_rule' magic comments in the given program for a version of the rules labelled with theory atoms.
    @param str program: the program that is intended to be modified.
    @return str:
    """
    for hit in re.findall("(%!trace \{(.*)\}[ ]*\n[ ]*(\-?[a-z][a-zA-Z]*(?:\((?:[\-a-zA-Z0-9 \(\)\,\_])+\))?[ ]*:-[ ]*.*).)", program):
        # 0: original match  1: label_parameters  2: complete original rule
        program = program.replace(
            hit[0],
            "{rule}, &trace{{{label_parameters}}}.\n".format(rule=hit[2], label_parameters=hit[1])
        )

    return program


def _translate_label_atoms(program):
    """
    Replaces the 'label_atoms' magic comments in the given program for label_atoms rule.
    @param str program: the program that is intended to be modified
    @return str:
    """
    for hit in re.findall("(%!trace_all \{(.*)\} (\-?[a-z][a-zA-Z]*(?:\((?:[\-a-zA-Z0-9 \(\)\,\_])+\)))(?:[ ]*:-[ ]*(.*))?\.)", program):
        # 0: original match 1: "label",v1,v2  2: head  3: body.
        program = program.replace(
            hit[0],
            "&trace_all{{{head},{parameters} : }} :- {head}{rest_body}.\n".format(
                head=hit[2], parameters=hit[1], rest_body="," + hit[3] if hit[3] else "")
        )

    return program


def _translate_explains(program):
    """
    Replaces 'explain' magic comments in the given program for a rule version of those magic comments.
    @param str program:
    @return:
    """
    for hit in re.findall("(%!show_all ((\-?[a-z][a-zA-Z]*(?:\((?:[\-a-zA-Z0-9 \(\)\,\_])+\)))(?:[ ]*:-[ ]*(.*))?\.))", program):
        # 0: original match  1: rule  2: head of the rule  3: body of the rule
        program = program.replace(
            hit[0],
            "{prefix}{head}:-{head}{body}.".format(prefix="show_all_", head=hit[2], body="," + hit[3] if hit[3] else "")
        )

    return program


def _separate_labels_from_body(body_asts):
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
    Translate the different possible xclingo rules their clingo version making use of 'fired_' and 'holds_' prefixes,
    then it adds them to the base program using the given builder object.
    Also it keep trace (inside the given control object) of the rule information that is necessary for computing the
    causes after the solving phase.

    @param ast.AST rule_ast: the AST from which the rules will be generated
    @param clingo.ProgramBuilder builder: builder of the clingo control object that will receive the generated rules.
    @param bool t_option: if enabled, the function will print the translated sentences but they will not be added to the
    builder.
    @return: None
    """
    rule_ast = XClingoAST(rule_ast)

    if rule_ast.type == ast.ASTType.Rule:

        # show_all rules, trace_all rules and constraints rules.
        if rule_ast.is_show_all_rule() or rule_ast.is_trace_all_rule() or rule_ast.is_constraint():
            if rule_ast['body']:
                rule_ast.add_prefix("holds_")
                translated_rule = str(rule_ast)
            else:
                translated_rule = str(rule_ast['head']) + "."

            generated_rules = translated_rule + "\n"
        else:  # Other cases
            rule_counter = control.count_rule()

            # Separates the &label literals in the body from the rest
            label_body, rest_body = _separate_labels_from_body(rule_ast['body'])
            # Binds the function in the head to a variable to simplify following code
            head_function = rule_ast['head'].get_function()

            # Keep trace of head, arguments and body of the rules using rule_counter
            control.traces[rule_counter] = {
                'head': (str(head_function['name']), head_function['arguments']),
                'arguments': list(
                    unique_everseen(map(str, head_function['arguments'] + body_variables(rule_ast['body'])))),
                # 'body' contains pairs of function names and arguments found in the body
                'body': [(lit.get_function()['name'], lit.get_function()['arguments'])
                         for lit in rest_body if
                         lit.type == ast.ASTType.Literal and lit['atom'].type == ast.ASTType.SymbolicAtom and lit[
                             'sign'] == ast.Sign.NoSign]
            }

            # Generates fired rule
            fired_head = "fired_{counter}({arguments})".format(
                counter=str(rule_counter),
                arguments=",".join(
                    unique_everseen(map(str, head_function['arguments'] + body_variables(rule_ast['body']))))
            )

            if rest_body:
                for a in rest_body:
                    a.add_prefix('holds_')
                fired_rule = "{fired_head} :- {body}.".format(
                    fired_head=fired_head,
                    body=",".join(map(str, rest_body)))
            else:
                fired_rule = fired_head + "."

            # Generates holds rule
            rule_ast['head'].add_prefix('holds_')
            holds_rule = "{head} :- {body}.".format(head=str(rule_ast['head']), body=fired_head)

            # Generates label rules
            label_rules = ""
            for label_ast in label_body:
                label_rules += "&trace{{{fired_id},{label_parameters}}} :- {body}.\n".format(
                    fired_id=str(rule_counter),
                    label_parameters=",".join([str(e) for e in label_ast['atom']['elements']]),
                    body=fired_head)

            # Generates a comment
            comment = "%" + str(rule_ast)

            generated_rules = comment + "\n" + fired_rule + "\n" + holds_rule + "\n" + label_rules

        _add_to_base(generated_rules, builder, t_option)


def prepare_xclingo_program(clingo_arguments, original_program, debug_level):
    control = XClingoProgramControl(clingo_arguments)

    # Pre-processing original program
    translated_program = _translate_label_rules(original_program)
    translated_program = _translate_label_atoms(translated_program)

    aux = translated_program
    translated_program = _translate_explains(translated_program)

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
            lambda ast_object: _translate_to_fired_holds(ast_object, control, builder, debug_level == "translation")
        )

    # Translation was printed during _translate_to_fired_holds so we can now exit
    if debug_level == "translation":
        exit(0)

    return control
