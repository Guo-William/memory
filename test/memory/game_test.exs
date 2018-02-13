defmodule GameTest do
  use ExUnit.Case
  doctest Memory.Game
  alias Memory.Game

  test "new" do
    assert length(Map.keys(Game.new())) == 4
    assert length(Map.keys(Game.new().cards)) == 16
  end

  test "incrementNumClick" do
    inPut = %{
      cards: %{
        1 => %{id: 1, reveal: false, matched: false},
        2 => %{id: 2, reveal: true, matched: false},
        3 => %{id: 3, reveal: false, matched: true},
        4 => %{id: 4}
      },
      numClicks: 3,
      selectedCard: [1],
      ignoreClick: false
    }

    assert Game.incrementNumClick(inPut, 1).numClicks == 4
    assert Game.incrementNumClick(inPut, 2).numClicks == 3
    assert Game.incrementNumClick(inPut, 3).numClicks == 3
  end

  test "matchCards" do
    inPut = %{
      cards: %{
        1 => %{id: 1, reveal: false, matched: false},
        2 => %{id: 2, reveal: false, matched: false},
        3 => %{id: 3, reveal: false, matched: false},
        4 => %{id: 4, reveal: false, matched: false}
      },
      numClicks: 2,
      selectedCard: [],
      ignoreClick: false
    }

    assert Game.matchCards(inPut, 1).selectedCard == [1]

    oneFlipped = %{
      cards: %{
        1 => %{id: 1, letter: "A", reveal: true, matched: false},
        2 => %{id: 2, letter: "A", reveal: false, matched: false},
        3 => %{id: 3, letter: "B", reveal: false, matched: false}
      },
      selectedCard: [1],
      ignoreClick: false
    }

    oneFlippedOutCome = %{
      cards: %{
        1 => %{id: 1, letter: "A", reveal: true, matched: true},
        2 => %{id: 2, letter: "A", reveal: false, matched: true},
        3 => %{id: 3, letter: "B", reveal: false, matched: false}
      },
      selectedCard: [1, 2],
      ignoreClick: true
    }

    assert Game.matchCards(oneFlipped, 2) == oneFlippedOutCome

    oneFlippedOutComeNoMatch = %{
      cards: %{
        1 => %{id: 1, letter: "A", reveal: true, matched: false},
        2 => %{id: 2, letter: "A", reveal: false, matched: false},
        3 => %{id: 3, letter: "B", reveal: false, matched: false}
      },
      selectedCard: [1, 3],
      ignoreClick: true
    }

    assert Game.matchCards(oneFlipped, 3) == oneFlippedOutComeNoMatch
  end

  test "revealCard" do
    inPut = %{
      cards: %{
        1 => %{id: 1, reveal: false, matched: false},
        2 => %{id: 2, reveal: false, matched: false},
        3 => %{id: 3, reveal: false, matched: false},
        4 => %{id: 4, reveal: false, matched: false}
      },
      numClicks: 2,
      selectedCard: [],
      ignoreClick: false
    }

    outPut = %{
      cards: %{
        1 => %{id: 1, reveal: true, matched: false},
        2 => %{id: 2, reveal: false, matched: false},
        3 => %{id: 3, reveal: false, matched: false},
        4 => %{id: 4, reveal: false, matched: false}
      },
      numClicks: 2,
      selectedCard: [],
      ignoreClick: false
    }

    assert Game.revealCard(inPut, 1) == outPut
  end

  test "unpause" do
    inPut = %{
      cards: %{
        1 => %{id: 1, reveal: true, matched: true},
        2 => %{id: 2, reveal: true, matched: false}
      },
      selectedCard: [1, 2],
      ignoreClick: true
    }

    output = %{
      cards: %{
        1 => %{id: 1, reveal: false, matched: true},
        2 => %{id: 2, reveal: false, matched: false}
      },
      selectedCard: [],
      ignoreClick: false
    }

    assert Game.unpause(inPut) == output
  end

  test "handleClick ignoreClick" do
    inputIgnoreClickTrue = %{
      cards: %{1 => %{id: 1}, 2 => %{id: 2}, 3 => %{id: 3}, 4 => %{id: 4}},
      numClicks: 3,
      selectedCard: [3, 2],
      ignoreClick: true
    }

    inputRevealed = %{
      cards: %{
        1 => %{id: 1, reveal: true, matched: false},
        2 => %{id: 2},
        3 => %{id: 3},
        4 => %{id: 4}
      },
      numClicks: 3,
      selectedCard: [1],
      ignoreClick: false
    }

    inputMatched = %{
      cards: %{
        1 => %{id: 1, reveal: true, matched: false},
        2 => %{id: 2},
        3 => %{id: 3},
        4 => %{id: 4}
      },
      numClicks: 3,
      selectedCard: [1],
      ignoreClick: false
    }

    assert Game.handleClick(inputIgnoreClickTrue, 1) == inputIgnoreClickTrue
    assert Game.handleClick(inputRevealed, 1) == inputRevealed
    assert Game.handleClick(inputMatched, 1) == inputMatched
  end
end
