from os import listdir, getcwd, path
from pathlib import Path
from xclingo import explain_program
from re import search

TEST_PROGRAMS_DIR = '/home/velka/projs/asp/xclingo/tests/test_programs'


def get_program_paths(program_name):
    """
    Returns both program and result path for a given program name
    @param program_name:
    @return (str, str): program path, and result path
    """
    return ("{dir}/{name}.lp".format(dir=TEST_PROGRAMS_DIR, name=program_name),
            "{dir}/{name}_result.txt".format(dir=TEST_PROGRAMS_DIR, name=program_name))


def test_programs():
    p_names = [f_name.replace(".lp", "") for f_name in listdir(TEST_PROGRAMS_DIR) if search(r'.+\.lp', f_name)]
    for p_name in p_names:
        program_path, result_path = get_program_paths(p_name)
        try:
            assert Path(result_path).read_text().replace("\n", "") == explain_program(Path(program_path).read_text(), 0, "none", "none").replace("\n", "")
        except AssertionError as e:
            print(f'[TEST PROGRAM FAILED] "{p_name}"')
            raise e
