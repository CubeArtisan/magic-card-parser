const https = require('https');
const fs = require('fs');

console.log("Fetching /bulk-data to find the file")
https.get('https://api.scryfall.com/bulk-data', (res) => {
    let body = '';
    res.on('data', data => body += data);
    res.on('end', () => {
        let oracleUri = JSON.parse(body).data.find(r => r.type == 'oracle_cards').download_uri;

        console.log("Fetching oracle_cards.json from " + oracleUri);

        https.get(oracleUri, (res) => {
            let body = '';
            res.on('data', data => body += data);
            res.on('end', () => {
                console.log("Saving");
                fs.writeFileSync('oracle_cards.json', body);
            });

        })
    })
});