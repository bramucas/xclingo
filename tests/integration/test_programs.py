import pytest

from os import listdir
from pathlib import Path
from re import search
from xclingo import prepare_xclingo_program


TEST_PROGRAMS_DIR = 'tests/integration/test_programs_files'

@pytest.fixture(scope="class")
def pnames():
    return [f_name.replace(".lp", "") for f_name in listdir(TEST_PROGRAMS_DIR) if search(r'.+\.lp', f_name)]

def get_program_paths(program_name):
    """
    Returns both program and result path for a given program name
    @param program_name:
    @return (str, str): program path, and result path
    """
    return ("{dir}/{name}.lp".format(dir=TEST_PROGRAMS_DIR, name=program_name),
            "{dir}/{name}_result.txt".format(dir=TEST_PROGRAMS_DIR, name=program_name))

def all_text_explanations(path_to_program):
    text = ""

    original_program = ""
    with open(path_to_program, 'r') as f:
        original_program = f.read()

    control = prepare_xclingo_program([f'-n 0', "--project"], original_program, "none")
    control.ground([("base", [])])
    for m in control.solve(yield_=True, auto_tracing="none"):
        text += f'Answer: {m.number}\n'
        for xs in m.xclingo_symbols():
            text += f'>> {xs.symbol}\n'
            for e in xs.expanded_explanations:
                text+=e.ascii_tree()+"\n\n"
    return text

# Tests
def test_programs(pnames):
    #TODO: test auto-tracing within program names
    for p_name in pnames:
        program_path, result_path = get_program_paths(p_name)
        try:
            assert Path(result_path).read_text() ==  all_text_explanations(program_path)
        except AssertionError as e:
            print(f'[TEST PROGRAM FAILED] "{p_name}"')
            raise e
