import clingo

def find_by_prefix(model, prefix):
    """
    @param clingo.Model model:
    @param string prefix:
    @return List: a list containing all the atoms in the given model that start with the given prefix.
    """

    return [sym for sym in model.symbols(atoms=True) if str.startswith(str(sym), prefix)]


def find_and_remove_by_prefix(model, prefix):
    """
    @param clingo.Model model:
    @param string prefix:
    @return List: a list containing all the atoms in the given model that start with the given prefix.
    """
    hits = []

    for sym in model.symbols(atoms=True):
        if str.startswith(str(sym), prefix):
            hits.append(sym)
            del sym

    return hits


def find_variables(ast_list):
    """
    @param List[clingo.rule_ast.AST] body_asts:
    @return List[clingo.rule_ast.AST]: list containing the ASTs of the variables used in the body.
    """
    vars = []

    for ast in ast_list:
        if ast.type == clingo.ast.ASTType.SymbolicAtom:

            if (ast['term'].type == clingo.ast.ASTType.UnaryOperation
                    and ast['term']['operator'] == clingo.ast.UnaryOperator.Minus):
                arguments = ast['term']['argument']['arguments']
            else:
                arguments = ast['term']['arguments']

            for a in arguments:
                if a.type == clingo.ast.ASTType.Variable:
                    vars.append(a)
                if a.type == clingo.ast.ASTType.Function:
                    vars.extend(find_variables(a['arguments']))
        elif ast.type == clingo.ast.ASTType.Comparison:
            if ast['left'].type == clingo.ast.ASTType.Variable:
                vars.append(ast['left'])
            if ast['right'].type == clingo.ast.ASTType.Variable:
                vars.append(ast['right'])
        elif ast.type == clingo.ast.ASTType.Variable:
            vars.append(ast)

    return vars


def remove_prefix(prefix, ast):
    """
    @param string prefix:
    @param clingo.ast ast: (should be a clingo.Symbol or a clingo.rule_ast with type Literal or SymbolicAtom.
    @return: the rule_ast (whatever type it has) without the given prefix.
    """
    if type(ast) == clingo.Symbol:
        ast = clingo.Function(ast.name.replace(prefix, ""), ast.arguments, ast.positive)
    else:
        if ast.type == clingo.ast.ASTType.Literal:
            term = ast['atom']['term']
        elif ast.type == clingo.ast.ASTType.SymbolicAtom:
            term = ast['term']

        term['name'] = term['name'].replace(prefix, "")

    return ast


def solve_operations(values):
    solved = []
    for value in values:
        if value.type == clingo.TheoryTermType.Function:
            if value.name == "+" and len(value.arguments) == 2:
                solved.append(str(value.arguments[0].number + value.arguments[1].number))
            elif value.name == "-" and len(value.arguments) == 2:
                solved.append(str(value.arguments[0].number - value.arguments[1].number))
        else:
            solved.append(str(value))
    return solved
