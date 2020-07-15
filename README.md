# Magic Card Parser
This is a project to implement a parser that will support parsing most Magic
the Gathering card texts. The current goal is to parse 80% of cards
successfully. To use simply run `npm i magic-card-parser` then you can include
it in your project with `import { parseCard } from 'magic-card-parser'`.
`parseCard` takes a single argument, `card`, that must include the properties
`name` and `oracle_text`. It will automatically replace the cards name with `~`
in the oracle text and convert to lowercase before parsing. The return value is
an object like the following:
```json
{
  "error": null,
  "oracleText": "{t}: create a 1/1 white human creature token.\nfateful hour — as long as you have 5 or less life, other creatures you control get +2/+2.",
  "result": [
    [
      {
        "costs": "tap",
        "activatedAbility": {
          "create": {
            "amount": 1,
            "type": { "and": ["human", "creature"] },
            "size": { "power": 1, "toughness": 1 },
            "color": "w"
          }
        }
      },
      {
        "asLongAs": {
          "actor": "you",
          "does": {
            "comparison": { "lte": 5 },
            "value": "life"
          }
        },
        "effect": {
          "what": {
            "type": "creature",
            "prefixes": ["other"],
            "suffix": {
              "actor": "you",
              "does": "control"
            }
          },
          "does": {
            "powerToughnessMod": {
              "powerMod": 2,
              "toughnessMod": 2
            }
          }
        }
      }
    ]
  ],
  "card": {
    "name": "Thraben Doomsayer",
    "oracle_text": "{T}: create a 1/1 white Human creature token.\nFateful hour — as long as you have 5 or less life, other creatures you control get +2/+2."
  }
}
```
Most notably `result` is an array of possible parses. If there is more than one
possible parse, meaning it parses to a different json value, than it will
report an error of `"Ambiguous parse"`. If the parse is incomplete, meaning it
expected more input than it got, then it will return a `null` result with the
error `"Incomplete parse"`. Finally, if the input was invalid, meaning there is
no possible parse tree for it, you will get a `null` result and an `Error`
object describing where the parser failed.

We do not guarantee that all the parses are correct, it is just too much work
to manually review all of them at this time. We do check many of the parses
and fix any errors we discover from those, so we have high confidence that the
vast majority of the parses are correct.

## Contributor Guide
We greatly appreciate any contributions. You can check the [issue
tracker](https://github.com/ruler501/magic-card-parser/issues) for active bugs
and TODO items. You can also run `npm run assess` to get a list of cards that
are failing to parse and try getting those to parse, before running this you 
need to update submodules, setup the CubeCobra `.env` file according to their
README and run `npm i && npm setup` in the `extern/CubeCobra` folder. It is
also appreciated if you improve the JSON output to make it more machine-readable,
so our users can better utilize it. When making commits that change the number
of cards "successfully," correctly or ambiguously, parsed please include
`Parses <amount>/<cardCount>.` in your commit message. If you change how the
example would parse please update the README with the new version as well.