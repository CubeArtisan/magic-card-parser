import nearley from 'nearley';

import magicCardGrammar from './generated/magicCardGrammar.js';

const { Parser, Grammar } = nearley;

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

export const parseCard = (card) => {
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

export default { parseCard };