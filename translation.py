from collections import Iterable

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


class XClingoAST():
    _internal_ast = None  # Type: ast.AST
    type = None  # Type: ast.AST.ASTType
    child_keys = None  # Type: List [ str ]

    # l =[method for method in dir(my_ast) if method != 'use_enumeration_assumption' and callable(getattr(my_ast, method))]

    def __init__(self, base_ast):
        """

        @param ast.AST base_ast:
        """
        self._internal_ast = base_ast

        self.type = base_ast.type
        self.child_keys = base_ast.child_keys

    """ast.AST methods"""
    def items(self):
        return self._internal_ast.items()

    def keys(self):
        return self._internal_ast.keys()

    def values(self):
        return self._internal_ast.values()

    """container methods and other"""
    def __contains__(self, item):
        return self._internal_ast.__contains__(item)

    def __getitem__(self, item):
        item = self._internal_ast.__getitem__(item)
        if type(item) == ast.AST:
            return XClingoAST(item)
        if type(item) == list:
            new_list = []
            for i in item:
                if type(i) == ast.AST:
                    new_list.append(XClingoAST(i))
                else:
                    new_list.append(i)
            return new_list
        else:
            return item

    def __delattr__(self, item):
        self._internal_ast.__delattr__(item)

    def __delitem__(self, key):
        self._internal_ast.__delitem__(key)

    def __eq__(self, other):
        return self._internal_ast.__eq__(other)

    def __format__(self, format_spec):
        return self._internal_ast.__format__(format_spec)

    def __ge__(self, other):
        return self._internal_ast.__ge__(other)

    # def __getattribute__(self, item):
    #     return self._internal_ast.__getattribute__(item)

    def __gt__(self, other):
        return self._internal_ast.__gt__(other)

    def __iter__(self):
        return self._internal_ast.__iter__()

    def __le__(self, other):
        return self._internal_ast.__le__()

    def __len__(self):
        return self._internal_ast.__len__()

    def __lt__(self, other):
        return self._internal_ast.__lt__()

    def __ne__(self, other):
        return self._internal_ast.__ne__()

    # def __setattr__(self, key, value):
    #     self._internal_ast.__setattr__(key, value)

    def __setitem__(self, key, value):
        self._internal_ast.__setitem__(key, value)

    def __str__(self):
        return self._internal_ast.__str__()

    """XclingoAST methods"""

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
        return str(self['head']).startswith("show_all_") or str(self['head']).startswith("nshow_all_")

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
            return self['atom'].get_function()

        if self.type in (ast.ASTType.Comparison, ast.ASTType.BooleanConstant):
            return None

        print(self)
        print(self.type)
        raise RuntimeError(str(self.type) + "  do not have Function.")


def _translate_trace(program):
    """
    Replaces the 'label_rule' magic comments in the given program for a version of the rules labelled with theory atoms.
    @param str program: the program that is intended to be modified.
    @return str:
    """
                         # (%!trace \{(.*)\}[ ]*\n[ ]*(\-?[a-z][a-zA-Z]*(?:\((?:[\-a-zA-Z0-9+ \(\)\,\_])+\))?(?:[ ]*:-[ ]*.*)?).)
    for hit in re.findall("(%!trace_rule \{(.*)\}[ ]*[\n ]*(\-?[_a-z][_a-zA-Z]*(?:\((?:[\-a-zA-Z0-9+ \(\)\,\_])+\))?)(?:[ ]*:-[ ]*(.*))?.)", program):
        # 0: original match  1: label parameters  2: head of the rule  3: body of the rule
        program = program.replace(
            hit[0],
            "{head} :- {body} &trace{{{label_parameters}}}.\n".format(
                head=hit[2], label_parameters=hit[1],
                body=hit[3] + "," if hit[3] else ""
            )
        )

    return program


def _translate_trace_all(program):
    """
    Replaces the 'label_atoms' magic comments in the given program for label_atoms rule.
    @param str program: the program that is intended to be modified
    @return str:
    """
    for hit in re.findall("(%!trace \{(.*)\} (\-?[_a-z][_a-zA-Z]*(?:\((?:[\-\+a-zA-Z0-9 \(\)\,\_])+\)))(?:[ ]*:[ ]*(.*))?\.)", program):
        # 0: original match 1: "label",v1,v2  2: head  3: body.
        program = program.replace(
            hit[0],
            "&trace_all{{{head},{parameters} : }} :- {head}{rest_body}.\n".format(
                head=hit[2], parameters=hit[1], rest_body="," + hit[3] if hit[3] else "")
        )

    return program


def _translate_show_all(program):
    """
    Replaces 'explain' magic comments in the given program for a rule version of those magic comments.
    @param str program:
    @return:
    """
    for hit in re.findall("(%!show_trace ((\-)?([_a-z][_a-zA-Z]*(?:\((?:[\-a-zA-Z0-9 \(\)\,\_])+\)))(?:[ ]*:[ ]*(.*))?\.))", program):
        # 0: original match  1: rule  2: negative_sign  3: head of the rule  4: body of the rule
        program = program.replace(
            hit[0],
            "{sign}{prefix}{head}:-{classic_negation}{head}{body}.".format(
                sign="" if not hit[2] else "n",
                prefix="show_all_",
                head=hit[3],
                classic_negation="" if not hit[2] else "-",
                body="," + hit[4] if hit[4] else "")
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
            fired_head_variables = list(map(str, head_function['arguments'])) + \
                                   list(set(map(str, body_variables(rule_ast['body']))) - set(map(str, head_function['arguments'])))


            control.traces[rule_counter] = {
                'head': (rule_ast['head']['atom']['term'].type != ast.ASTType.UnaryOperation,
                         str(head_function['name']), head_function['arguments']),
                'arguments': fired_head_variables,
                # 'body' contains pairs of function names and arguments found in the body
                'body': [(lit['atom']['term'].type != ast.ASTType.UnaryOperation,
                          lit.get_function()['name'], lit.get_function()['arguments'])
                         for lit in rest_body if
                         lit.type == ast.ASTType.Literal and lit['atom'].type == ast.ASTType.SymbolicAtom and lit[
                             'sign'] == ast.Sign.NoSign]
            }

            # Generates fired rule
            fired_head = "fired_{counter}({arguments})".format(
                counter=str(rule_counter),
                arguments=",".join(fired_head_variables)
            )

            if rest_body:
                for a in rest_body:
                    a.add_prefix('holds_')
                fired_rule = "{fired_head} :- {body}.".format(
                    fired_head=fired_head,
                    body=",".join(map(str, rest_body)))
            else:
                fired_rule = fired_head + "."

            # Generates label rules
            label_rules = ""
            for label_ast in label_body:
                label_rules += "&trace{{{fired_id},{original_head},{label_parameters}}} :- {body}.\n".format(
                    fired_id=str(rule_counter),
                    original_head=str(rule_ast['head']),
                    label_parameters=",".join([str(e) for e in label_ast['atom']['elements']]),
                    body=fired_head)

            # Generates holds rule
            rule_ast['head'].add_prefix('holds_')
            head_function['arguments'] = [ast.Variable(v['location'], "Aux" + str(head_function['arguments'].index(v._internal_ast))) for v in head_function['arguments']]
            holds_rule = "{head} :- fired_{rule_counter}({fired_arguments}).".format(
                head=rule_ast['head'],
                rule_counter=rule_counter,
                fired_arguments=",".join(["Aux" + str(i) for i in range(0,len(fired_head_variables))])
                )

            # Generates a comment
            comment = "%" + str(rule_ast)

            generated_rules = comment + "\n" + fired_rule + "\n" + holds_rule + "\n" + label_rules

        _add_to_base(generated_rules, builder, t_option)


def prepare_xclingo_program(clingo_arguments, original_program, debug_level):
    control = XClingoProgramControl(clingo_arguments)

    # Pre-processing original program
    translated_program = _translate_trace(original_program)
    translated_program = _translate_trace_all(translated_program)

    aux = translated_program
    translated_program = _translate_show_all(translated_program)

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
        print()
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
