from functools import cmp_to_key
from os import listdir
from pathlib import Path
from xclingo import explain_program
from re import search
from ast import literal_eval

TEST_PROGRAMS_DIR = 'tests/integration/test_programs_files'


def get_program_paths(program_name):
    """
    Returns both program and result path for a given program name
    @param program_name:
    @return (str, str): program path, and result path
    """
    return ("{dir}/{name}.lp".format(dir=TEST_PROGRAMS_DIR, name=program_name),
            "{dir}/{name}_result.txt".format(dir=TEST_PROGRAMS_DIR, name=program_name))


# def test_programs():
#     for n_sol, sol in sols_dict.items():
#         for atom, expls in sol.items():
#             sols_dict[n_sol][atom] = sorted(expls, key=cmp_to_key(compare_expls))

#     for p_name in [f_name.replace(".lp", "") for f_name in listdir(TEST_PROGRAMS_DIR) if search(r'.+\.lp', f_name)]:
#         program_path, result_path = get_program_paths(p_name)
#         try:
#             assert order_solutions_dict(literal_eval(Path(result_path).read_text())) == \
#                    order_solutions_dict(explain_program(Path(program_path).read_text(), 0, "none", "none", "dict"))
#         except AssertionError as e:
#             print(f'[TEST PROGRAM FAILED] "{p_name}"')
#             raise e
