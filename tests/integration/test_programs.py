import pytest

from os import listdir
from pathlib import Path
from re import search
from xclingo import prepare_xclingo_program


TEST_PROGRAMS_DIR = "tests/integration/test_programs_files"

reserved_words = ["_result", "_auto_all", "_auto_facts"]


@pytest.fixture(scope="class")
def pnames():
    """
    Finds all the files within TEST_PROGRAMS_DIR that end in '_result.txt' and returns a tuple containg the name of the program (the name of the file after removing extension and reserved words)
    """
    pname_list = []
    pname = None
    for fname in [f for f in listdir(TEST_PROGRAMS_DIR) if search(r".+_result\.txt", f)]:
        pname = fname.replace(".txt", "")
        for word in reserved_words:
            pname = pname.replace(word, "")
        pname_list.append( (f'{TEST_PROGRAMS_DIR}/{pname}.lp', f'{TEST_PROGRAMS_DIR}/{fname}') )
    return pname_list

def get_auto_tracing(pname):
    if "auto_all" in pname:
        return "all"
    elif "auto_facts" in pname:
        return "facts"
    else:
        return "none"


def all_text_explanations(path_to_program, auto_tracing):
    text = ""

    original_program = ""
    with open(path_to_program, "r") as f:
        original_program = f.read()

    control = prepare_xclingo_program(
        [f"-n 0", "--project"], original_program, auto_tracing
    )
    control.ground([("base", [])])
    for m in control.solve(yield_=True, auto_tracing=auto_tracing):
        text += f"Answer: {m.number}\n"
        for xs in m.xclingo_symbols():
            text += f">> {xs.symbol}\n"
            for e in xs.expanded_explanations:
                text += e.ascii_tree() + "\n\n"
    return text


# Tests
def test_programs(pnames):
    # TODO: test auto-tracing within program names
    for program_path, result_path in pnames:
        try:
            assert Path(result_path).read_text() == all_text_explanations(
                program_path, get_auto_tracing(result_path)
            )
        except AssertionError as e:
            print(f'[TEST PROGRAM FAILED] "{result_path}"')
            raise e
