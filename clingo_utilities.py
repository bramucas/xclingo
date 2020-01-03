import clingo

def find_by_prefix(model, prefix):
    '''
    @param clingo.Model model:
    @param string prefix:
    @return List: a list containing all the atoms in the given model that start with the given prefix.
    '''

    return [sym for sym in model.symbols(atoms=True) if str.startswith(str(sym), prefix)]


def body_variables(body_asts):
    '''
    @param List[clingo.ast.AST] body_asts:
    @return List[clingo.ast.AST]: list containing the ASTs of the variables used in the body.
    '''
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


def add_prefix(prefix, literal):
  '''
  @param string prefix
  @param clingo.ast.AST literal: (should be type==clingo.ASTTYPE.Literal)
  @return string: the string of the modified literal.
  '''

  if literal.type == clingo.ast.ASTType.Literal and literal['atom'].type == clingo.ast.ASTType.SymbolicAtom:
    literal['atom']['term']['name'] = prefix + literal['atom']['term']['name']

  return literal