const fs = require('fs');
const graphviz = require('graphviz');

const { cardToGraphViz } = require('../src/magicCardParser');

if (!fs.existsSync('./oracle_cards.json')) {
    console.error("oracle_cards.json does not exist, run 'npm run fetch' to download it");
    return;
}

(async () => {
    const cards = JSON.parse(fs.readFileSync('./oracle_cards.json'));
    let script = null;
    while (script === null) {
        const card = cards[Math.floor(Math.random() * cards.length)];
        script = cardToGraphViz(card);
    }
    try {
        const graph = await new Promise((resolve, reject) => graphviz.parse(script, resolve, (code, out, err) => reject([code, out, err])));
        graph.output('svg', 'cardVisualization.svg');
    } catch(err) {
        console.error(err);
    }
})()
