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


def body_variables(body_asts):
    """
    @param List[clingo.ast.AST] body_asts:
    @return List[clingo.ast.AST]: list containing the ASTs of the variables used in the body.
    """
    vars = []

    for ast in body_asts:
        if ast['atom'].type == clingo.ast.ASTType.SymbolicAtom:

            if (ast['atom']['term'].type == clingo.ast.ASTType.UnaryOperation
                    and ast['atom']['term']['operator'] == clingo.ast.UnaryOperator.Minus):
                arguments = ast['atom']['term']['argument']['arguments']
            else:
                arguments = ast['atom']['term']['arguments']

            for a in arguments:
                if a.type == clingo.ast.ASTType.Variable:
                    vars.append(a)
        elif ast['atom'].type == clingo.ast.ASTType.Comparison:
            if ast['atom']['left'].type == clingo.ast.ASTType.Variable:
                vars.append(ast['atom']['left'])
            if ast['atom']['right'].type == clingo.ast.ASTType.Variable:
                vars.append(ast['atom']['right'])

    return vars


def add_prefix(prefix, literal):
    """
    @todo: as in 'remove_prefix' this function should be able to handle different types (asts, clingo.Symbols, etc.)

    @param string prefix:
    @param clingo.ast.AST literal: (should be type==clingo.ASTTYPE.Literal)
    @return string: the string of the modified literal.
    """
    if (literal['atom']['term'].type == clingo.ast.ASTType.UnaryOperation
                                   and literal['atom']['term']['operator'] == clingo.ast.UnaryOperator.Minus):
        literal['atom']['term']['argument']['name'] = prefix + literal['atom']['term']['argument']['name']
    elif literal.type == clingo.ast.ASTType.Literal and literal['atom'].type == clingo.ast.ASTType.SymbolicAtom:
        literal['atom']['term']['name'] = prefix + literal['atom']['term']['name']

    return literal


def remove_prefix(prefix, ast):
    """
    @param string prefix:
    @param clingo.ast ast: (should be a clingo.Symbol or a clingo.ast with type Literal or SymbolicAtom.
    @return: the ast (whatever type it has) without the given prefix.
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
