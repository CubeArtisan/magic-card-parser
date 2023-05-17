const os = require('os');
const { isMainThread, parentPort, Worker, workerData } = require('worker_threads');

const { parseCard, parseTypeLine } = require('../src/magicCardParser');

const carddb = require('../extern/CubeCobra/serverjs/cards');

const runService = (data) => {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./scripts/assessCardParser.js', { workerData: data });
        worker.on('message', resolve);
        worker.on('error', reject);
        worker.on('exit', (code) => {
            if (code !== 0) reject(new Error(`Worker stopped with exit code ${code}`));
        });
    });
};

if (isMainThread) {
    const cpuCount = os.cpus().length;

    carddb.initializeCardDb('extern/CubeCobra/private', true).then(async () => {
        const successes = [];
        const ambiguous = [];
        const failures = [];
        const cards = carddb.allCards();
        const oracleIds = [];
        const validCards = cards.filter(({ isToken, oracle_id, border_color: borderColor, type, set }) => {
            const typeLineLower = type && type.toLowerCase();
            if (
                !isToken &&
                !oracleIds.includes(oracle_id) &&
                // borderColor !== 'silver' &&
                typeLineLower &&
                // !typeLineLower.includes('vanguard') &&
                // !typeLineLower.includes('conspiracy') &&
                // !typeLineLower.includes('hero') &&
                // !typeLineLower.includes('plane ') &&
                // !typeLineLower.includes('contraption ') &&
                // !typeLineLower.includes('emblem') &&
                !typeLineLower.includes('token') &&
                typeLineLower !== 'card' // &&
                // set !== 'cmb1'
            ) {
                oracleIds.push(oracle_id);
                return true;
            }
            return false;
        });
        const threads = [];
        for (let i = 0; i < cpuCount; i++) {
            threads.push(
                runService(
                    validCards.slice(
                        Math.floor((i * validCards.length) / cpuCount),
                        Math.floor(((i + 1) * validCards.length) / cpuCount),
                    ),
                ),
            );
        }
        const results = (await Promise.all(threads)).map((s) => JSON.parse(s)).flat();
        for (const {
            result,
            error,
            oracleText,
            card: { parsed_cost: parsedCost, power, toughness, loyalty, name_lower, type },
        } of results) {
            const typeLineLower = type.toLowerCase();
            const typeLine = parseTypeLine(typeLineLower).result || typeLineLower;
            const cardDetails = { parsedCost, typeLine };
            if (power || power === 0) {
                cardDetails.power = power;
            }
            if (toughness || toughness === 0) {
                cardDetails.toughness = toughness;
            }
            if (loyalty || loyalty === 0) {
                cardDetails.loyalty = loyalty;
            }
            if (!error) {
                successes.push([name_lower, {
                    ...cardDetails,
                    parsed: result[0],
                }]);
            } else if (result) {
                ambiguous.push([name_lower, {
                    ...cardDetails,
                    parsed: result[0],
                    otherParses: result.slice(1),
                }]);
            } else {
                failures.push([name_lower, {
                    ...cardDetails,
                    oracleText,
                }]);
            }
        }
        // console.info('successes', successes.length);
        console.debug(JSON.stringify(Object.fromEntries(successes.concat(ambiguous, failures))));
        // console.info('ambiguous', ambiguous.length);
        for (let i = 0; i < 1; i++) {
            // console.info(JSON.stringify(ambiguous[Math.floor(Math.random() * ambiguous.length)], null, 2));
        }
        // console.info('failures', failures.length);
        for (let i = 0; i < 8; i++) {
            // console.info(JSON.stringify(failures[Math.floor(Math.random() * failures.length)]));
        }
        // console.debug(failures.join('\n,'));
        // console.info(
        //     'parse rate',
        //     successes.length + ambiguous.length,
        //     '/',
        //     successes.length + ambiguous.length + failures.length,
        // );
    });
    carddb.unloadCardDb();
} else {
    const result = workerData.map(parseCard);
    parentPort.postMessage(JSON.stringify(result));
}
