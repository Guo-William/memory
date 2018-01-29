import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_game(root) {
    ReactDOM.render(<MemoryGame />, root);
}

const letters = ["A", "B", "C", "D", "E", "F", "G", "H",
    "A", "B", "C", "D", "E", "F", "G", "H"];

function getRandomCards() {
    const shuffledLetters = _.shuffle(letters);
    const arrayCards = _.map(shuffledLetters, (letter, index) => ({
        id: index,
        letter,
        reveal: false,
        matched: false,
    }));
    return _.object([...letters.keys()], arrayCards);
}

function makeNewGameState() {
    return {
        cards: getRandomCards(),
        numClicks: 0,
        selectedCard: [],
        ignoreClick: false,
    }
}
class MemoryGame extends React.Component {
    constructor(props) {
        super(props);
        this.state = makeNewGameState();
    }
    toggleReveal(cardId) {
        if (this.state.ignoreClick || this.state.cards[cardId].matched || this.state.cards[cardId].reveal) {
            return;
        }
        let newNumClicks = this.state.numClicks;
        let currentCard = this.state.cards[cardId];

        if (!currentCard.matched && !currentCard.reveal) {
            newNumClicks = newNumClicks + 1
        }

        let newSelectedCard = Object.assign({}, this.state.selectedCard);

        let newCards = Object.assign({}, this.state.cards);

        if (this.state.selectedCard.length) {
            this.setState({ ignoreClick: true });
            if (this.state.cards[this.state.selectedCard[0]].letter === currentCard.letter) {
                newCards[cardId].matched = true
                newCards[this.state.selectedCard[0]].matched = true
                this.setState({
                    cards: newCards
                });

            }
            setTimeout(() => {
                newCards[cardId].reveal = false
                newCards[newSelectedCard[0]].reveal = false
                this.setState({
                    cards: newCards,
                    ignoreClick: false,
                    selectedCard: []
                })
            }, 1000);
        } else {
            newSelectedCard = [cardId]
        }
        newCards[cardId].reveal = true
        newCards[newSelectedCard[0]].reveal = true
        this.setState({
            numClicks: newNumClicks,
            cards: newCards,
            selectedCard: newSelectedCard
        });
    }

    render() {
        let toggleReveal = this.toggleReveal.bind(this);
        let cardList = _.map(this.state.cards, (card, index) => {
            return <Card key={index} {...card} onclick={toggleReveal} />
        });
        return (
            <div className="row">
                <div className="row">
                    {cardList}
                </div>
                <div className="col-12">
                    <h2 className="text-center">clicks: {this.state.numClicks}</h2>
                </div>
                <div className="col-12 text-center">
                    <Button onClick={() => this.setState(makeNewGameState())}>Reset</Button>
                </div>
            </div>
        );
    }
}

function Card(props) {
    const { reveal, matched, letter, onclick, id } = props;
    const defaultClassNames = "col-3 card "
    const extraClassName = matched ? "bg-success" : "";
    const newClassNames = defaultClassNames.concat(extraClassName);
    return (
        <div className={newClassNames} onClick={() => onclick(id)}>
            {reveal || matched ? letter : ""}
        </div>
    );
}