import argparse
import sys

from xclingo import prepare_xclingo_program

def main():
    # Handles arguments of xclingo
    parser = argparse.ArgumentParser(description='Tool for debugging and explaining ASP programs')
    parser.add_argument('--debug-level', type=str, choices=["none", "magic-comments", "translation", "causes"], default="none",
                        help="Points out the debugging level. Default: none.")
    parser.add_argument('--auto-tracing', type=str, choices=["none", "facts", "all"], default="none",
                        help="Automatically creates traces for the rules of the program. Default: none.")
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

    # Explains a logic program
    control = prepare_xclingo_program([f'-n {args.n}', "--project"], original_program, args.debug_level)
    control.ground([("base", [])])
    for m in control.solve(yield_=True, auto_tracing=args.auto_tracing):
        print(f'Answer: {m.number}')
        for xs in m.xclingo_symbols():
            print(f'>> {xs.symbol}')
            for e in xs.expanded_explanations:
                print(e.ascii_tree())
                print()

if __name__ == "__main__":
    main()