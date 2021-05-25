import types
from itertools import product as itertools_product

class XclingoSymbol:

    def __init__(self, symbol, atom_labels=list(), fired_by=list()):
        self.symbol = symbol
        self.atom_labels = atom_labels
        self.fired_by = fired_by

    def add_alternative_cause(self, cause):
        if type(cause) != FiredRule:
            raise TypeError("Value is not a Cause class instance!")
        self.fired_by.append(cause)

    @property
    def expanded_explanations(self):
        if not hasattr(self, "_cached_expanded_explanations"):
            setattr(self, "_cached_expanded_explanations", self.explanation.expand())
        return self._cached_expanded_explanations

    @property
    def explanation(self):
        if not hasattr(self, "_cached_explanation"):
            setattr(self, "_cached_explanation", self.__get_explanation())
        return self._cached_explanation

    def __get_explanation(self):
        """

        @return Explanation:
        """
        def decide_instantiation(labels, caused_bys):
            """
            
            """
            if labels:
                if caused_bys:
                    if len(labels)>1:
                        return Disjunction([CausedBy(lab, c) for lab, c in itertools_product(labels, caused_bys)])
                    else:
                        return CausedBy(labels[-1], Disjunction(caused_bys) if len(caused_bys) > 1 else caused_bys[-1])
                else:
                    return Disjunction([CausedBy(lab) for lab in labels]) if len(labels) > 1 else CausedBy(labels[-1])
            else:
                return Disjunction(caused_bys) if caused_bys else Fact()
      
        if self.is_fact():
            return decide_instantiation(
                self.atom_labels+[rl for ac in self.fired_by for rl in ac.labels if rl],  # atom labels + rule labels
                []
            )
        else:
            causes = list()
            for ac in self.fired_by:                
                causes.append(decide_instantiation(
                    self.atom_labels+ac.labels,
                    [] if not ac.body else 
                    [ac.body[-1].explanation] if len(ac.body) == 1
                    else [Conjunction([jc.explanation for jc in ac.body])]
                ))
            return Disjunction(causes)

    def is_fact(self):
        return len([jc for ac in self.fired_by for jc in ac.body]) == 0

    def __str__(self):
        return str(self.symbol)


class FiredRule:

    def __init__(self, fired_id, labels=list(), body=list(), causes_dict=None, clingo_atoms=None):
        if (causes_dict is None) != (clingo_atoms is None):
            raise RuntimeError("When lazy initializing FiredRule both 'cause_dict' and "
                               "'clingo_atoms' parameters must be provided")
        self.fired_id = fired_id
        self.labels = labels
        if causes_dict and clingo_atoms:
            setattr(self, "_causes_dict", causes_dict)
            setattr(self, "_clingo_atoms", clingo_atoms)
        else:
            setattr(self, "_body", body)

    @property
    def body(self):
        if hasattr(self, "_causes_dict") and hasattr(self, "_clingo_atoms"):
            try:
                setattr(self, "_body", list([self._causes_dict[lit] for lit in self._clingo_atoms]))
            except KeyError as ke:
                raise RuntimeError(f'Failing when accessing provided causes_dict: {ke}')
            delattr(self, "_causes_dict")
            delattr(self, "_clingo_atoms")
        return self._body


class Label:

    def __init__(self, text, values=[], placeholder="%"):
        self.text = text
        self.values = values
        self.placeholder = placeholder

    def replace_values(self):
        processed_label = self.text
        for v in self.values:
            processed_label = processed_label.replace(self.placeholder, str(v), 1)
        return processed_label

    def __str__(self):
        return self.replace_values()

class DisjunctiveExplanation:

    def __explanation_from_stack(self, cb_stack):
        if not cb_stack:
            raise RuntimeError("Empty cb_stack")
        l = [ExplanationRoot(list())]   
        
        for label, level in cb_stack:
            new = ExplanationNode(label, list())
            l[level].causes.append(new)  # appends to parent
            if level+1 == len(l):
                l.append(new)
            else:                  
                l[level+1] = new  # replaces older brother            
        
        return l[0]

    def expand(self):
        """
        Breaks all the disjunctions inside the explanation. As a result, the method returns a list of Explanations
        @return list[Explanation]:
        """
        level = -1
        cb_stack = []
        stack = [(isinstance(self, CausedBy), 0, self)]

        while (stack):
            try:
                _, p, e = stack[-1]
                if isinstance(e, types.GeneratorType): # already visited, disjunction
                    current = next(e)
                    yield self.__explanation_from_stack(cb_stack)
                    cb_stack = cb_stack[:p]
                else:
                    iter = e._iterate_causes()
                    # updates stacks 
                    if isinstance(e, CausedBy):
                        level += 1
                        cb_stack.append((e.caused, level))
                    stack[-1] = (isinstance(e, CausedBy), len(cb_stack), iter)
                    
                    # next
                    current = next(iter)
                    
                for c in current:  # len(current)>1 is conjunction
                    stack.append((isinstance(c, CausedBy), len(cb_stack), c))

            except StopIteration:
                is_cb, _, _ = stack.pop()
                if is_cb:
                    level+= -1
                if not stack:
                    if cb_stack:
                        yield self.__explanation_from_stack(cb_stack)
                    else:
                        yield ExplanationRoot([ExplanationNode("1")])
                

    def as_formula(self):
        """
        Returns the explanation as a cgraphs formula. TO BE IMPLEMENTED
        @return:
        """
        raise NotImplementedError

    def is_equal(self, other):
        """
        Returns true if both explanations are the same; false in other case.
        @param Explanation other:
        @return:
        """
        raise NotImplementedError


class Fact(DisjunctiveExplanation):

    def __init__(self):
        pass

    def _iterate_causes(self):
        yield []

    def as_formula(self):
        raise NotImplementedError

    def is_equal(self, other):
        if not isinstance(other, Fact):
            return False
        return True

class Conjunction(DisjunctiveExplanation):

    def __init__(self, elements):
        """

        @param set[Explanation] elements:
        """
        if not isinstance(elements, list):
            raise TypeError("Conjuction constructor must be provided with a list.")
        self.elements = elements

    def as_formula(self):
        raise NotImplementedError

    def _iterate_causes(self):
        yield self.elements

    def is_equal(self, other):
        if not isinstance(other, Conjunction):
            return False

        for self_e in self.elements:
            found = False
            for other_e in other.elements:
                if self_e.is_equal(other_e):
                    found = True
                    break
            if not found:
                return False

        return True


class Disjunction(DisjunctiveExplanation):

    def __init__(self, elements=None):
        """

        @param set[Explanation] elements:
        """
        if not isinstance(elements, list):
            raise TypeError("Disjunction constructor must be provided with a list.")
        self.elements = elements

    def as_formula(self):
        raise NotImplementedError

    def _iterate_causes(self):
        for e in self.elements:
            yield [e]

    def is_equal(self, other):
        if not isinstance(other, Disjunction):
            return False

        for self_e in self.elements:
            found = False
            for other_e in other.elements:
                if self_e.is_equal(other_e):
                    found = True
                    break
            if not found:
                return False

        return True


class CausedBy(DisjunctiveExplanation):

    def __init__(self, caused, cause=Fact()):
        """

        @param Label caused:
        @param Explanation cause:
        """
        self.caused = caused
        self.cause = cause

    def as_formula(self):
        raise NotImplementedError

    def _iterate_causes(self):
        if isinstance(self.cause, CausedBy):
            yield [self.cause]
        else:
            for c in self.cause._iterate_causes():
                yield c
                
    def is_equal(self, other):
        if not isinstance(other, CausedBy):
            return False

        if not self.cause.is_equal(other.cause):
            return False

        return True

class Explanation:

    @staticmethod
    def ascii_branch(level):
        if level > 0:
            return "  |" * (level) + "__"
        else:
            return ""
    
    def __preorder_iterator(self):
        stack = [iter([self])]
        level = 0
        while (stack):
            try:
                current = next(stack[-1])
                yield (current, level)
                stack.append(iter(current.causes))
                level += 1
            except StopIteration:
                stack.pop()
                level += -1

    def ascii_tree(self):
        expl = ""
        for node, level in self.__preorder_iterator():
            expl += "{branch}{text}\n".format(
                branch=Explanation.ascii_branch(level),
                text=node.get_node_text(),
            )
        return expl

    def is_equal(self, other):
        if not isinstance(other, Explanation):
            return False

        for (node1, level1), (node2, level2) in zip(self.__preorder_iterator(), other.__preorder_iterator()):
            if not node1._node_equals(node2):
                return False

            if (level1 != level2):
                return False
        
        return True

class ExplanationRoot(Explanation):

    def __init__(self, causes=list()):
        if not isinstance(causes, list):
            raise RuntimeError("Parameter causes should be a list.")
        else:
            self.causes = causes

    def get_node_text(self):
        return "  *"

    def _node_equals(self, other):
        if not isinstance(other, ExplanationRoot):
            return False

        return True

class ExplanationNode(Explanation):
    """
    A non-binary tree.
    """

    def __init__(self, label, causes=list()):
        if isinstance(label, str):
            self.label = Label(label)
        elif not isinstance(label, Label):
            raise RuntimeError("Parameter label has to be a Label object.")
        else:
            self.label  = label

        if not isinstance(causes, list):
            raise RuntimeError("Parameter causes should be a list.")
        else:
            self.causes = causes

    def get_node_text(self):
        return self.label.replace_values()

    def _node_equals(self, other):
        if not isinstance(other, ExplanationNode):
            return False

        if self.label.replace_values() != other.label.replace_values():
            return False

        return True   
