const graphviz = require('graphviz');

const carddb = require('../extern/CubeCobra/serverjs/cards');

const { cardToGraphViz } = require('../src/magicCardParser');

carddb.initializeCardDb('extern/CubeCobra/private', true).then(async () => {
    const cards = carddb.allCards();
    let script = null;
    while (script === null) {
        const card = cards[Math.floor(Math.random() * cards.length)];
        script = cardToGraphViz(card);
    }
    console.log(script);
    try {
        const graph = await new Promise((resolve, reject) => graphviz.parse(script, resolve, (code, out, err) => reject([code, out, err])));
        graph.output('svg', 'cardVisualization.svg');
    } catch(err) {
        console.error(err);
    }
})
