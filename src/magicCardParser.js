const { Parser, Grammar } = require('nearley');

const magicCardGrammar = require('./generated/magicCardGrammar');

const makeUnique = (lst) => {
    const seen = [];
    const result = [];
    for (const elem of lst) {
        const stringified = JSON.stringify(elem);
        if (!seen.includes(stringified)) {
            result.push(elem);
            seen.push(stringified);
        }
    }
    return result;
};

const compiledGrammar = Grammar.fromCompiled(magicCardGrammar);

const parseCard = (card) => {
    const { name, oracle_text } = card;
    const magicCardParser = new Parser(compiledGrammar);
    const oracleText = oracle_text.split(name).join('~').toLowerCase();
    try {
        magicCardParser.feed(oracleText);
    } catch (error) {
        return { parsed: null, error, oracleText, card };
    }

    const { results } = magicCardParser;
    const result = makeUnique(results);
    if (result.length === 0) {
        return { result: null, error: 'Incomplete parse', oracleText, card };
    }
    if (result.length > 1) {
        return { result, error: 'Ambiguous parse', oracleText, card };
    }
    return { result, error: null, oracleText, card };
};

const cardToGraphViz = (card) => {
    const { result } = parseCard(card);
    if (!result) return null;

    function recurse(obj, myId = 1) {
        const nodes = [];
        const edges = [];
        let nextId = myId + 1;
        if (Array.isArray(obj)) {
            nodes.push({ id: myId, label: ' ' });
            obj.forEach((elem, index) => {
                edges.push({ from: myId, to: nextId, label: index.toString() });
                let newNodes;
                let newEdges;
                [newNodes, newEdges, nextId] = recurse(elem, nextId);
                nodes.push(...newNodes);
                edges.push(...newEdges);
            });
        } else if (obj === null) {
            nodes.push({ id: myId, label: 'null'});
        } else if (obj.constructor === Object) {
            nodes.push({ id: myId, label: ' ' });
            for (const [key, value] of Object.entries(obj)) {
                edges.push({ from: myId, to: nextId, label: key })
                let newNodes;
                let newEdges;
                [newNodes, newEdges, nextId] = recurse(value, nextId);
                nodes.push(...newNodes);
                edges.push(...newEdges);
            }
        } else {
            nodes.push({ id: myId, label: obj.toString() });
        }
        return [nodes, edges, nextId];
    }
    console.log(result);
    const [nodes, edges] = recurse(result[0][0]);

    const nodesStr = nodes.map(({ id, label }) => `${id} [label="${label}"];`).join('\n  ');
    const edgesStr = edges.map(({ from, to, label}) => `${from} -> ${to} [label="${label}"];`).join('\n  ');
    const lines = [
        'digraph g {',
        '  graph [rankdir = "LR", nodesep=0.1, ranksep=0.3];' +
        '  node [fontsize = "16", shape="record", height=0.1, color=lightblue2];',
        '  edge [fontsize = "14"];',
        `  ${nodesStr}`,
        `  ${edgesStr}`,
        '}',
    ];

    return lines.join('\n');
}

module.exports = { cardToGraphViz, parseCard };
