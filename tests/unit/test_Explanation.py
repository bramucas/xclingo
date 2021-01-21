import pytest
from causes import Label
from causes import Explanation, CausedBy, Conjunction, Disjunction


class TestExpandedExplanation:

    @pytest.fixture(scope="class")
    def custom_expanded_explanation(self):
        return CausedBy(
            Label("gabriel has been sentenced to prison"),
            CausedBy(
                    Label("gabriel has driven drunk"),
                    Conjunction({
                        CausedBy(Label("gabriel has driven a car")),
                        CausedBy(Label("gabriel was drunk"))
                    })
                )
        )

    @pytest.fixture(scope="class")
    def custom_disjunctive_explanation(self):
        return CausedBy(
            Label("gabriel has been sentenced to prison"),
            Disjunction({
                #camino1
                CausedBy(Label("gabriel has resisted to authority")),
                #camino2
                CausedBy(
                    Label("gabriel has driven drunk"),
                    Conjunction({
                        CausedBy(Label("gabriel has driven a car")),
                        CausedBy(Label("gabriel was drunk"))
                    })
                )
            })
        )

    @pytest.fixture(scope="class")
    def expected_dict(self):
        return{
            "gabriel has been sentenced to prison": {
                "gabriel has driven drunk": {
                    "gabriel has driven a car": {},
                    "gabriel was drunk": {}
                }
            }
        }

    def test_label_dict(self, custom_expanded_explanation, expected_dict):
        assert custom_expanded_explanation.as_label_dict() == expected_dict

    def test_ascii_tree(self, custom_expanded_explanation):
        expected_ascii_tree = \
            "  *\n" \
            "  |__gabriel has been sentenced to prison\n"\
            "  |  |__gabriel has driven drunk\n"\
            "  |  |  |__gabriel has driven a car\n" \
            "  |  |  |__gabriel was drunk"
        expected_ascii_tree2 = \
            "  *\n" \
            "  |__gabriel has been sentenced to prison\n" \
            "  |  |__gabriel has driven drunk\n" \
            "  |  |  |__gabriel was drunk\n" \
            "  |  |  |__gabriel has driven a car"
        result_expl = custom_expanded_explanation.ascii_tree(level=0)
        assert result_expl == expected_ascii_tree or result_expl == expected_ascii_tree2

    def test_from_dict(self, custom_expanded_explanation, expected_dict):
        assert Explanation.from_dict(expected_dict).as_label_dict() == expected_dict

    def test_expand(self, custom_disjunctive_explanation):
        expected_expanded_explanations = {
            CausedBy(
                Label("gabriel has been sentenced to prison"),
                CausedBy(Label("gabriel has resisted to authority")),
            )
            ,
            CausedBy(
                Label("gabriel has been sentenced to prison"),
                    CausedBy(
                        Label("gabriel has driven drunk"),
                        Conjunction({
                            CausedBy(Label("gabriel has driven a car")),
                            CausedBy(Label("gabriel was drunk"))
                        })
                    )
            )
        }
        for e in custom_disjunctive_explanation.expand():
            found = False
            for e2 in expected_expanded_explanations:
                if e.is_equal(e2):
                    found = True
                    break
            assert found

    def test_is_equal(self, custom_disjunctive_explanation):
        # disjuction and conjunction orders are changed
        changed_explanation = CausedBy(
            Label("gabriel has been sentenced to prison"),
            Disjunction({
                #camino1
                CausedBy(
                    Label("gabriel has driven drunk"),
                    Conjunction({
                        CausedBy(Label("gabriel was drunk")),
                        CausedBy(Label("gabriel has driven a car"))
                    })
                ),
                #camino2
                CausedBy(Label("gabriel has resisted to authority"))
            })
        )
        assert changed_explanation.is_equal(custom_disjunctive_explanation)
