import pytest
from causes import Label
from causes import Explanation, ExplanationRoot, ExplanationNode


class TestExplanation:

    @pytest.fixture(scope="class")
    def custom_explanation(self):
        return ExplanationRoot([
            ExplanationNode(
                Label("gabriel has been sentenced to prison"),
                [
                    ExplanationNode(
                        Label("gabriel has driven drunk"),
                        [
                            ExplanationNode(Label("gabriel has driven a car")),
                            ExplanationNode(Label("gabriel was drunk"))
                        ])
                ]
            )
        ])

    @pytest.fixture(scope="class")
    def custom_plain_explanation(self):
        return ExplanationRoot([
            ExplanationNode("afp > 30"),
            ExplanationNode("hcc true"),
            ExplanationNode("previous abdominal surgery")
        ])

    def test_ascii_tree(self, custom_explanation):
        # avoids order problems
        expected_ascii_tree = \
            "  *\n" \
            "  |__gabriel has been sentenced to prison\n"\
            "  |  |__gabriel has driven drunk\n"\
            "  |  |  |__gabriel has driven a car\n" \
            "  |  |  |__gabriel was drunk\n"
        expected_ascii_tree2 = \
            "  *\n" \
            "  |__gabriel has been sentenced to prison\n" \
            "  |  |__gabriel has driven drunk\n" \
            "  |  |  |__gabriel was drunk\n" \
            "  |  |  |__gabriel has driven a car\n"
        result_expl = custom_explanation.ascii_tree()
        print(result_expl)
        assert result_expl == expected_ascii_tree or result_expl == expected_ascii_tree2

    def test_ascii_tree_plain(self, custom_plain_explanation):
        expected_ascii_tree = \
            "  *\n" \
            "  |__afp > 30\n"\
            "  |__hcc true\n"\
            "  |__previous abdominal surgery\n"
        result_expl = custom_plain_explanation.ascii_tree()
        print(result_expl)
        assert result_expl == expected_ascii_tree

    def test_is_equal(self, custom_explanation):
        aux_explanation = ExplanationRoot([
            ExplanationNode(
                Label("gabriel has been sentenced to prison"),
                [
                    ExplanationNode(
                        Label("gabriel has driven drunk"),
                        [
                            ExplanationNode(Label("gabriel has driven a car")),
                            ExplanationNode(Label("gabriel was drunk"))
                        ])
                ]
            )
        ])
        assert aux_explanation.is_equal(custom_explanation)