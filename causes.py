from itertools import product as itertools_product


class FiredAtom:

    def __init__(self, atom, atom_labels=set(), alternative_causes=set()):
        self.atom = atom
        self.atom_labels = atom_labels
        self.alternative_causes = alternative_causes

    def add_alternative_cause(self, cause):
        if type(cause) != FiredRule:
            raise TypeError("Value is not a Cause class instance!")
        self.alternative_causes.add(cause)

    def __expand_explanations(self):
        if self.is_fact():
            return [ExpandedExplanation(l) for l in self.atom_labels.union([rl for ac in self.alternative_causes for rl in ac.labels if rl])]
        else:
            explanations = []
            for ac in self.alternative_causes:
                ac_labels = self.atom_labels.union(ac.labels)

                ac_expls = [set(tup) for tup in
                            itertools_product(*[e for e in [c.expanded_explanations for c in ac.joint_causes] if e])]

                if ac_expls:
                    explanations.extend([ExpandedExplanation(label, e) for label in ac_labels for e in ac_expls])
                else:
                    explanations.extend([ExpandedExplanation(label) for label in ac_labels])

            return explanations

    @property
    def expanded_explanations(self):
        if not hasattr(self, "_cached_expanded_explanations"):
            setattr(self, "_cached_expanded_explanations", self.__expand_explanations())
        return self._cached_expanded_explanations

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

    def __init__(self, fired_id, labels=set(), joint_causes=set(), causes_dict=None, clingo_atoms=None):
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
                setattr(self, "_joint_causes", set([self._causes_dict[lit] for lit in self._clingo_atoms]))
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


class ExpandedExplanation:

    def __init__(self, node, child=set()):
        """

        @param Label node:
        @param set(ExpandedExplanation) child:
        """
        self.node = node
        self.child = child

    @classmethod
    def from_dict(cls, d):
        for label_text, sub_d in d.items():
            return cls(
                Label(label_text),
                {cls.from_dict({k: v}) for k, v in sub_d.items()}
            )

    def ascii_tree(self, level=0):
        return "{root}{branch}{node}{child}".format(
            root="  *\n" if level==0 else "",
            branch="  |" * (level+1) + "__",
            node=self.node.replace_values(),
            child="\n" + "\n".join([c.ascii_tree(level=level+1) for c in self.child]) if self.child else ""
        )

    def as_label_dict(self):
        subtree = {}
        for c in self.child:
            subtree.update(c.as_label_dict())
        return {self.node.replace_values(): subtree}

    def is_equal(self, other):
        if self.node.replace_values() != other.replace_values():
            return False

        for c in self.child:
            found = False
            for oc in other.child:
                if c.is_equal(oc):
                    found = True
            if not found:
                return False

        return True


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
