import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_game(root) {
    ReactDOM.render(<MemoryGame />, root);
}

const letters = ["A", "B", "C", "D", "E", "F", "G", "H"];

function getRandomCards() {
    const shuffledLetters = _.shuffle(letters.concat(letters));
    const arrayCards = _.map(shuffledLetters, (letter, index) => ({
        id: index,
        letter,
        reveal: false,
        matched: false,
    }));
    return _.object([...shuffledLetters.keys()], arrayCards);
}

function makeNewGameState() {
    return {
        cards: getRandomCards(),
        numClicks: 0,
        selectedCard: [],
        ignoreClick: false,
    };
}

class MemoryGame extends React.Component {
    constructor(props) {
        super(props);
        this.state = makeNewGameState();
    }

    toggleReveal(cardId) {
        const ignoreClick = this.state.ignoreClick;
        const cards = this.state.cards;
        const currentCard = cards[cardId];
        const selectedCard = this.state.selectedCard;

        if (ignoreClick || currentCard.matched || currentCard.reveal) {
            return;
        }
        let newNumClicks = this.state.numClicks;

        if (!currentCard.matched && !currentCard.reveal) {
            newNumClicks = newNumClicks + 1;
        }

        let newSelectedCard = Object.assign({}, selectedCard);
        let newCards = Object.assign({}, cards);

        if (selectedCard.length) {
            this.setState({ ignoreClick: true });

            if (cards[selectedCard[0]].letter === currentCard.letter) {
                newCards[cardId].matched = true;
                newCards[selectedCard[0]].matched = true;
                this.setState({
                    cards: newCards
                });
            }
            setTimeout(() => {
                newCards[cardId].reveal = false;
                newCards[newSelectedCard[0]].reveal = false;
                this.setState({
                    cards: newCards,
                    ignoreClick: false,
                    selectedCard: []
                })
            }, 1000);
        } else {
            newSelectedCard = [cardId];
        }
        newCards[cardId].reveal = true;
        newCards[newSelectedCard[0]].reveal = true;
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
        let displayDivs = []
        for (let i = 0; i < 4; i++) {
            const y = i * 4;
            displayDivs.push(
                <div key={i} className="row">
                    {cardList[y + 0]}
                    {cardList[y + 1]}
                    {cardList[y + 2]}
                    {cardList[y + 3]}
                </div>
            );
        }
        return (
            <div>
                <div className="row">
                    <div className="col-4" />
                    <div className="col-4">
                        {displayDivs}
                    </div>
                    <div className="col-4" />
                </div>
                <div className="row">
                    <h2 className="col-12">clicks: {this.state.numClicks}</h2>
                </div>
                <div className="row">
                    <div className="col-12 text-center">
                        <Button onClick={() => this.setState(makeNewGameState())}>Reset</Button>
                    </div>
                </div>
            </div>
        );
    }
}

function Card(props) {
    const { reveal, matched, letter, onclick, id } = props;
    const defaultClassNames = "col-3 tile ";
    const extraClassName = matched ? "bg-success" : "";
    const newClassNames = defaultClassNames.concat(extraClassName);

    return (
        <div className={newClassNames} onClick={() => onclick(id)}>
            {reveal || matched ? letter : ""}
        </div>
    );
}