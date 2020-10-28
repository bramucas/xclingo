from causes import Label


class TestLabel:

    def test_replace_values(self):
        label = Label(
            "The term X was coined by X in X.",
            values=["Artificial Intelligence", "John McCarthy", "1956"],
            placeholder="X"
        )
        expected_text = "The term Artificial Intelligence was coined by John McCarthy in 1956."
        assert label.replace_values() == expected_text
        assert str(label) == expected_text
