defmodule Memory.Game do
  # Gives back a MAP with keys of index inside with a card obj
  def new() do
    letters = ["A", "B", "C", "D", "E", "F", "G", "H"]

    shuffledLetter =
      letters
      |> Enum.concat(letters)
      |> Enum.shuffle()
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn letterT, acc ->
        Map.put(acc, elem(letterT, 1), %{
          id: elem(letterT, 1),
          letter: elem(letterT, 0),
          reveal: false,
          matched: false
        })
      end)

    %{
      cards: shuffledLetter,
      numClicks: 0,
      selectedCard: [],
      ignoreClick: false
    }
  end
end
