from clingo import Control, parse_program
import xclingo.translation as translation

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

def prepare_xclingo_program(clingo_arguments, original_program, debug_level):
    control = XClingoProgramControl(clingo_arguments)

    # Pre-processing original program
    translated_program = translation.translate_trace(original_program)
    translated_program = translation.translate_trace_all(translated_program)

    aux = translated_program
    translated_program = translation.translate_show_all(translated_program)

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
            lambda ast_object: translation.translate_to_fired_holds(ast_object, control, builder, debug_level == "translation")
        )

    # Translation was printed during _translate_to_fired_holds so we can now exit
    if debug_level == "translation":
        exit(0)

    return control