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

  def incrementNumClick(game, cardId) do
    cards = game.cards
    currentCard = cards[cardId]
    numClicks = game.numClicks

    if !currentCard.matched && !currentCard.reveal do
      Map.put(game, :numClicks, numClicks + 1)
    else
      Map.put(game, :numClicks, numClicks)
    end
  end

  def matchCards(game, cardId) do
    selectedCard = game.selectedCard
    cards = game.cards

    if length(selectedCard) == 1 do
      newCard = cards[cardId]
      oldCard = cards[Enum.at(selectedCard, 0)]

      if oldCard.letter == newCard.letter do
        newCards =
          cards
          |> Map.put(cardId, Map.put(newCard, :matched, true))
          |> Map.put(Enum.at(selectedCard, 0), Map.put(oldCard, :matched, true))

        game
        |> Map.put(:cards, newCards)
        |> Map.put(:ignoreClick, true)
        |> Map.put(:selectedCard, selectedCard ++ [cardId])
      else
        game
        |> Map.put(:ignoreClick, true)
        |> Map.put(:selectedCard, selectedCard ++ [cardId])
      end
    else
      Map.put(game, :selectedCard, [cardId])
    end
  end

  def revealCard(game, cardId) do
    cards = game.cards
    currentCard = cards[cardId]
    newCards = Map.put(cards, cardId, Map.put(currentCard, :reveal, true))
    Map.put(game, :cards, newCards)
  end

  def handleClick(game, cardId) do
    ignoreClick = game.ignoreClick
    cards = game.cards
    currentCard = cards[cardId]
    selectedCard = game.selectedCard
    numClicks = game.numClicks

    newState = %{
      cards: cards,
      numClicks: numClicks,
      selectedCard: selectedCard,
      ignoreClick: ignoreClick
    }

    ignoreCurrentClick = ignoreClick || currentCard.matched || currentCard.reveal

    unless ignoreCurrentClick do
      newState
      |> incrementNumClick(cardId)
      |> matchCards(cardId)
      |> revealCard(cardId)
    else
      newState
    end
  end

  def unpause(game) do
    cards = game.cards
    selectedCards = game.selectedCard

    firstCardNum = Enum.at(selectedCards, 0)
    secondCardNum = Enum.at(selectedCards, 1)

    firstCard = cards[firstCardNum]
    secondCard = cards[secondCardNum]

    newFirstCard = Map.put(firstCard, :reveal, false)
    newSecondCard = Map.put(secondCard, :reveal, false)

    newCards =
      cards
      |> Map.put(firstCardNum, newFirstCard)
      |> Map.put(secondCardNum, newSecondCard)

    game
    |> Map.put(:ignoreClick, false)
    |> Map.put(:cards, newCards)
    |> Map.put(:selectedCard, [])
  end
end
