mkdir -p src/generated;
nearleyc nearley/magicCard.ne -o src/generated/magicCardGrammar.js;
nearleyc nearley/typeLine.ne -o src/generated/typeLineGrammar.js;
