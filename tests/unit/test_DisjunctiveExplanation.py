import pytest
from xclingo.explain import Explanation, ExplanationNode, ExplanationRoot, Label, DisjunctiveExplanation, CausedBy, Conjunction, Disjunction


class TestDisjunctiveExplanation:

    @pytest.fixture(scope="class")
    def custom_disjunctive_explanation(self):
        return CausedBy(
            Label("gabriel has been sentenced to prison"),
            Disjunction([
                #camino1
                CausedBy(Label("gabriel has resisted to authority")),
                #camino2
                CausedBy(
                    Label("gabriel has driven drunk"),
                    Conjunction([
                        CausedBy(Label("gabriel has driven a car")),
                        CausedBy(Label("gabriel was drunk"))
                    ])
                )
            ])
        )

    def test_is_equal(self, custom_disjunctive_explanation):
        # disjuction and conjunction orders are changed
        changed_explanation = CausedBy(
            Label("gabriel has been sentenced to prison"),
            Disjunction([
                # path 1
                CausedBy(
                    Label("gabriel has driven drunk"),
                    Conjunction([
                        CausedBy(Label("gabriel was drunk")),
                        CausedBy(Label("gabriel has driven a car"))
                    ])
                ),
                # path 2
                CausedBy(Label("gabriel has resisted to authority"))
            ])
        )
        assert changed_explanation.is_equal(custom_disjunctive_explanation)

    def test_expand(self, custom_disjunctive_explanation):
        expected_expanded_explanations = [
            ExplanationRoot([
                ExplanationNode(
                    Label("gabriel has been sentenced to prison"),
                        [
                            ExplanationNode(Label("gabriel has driven drunk"),
                            [
                                ExplanationNode(Label("gabriel was drunk")),
                                ExplanationNode(Label("gabriel has driven a car")),
                            ])
                        ]
                )
            ]),
            ExplanationRoot([
                ExplanationNode(
                    Label("gabriel has been sentenced to prison"),
                    [
                    ExplanationNode(Label("gabriel has resisted to authority"))
                    ]
                ),
            ]),
        ]
        for e in custom_disjunctive_explanation.expand():
            found = False
            for e2 in expected_expanded_explanations:
                if e.is_equal(e2):
                    found = True
                    break
            assert found


