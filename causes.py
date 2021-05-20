from itertools import product as itertools_product


class FiredAtom:

    def __init__(self, atom, atom_labels=list(), alternative_causes=list()):
        self.atom = atom
        self.atom_labels = atom_labels
        self.alternative_causes = alternative_causes

    def add_alternative_cause(self, cause):
        if type(cause) != FiredRule:
            raise TypeError("Value is not a Cause class instance!")
        self.alternative_causes.append(cause)

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
                self.atom_labels+[rl for ac in self.alternative_causes for rl in ac.labels if rl],
                []
            )
        else:
            causes = list()
            for ac in self.alternative_causes:                
                causes.append(decide_instantiation(
                    self.atom_labels+ac.labels,
                    [] if not ac.joint_causes else 
                    [ac.joint_causes[-1].explanation] if len(ac.joint_causes) == 1
                    else [Conjunction([jc.explanation for jc in ac.joint_causes])]
                ))
            return Disjunction(causes)

    def text_explanation(self, include_header=False):
        return "{header}\n{explanations}".format(
            header=f'>> {self.atom}\t[{len(self.expanded_explanations)}]' if include_header else "",
            explanations="\n\n".join([e.ascii_tree(level=0) for e in self.expanded_explanations])
            if self.expanded_explanations else "\t1"
        )

    def dict_explanation(self):
        return [e.as_label_dict() for e in self.expanded_explanations]

    def is_fact(self):
        return len([jc for ac in self.alternative_causes for jc in ac.joint_causes]) == 0

    def __str__(self):
        return str(self.atom)


class FiredRule:

    def __init__(self, fired_id, labels=list(), joint_causes=list(), causes_dict=None, clingo_atoms=None):
        if (causes_dict is None) != (clingo_atoms is None):
            raise RuntimeError("When lazy initializing FiredRule both 'cause_dict' and "
                               "'clingo_atoms' parameters must be provided")
        self.fired_id = fired_id
        self.labels = labels
        if causes_dict and clingo_atoms:
            setattr(self, "_causes_dict", causes_dict)
            setattr(self, "_clingo_atoms", clingo_atoms)
        else:
            setattr(self, "_joint_causes", joint_causes)

    @property
    def joint_causes(self):
        if hasattr(self, "_causes_dict") and hasattr(self, "_clingo_atoms"):
            try:
                setattr(self, "_joint_causes", list([self._causes_dict[lit] for lit in self._clingo_atoms]))
            except KeyError as ke:
                raise RuntimeError(f'Failing when accessing provided causes_dict: {ke}')
            delattr(self, "_causes_dict")
            delattr(self, "_clingo_atoms")
        return self._joint_causes


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


class Solution:

    def __init__(self, number, fired_atoms=set(), atoms_to_explain=set()):
        self.number = number
        self.fired_atoms = fired_atoms
        self.atoms_to_explain = atoms_to_explain

    def text_explanations(self):
        return "Answer: {sol_number}\n{explanations}".format(
                    sol_number=self.number,
                    explanations="\n\n".join(self.fired_atoms[a].text_explanation(include_header=True)
                                             for a in self.atoms_to_explain)
                )

    def dict_explanations(self):
        return {str(a): self.fired_atoms[a].dict_explanation() for a in self.atoms_to_explain}


class Explanation:

    @classmethod
    def from_dict(cls, d):
        if d == 1:
            return Fact()
        elif len(d) > 1:
            return Conjunction(
                {CausedBy(Label(key), Explanation.from_dict(val) if val else Fact()) for key, val in d.items()}
            )
        else:
            for key, val in d.items():
                return CausedBy(
                    Label(key),
                    Explanation.from_dict(val)
                )

    @staticmethod
    def ascii_root():
        return "  *\n"

    @staticmethod
    def ascii_branch(level):
        return "  |" * (level + 1) + "__"

    def expand(self):
        """
        Breaks all the disjunctions inside the explanation. As a result, the method returns a list of Explanations
        @return list[Explanation]:
        """
        raise NotImplementedError

    def ascii_tree(self):
        """
        Returns the explanation as an ascii tree. It fails with "NotImplementedError" if the explanation constains a
        disjunction.
        @return str:
        """
        raise NotImplementedError

    def as_label_dict(self):
        """
        Returns the explanation as dictionary using the labels as keys. It fails with "NotImplementedError" if the
        explanation contains a disjunction.
        @return dict:
        """
        raise NotImplementedError

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


class Fact(Explanation):

    def __init__(self):
        pass

    def expand(self):
        return [self]

    def ascii_tree(self, level=0):
        return "  1" if level == 0 else ""

    def as_label_dict(self):
        return {}

    def as_formula(self):
        raise NotImplementedError

    def is_equal(self, other):
        if not isinstance(other, Fact):
            return False
        return True


class Conjunction(Explanation):

    def __init__(self, elements):
        """

        @param set[Explanation] elements:
        """
        if not isinstance(elements, list):
            raise TypeError("Conjuction constructor must be provided with a list.")
        self.elements = elements

    def ascii_tree(self, level=0):
        return "{root}{tree}".format(
            root=Explanation.ascii_root() if level == 0 else "",
            tree="".join([e.ascii_tree(level=level) for e in self.elements])
        )

    def as_label_dict(self):
        """
        @return dict:
        """
        d = {}
        for e in self.elements:
            d.update(e.as_label_dict())
        return d

    def as_formula(self):
        raise NotImplementedError

    def expand(self):
        return [Conjunction(list(tup)) for tup in itertools_product(*[e.expand() for e in self.elements])]

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


class Disjunction(Explanation):

    def __init__(self, elements=None):
        """

        @param set[Explanation] elements:
        """
        if not isinstance(elements, list):
            raise TypeError("Disjunction constructor must be provided with a list.")
        self.elements = elements

    def ascii_tree(self, level=0):
        raise RuntimeError("An explanation with a disjunction cannot be printed as an ascii tree.")

    def as_label_dict(self):
        raise RuntimeError("An explanation with a disjunction cannot be exported to dict.")

    def as_formula(self):
        raise NotImplementedError

    def expand(self):
        return [expanded for dis_e in self.elements for expanded in dis_e.expand()]

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


class CausedBy(Explanation):

    def __init__(self, caused, cause=Fact()):
        """

        @param Label caused:
        @param Explanation cause:
        """
        self.caused = caused
        self.cause = cause

    def ascii_tree(self, level=0):
        return "{root}{branch}{node}{child}".format(
            root=Explanation.ascii_root() if level == 0 else "\n",
            branch=Explanation.ascii_branch(level),
            node=self.caused.replace_values(),
            child=self.cause.ascii_tree(level=level+1)
        )

    def as_label_dict(self):
        return {self.caused.replace_values(): self.cause.as_label_dict()}

    def as_formula(self):
        raise NotImplementedError

    def expand(self):
        if isinstance(self.cause, Fact):
            return [self]
        else:
            return [CausedBy(caused, cause) for (caused, cause) in itertools_product({self.caused}, self.cause.expand())]

    def is_equal(self, other):
        if not isinstance(other, CausedBy):
            return False

        if not self.cause.is_equal(other.cause):
            return False

        return True
