import argparse
import sys
import xclingo.old as old_implementation

from xclingo import explain_program


def main():
    # Handles arguments of xclingo
    parser = argparse.ArgumentParser(description='Tool for debugging and explaining ASP programs')
    parser.add_argument('--debug-level', type=str, choices=["none", "magic-comments", "translation", "causes"], default="none",
                        help="Points out the debugging level. Default: none.")
    parser.add_argument('--auto-tracing', type=str, choices=["none", "facts", "all"], default="none",
                        help="Automatically creates traces for the rules of the program. Default: none.")
    parser.add_argument('--imp', type=str, choices=["old", "new"],
                        default="new",
                        help="Warning: development option.")
    parser.add_argument('--format', type=str, choices=["text", "dict"],
                        default="text",
                        help="Warning: development option.")
    parser.add_argument('-n', default=1, type=int, help="Number of answer sets.")
    parser.add_argument('infile', nargs='+', type=argparse.FileType('r'), default=sys.stdin, help="ASP program")
    args = parser.parse_args()

    # Reads input files
    original_program = ""
    for file in args.infile:
        original_program += file.read()

    if args.imp == "new":
        explain_program(original_program, args.n, args.debug_level, args.auto_tracing, args.format)
    else:
        print(old_implementation.explain_program_old(original_program, args.n, args.debug_level, args.auto_tracing, args.format))

    


if __name__ == "__main__":
    main()