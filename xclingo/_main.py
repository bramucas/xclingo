import clingo
from clingo import parse_program

import xclingo.translation as translation
from xclingo.postprocessing import XclingoModel
from xclingo.explain import Label
from xclingo.utils import solve_operations, fhead_from_theory_term


class XclingoControl(clingo.Control):
    """
    Extends Control class with xclingo functions and parameters.
    """
    _rule_counter = None
    traces = None
    labels_dict = None
    have_explain = None

    def __init__(self, *args):
        self.rule_counter = 0
        self.traces = {}
        labels_dict = {}
        self.have_explain = False
        super().__init__(*args)

    def count_rule(self):
        current = self.rule_counter
        self.rule_counter += 1
        return current

    def __build_labels_dict(self):
        """
        Constructs a dictionary with the processed labels for the program indexed by fired_id or the str version of an atom.
        Must be called after grounding.
        @param c_control: clingo.Control object containing the theory atoms after grounding.
        @return dict:
        """
        labels_dict = dict()
        for atom in self.theory_atoms:
            name = atom.term.name
            terms = atom.elements[0].terms

            if name == "trace_all":
                label = Label(str(terms[1]), solve_operations(terms[2:]))
                index = fhead_from_theory_term(terms[0])
                if index in labels_dict:
                    labels_dict[index].append((atom.literal, label))
                else:
                    labels_dict[index] = [(atom.literal, label)]

            elif name == "trace":
                label = Label(str(terms[2]), solve_operations(terms[3:]))
                index = int(str(terms[0]))
                fired_head = fhead_from_theory_term(terms[1])

                if index not in labels_dict:
                    labels_dict[index] = {}

                labels_dict[index][fired_head] = (atom.literal, label)

        return labels_dict

    def ground(self, *args):
        super().ground(*args)
        self.labels_dict = self.__build_labels_dict()

    def solve(self, yield_=True, auto_tracing="none"):
        with super().solve(yield_=yield_) as it:
            sol_n = 0
            for m in it:
                sol_n += 1
                yield XclingoModel(m, self.traces, self.labels_dict, auto_tracing)
                


def prepare_xclingo_program(clingo_arguments, original_program, debug_level):
    control = XclingoControl(clingo_arguments)

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