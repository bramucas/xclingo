import pytest
from causes import ExpandedExplanation, Label


class TestExpandedExplanation:

    @pytest.fixture(scope="class")
    def custom_expanded_explanation(self):
        return ExpandedExplanation(
            Label("gabriel has been sentenced to prison"),
            [
                ExpandedExplanation(
                    Label("gabriel has driven drunk"),
                    [
                        ExpandedExplanation(Label("gabriel has driven a car"), []),
                        ExpandedExplanation(Label("gabriel was drunk"), [])
                    ]
                )
            ]
        )

    @pytest.fixture(scope="class")
    def expected_dict(self):
        return{
            "gabriel has been sentenced to prison": {
                "gabriel has driven drunk": {
                    "gabriel has driven a car": {},
                    "gabriel was drunk":        {}
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
        assert custom_expanded_explanation.ascii_tree(level=0) == expected_ascii_tree

    def test_from_dict(self, custom_expanded_explanation, expected_dict):

        assert ExpandedExplanation.from_dict(expected_dict).as_label_dict() == expected_dict
