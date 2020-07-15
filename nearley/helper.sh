mkdir -p src/generated;
nearleyc nearley/magicCard.ne -o src/generated/magicCardGrammar.js;
{
    tail -n +4 src/generated/magicCardGrammar.js |  awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }' | tail -n +7 | awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }';
    echo "; export default grammar;"
} | cat - > src/generated/magicCardGrammar.js.tmp && mv src/generated/magicCardGrammar.js.tmp src/generated/magicCardGrammar.js
