import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export function form_init(root) {
    ReactDOM.render(<MemoryGameForm />, root);
}

class MemoryGameForm extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        return (<div>
            <p><b>Enter game name</b></p>
            <p><input id="gameName" type="text" /></p>
        </div>)
    }
}

export default function run_game(root, channel) {
    ReactDOM.render(<MemoryGame channel={channel} />, root);
}

class MemoryGame extends React.Component {
    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.state = { cards: {}, numClicks: 0, selectedCard: [], ignoreClick: false }
        this.channel.join()
            .receive("ok", this.gotView.bind(this)) // Copied from Nat Tuck Repo
            .receive("error", resp => { console.log("Unable to join", resp); });

    }
    // Copied from Nat Tuck Repo
    gotView(view) {
        console.log("New view", view);
        this.setState(view.game);
    }
    // Copied from Nat Tuck Repo
    sendClick(cardId) {
        if (!this.state.ignoreClick) {
            this.channel.push("click", { clickedIndex: cardId })
                .receive("ok", this.gotView.bind(this));
        }
    }

    sendResetReq() {
        this.channel.push("reset", { reset: true })
            .receive("ok", this.gotView.bind(this));
    }

    componentDidUpdate(pp, ps) {
        if (this.state.ignoreClick) {
            setTimeout(() => {
                this.channel.push("unpause", { unpause: true })
                    .receive("ok", this.gotView.bind(this));
            }, 1000);
        }
    }

    render() {
        let sendClick = this.sendClick.bind(this);
        let cardList = _.map(this.state.cards, (card, index) => {
            return <Card key={index} {...card} onclick={sendClick} />
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
                        <Button onClick={() => this.sendResetReq()}>Reset</Button>
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