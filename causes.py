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

    def is_fact(self):
        return len([jc for ac in self.alternative_causes for jc in ac.joint_causes]) == 0

    def __str__(self):
        return str(self.atom)


class FiredRule:

    def __init__(self, fired_id, labels=set(), joint_causes=set()):
        self.fired_id = fired_id
        self.labels = labels
        self.joint_causes = joint_causes

    @property
    def joint_causes(self):
        if not hasattr(self, "_joint_causes"):
            setattr(self, "_joint_causes", set(self.__joint_causes))
        return self._joint_causes

    @joint_causes.setter
    def joint_causes(self, joint_causes):
        self.__joint_causes = joint_causes


class Label:

    def __init__(self, text=None, values=None):
        self.text = text
        self.values = values
        self.placeholder = '%'

    def replace_values(self):
        processed_label = self.text
        for v in self.values:
            processed_label = processed_label.replace(self.placeholder, str(v), 1)
        return processed_label

    def __str__(self):
        return self.replace_values()

    __repr__ = __str__


class ExpandedExplanation:

    def __init__(self, node, child=None):
        """

        @param Label node:
        @param set(ExpandedExplanation) child:
        """
        self.node = node
        self.child = child

    def ascii_tree(self, level=0):
        return "{root}{branch}{node}{child}".format(
            root="  *\n" if level==0 else "",
            branch="  |" * (level+1) + "__",
            node=self.node.replace_values(),
            child="\n" + "\n".join([c.ascii_tree(level=level+1) for c in self.child]) if self.child else ""
        )
