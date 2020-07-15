# Based on https://github.com/Soothsilver/mtg-grammar/blob/master/mtg.g4
@include "./enums.ne"
start -> card
_ -> " ":?
__ -> " "
card -> "\n":* ability:? ("\n":+ ability):* "\n":? {% ([, a, as]) => a ? [a, ...as.map(([, a2]) => a2).filter((a) => a)] : [...as.map(([, a2]) => a2).filter((a) => a)] %}
ability -> (abilityWordAbility
  | activatedAbility
  | additionalCostToCastSpell
  | keywords
  | modalAbility
  | staticOrSpell
  | triggeredAbility
  | reminderText {% () => [null] %}
) ".":? (__ reminderText):? {% ([[a]]) => a %}

connected[rule] -> $rule ("," __ $rule):* ",":? __ (("then" | "and") {% () => "and" %} | "or" {% () => "xor" %} | "and/or" {% () => "or" %}) __ $rule {% ([[o], os, , , connector, , [o2]]) => ({ [connector]: [o, ...os.map(([, , [o3]]) => o3), o2] }) %}

reminderText -> "(" [^)]:+ ")"

modalAbility -> "choose" __ modalQuantifier __ DASHDASH ((__ | "\n") modalOption):+ {% ([, , quantifier, , , options]) => ({ quantifier, options: options.map(([, o]) => o) }) %}
modalOption -> ("*" | "•") __ effect {% ([, , e]) => e %}
modalQuantifier -> "one or both" {% () => [1, 2] %}
  | "one" {% () => [1] %}

keywords -> keyword (("," | ";") __ keyword):* {% ([k1, ks]) => [k1].concat(ks.map(([, , k]) => k)) %}
# Keep this in the same order as 702 to make verification easy.
keyword -> ("deathtouch"i
  | "defender"i
  | "double strike"i
  | enchantKeyword
  | equipKeyword
  | "first strike"i
  | "flash"i
  | "flying"i
  | "haste"i
  | "hexproof"i
  | "indestructible"i
  | "intimidate"i
  | landwalkKeyword
  | "lifelink"i
  | protectionKeyword
  | "reach"i
  | "shroud"i
  | "trample"i
  | "vigilance"i
  | bandingKeyword
  | rampageKeyword
  | cumulativeUpkeepKeyword
  | "flanking"i
  | "phasing"i
  | buybackKeyword
  | "shadow"i
  | cyclingKeyword
  | echoKeyword
  | "horsemanship"
  | fadingKeyword
  | kickerKeyword
  | flashbackKeyword
  | madnessKeyword
  | "fear"i
  | morphKeyword
  | amplifyKeyword
  | "provoke"i
  | "storm"i
  | affinityKeyword
  | entwineKeyword
  | modularKeyword
  | "sunburst"i
  | bushidoKeyword
  | soulshiftKeyword
  | spliceKeyword
  | offeringKeyword
  | ninjutsuKeyword
  | "epic"i
  | "convoke"i
  | dredgeKeyword
  | transmuteKeyword
  | bloodthirstKeyword
  | "haunt"i
  | replicateKeyword
  | forecastKeyword
  | graftKeyword
  | recoverKeyword
  | rippleKeyword
  | "split second"i
  | suspendKeyword
  | vanishingKeyword
  | absordKeyword
  | auraSwapKeyword
  | "delve"i
  | fortifyKeyword
  | frenzyKeyword
  | "gravestorm"i
  | poisonousKeyword
  | transfigureKeyword
  | championKeyword
  | "changeling"i
  | evokeKeyword
  | "hideaway"i
  | prowlKeyword
  | reinforceKeyword
  | "conspire"i
  | "persist"i
  | "wither"i
  | "retrace"i
  | devourKeyword
  | "exalted"i
  | unearthKeyword
  | "cascade"i
  | annihilatorKeyword
  | levelUpKeyword
  | "rebound"i
  | "totem armor"i
  | "infect"i
  | "battle cry"i
  | "living weapon"i
  | "undying"i
  | miracleKeyword
  | "soulbond"i
  | overloadKeyword
  | scavengeKeyword
  | "unleash"i
  | "cipher"i
  | "evolve"i
  | "extort"i
  | "fuse"i
  | bestowKeyword
  | tributeKeyword
  | "dethrone"i
  | "hidden agenda"i
  | outlastKeyword
  | "prowess"i
  | dashKeyword
  | "exploit"i
  | "menace"i
  | renownKeyword
  | awakenKeyword
  | "devoid"i
  | "ingest"i
  | "myriad"i
  | surgeKeyword
  | "skulk"i
  | emergeKeyword
  | escalateKeyword
  | "melee"i
  | crewKeyword
  | fabricateKeyword
  | partnerKeyword
  | "undaunted"i
  | "improvise"i
  | "aftermath"i
  | embalmKeyword
  | eternalizeKeyword
  | afflictKeyword
  | "ascend"i
  | "assist"i
  | "jump-start"i
  | "mentor"i
  | afterlifeKeyword
  | "riot"i
  | spectacleKeyword
  | escapeKeyword
  #  | companionKeyword # TODO: Implement
  | mutateKeyword
  | megamorphKeyword) {% ([[keyword]]) => keyword %}
cyclingKeyword -> "cycling" __ cost {% ([, , cost]) => ({ cycling: cost }) %}
enchantKeyword -> "enchant" __ anyEntity {% ([, , entity]) => ({ enchant: entity }) %}
equipKeyword -> "equip" __ cost {% ([, , cost]) => ({ equip: cost }) %}
cumulativeUpkeepKeyword -> "cumulative upkeep" __ cost {% ([, , cumulativeUpkeep]) => ({ cumulativeUpkeep }) %}
escapeKeyword -> "escape" __ cost {% ([, , escape]) => ({ escape }) %}
spectacleKeyword -> "spectacle" __ cost {% ([, , spectacle]) => ({ spectacle }) %}
afterlifeKeyword -> "afterlife" __ number {% ([, , afterlife]) => ({ afterlife }) %}
afflictKeyword -> "afflict" __ number {% ([, , afflict]) => ({ afflict }) %}
eternalizeKeyword -> "eternalize" __ cost {% ([, , eternalize]) => ({ eternalize }) %}
embalmKeyword -> "embalm" __ cost {% ([, , embalm]) => ({ embalm }) %}
partnerKeyword -> "partner" {% () => "partner" %}
  | "partner with" [^\n(]:+ {% ([, partnerWith]) => ({ partnerWith: partnerWith.join('') }) %}
fabricateKeyword -> "fabricate" __ number {% ([, , fabricate]) => ({ fabricate }) %}
crewKeyword -> "crew" __ number {% ([, , crew]) => ({ crew }) %}
escalateKeyword -> "escalate" __ cost {% ([, , escalate]) => ({ escalate }) %}
emergeKeyword -> "emerge" __ cost {% ([, , emerge]) => ({ emerge }) %}
surgeKeyword -> "surge" __ cost {% ([, , surge]) => ({ surge }) %}
awakenKeyword -> "awaken" __ cost {% ([, , awaken]) => ({ awaken }) %}
renownKeyword -> "renown" __ number {% ([, , renown]) => ({ renown }) %}
dashKeyword -> "dash" __ cost {% ([, , dash]) => ({ dash }) %}
outlastKeyword -> "outlast" __ cost {% ([, , outlast]) => ({ outlast }) %}
tributeKeyword -> "tribute" __ number {% ([, , tribute]) => ({ tribute }) %}
mutateKeyword -> "mutate" __ cost {% ([, , mutate]) => ({ mutate }) %}
bestowKeyword -> "bestow" __ cost {% ([, , bestow]) => ({ bestow }) %}
scavengeKeyword -> "scavenge" __ cost {% ([, , scavenge]) => ({ scavenge }) %}
overloadKeyword -> "overload" __ cost {% ([, , overload]) => ({ overload }) %}
buybackKeyword -> "buyback" __ cost {% ([, , buyback]) => ({ buyback }) %}
rampageKeyword -> "rampage" __ number {% ([, , rampage]) => ({ rampage }) %}
echoKeyword -> "echo" __ cost {% ([, , echo]) => ({ echo }) %}
fadingKeyword -> "fading" __ number {% ([, , fading]) => ({ fading }) %}
kickerKeyword -> "kicker" __ costs {% ([, , kicker]) => ({ kicker }) %}
flashbackKeyword -> "flashback" __ cost {% ([, , flashback]) => ({ flashback }) %}
madnessKeyword -> "madness" __ cost {% ([, , madness]) => ({ madness }) %}
morphKeyword -> "morph" __ cost {% ([, , morph]) => ({ morph }) %}
amplifyKeyword -> "amplify" __ number {% ([, , amplify]) => ({ amplify }) %}
entwineKeyword -> "entwine" __ cost {% ([, , entwine]) => ({ entwine }) %}
modularKeyword -> "modular" __ number {% ([, , module]) => ({ modular }) %}
bushidoKeyword -> "bushido" __ number {% ([, , bushido]) => ({ bushido }) %}
ninjutsuKeyword -> "ninjutsu" __ cost {% ([, , ninjutsu]) => ({ ninjutsu }) %}
dredgeKeyword -> "dredge" __ number {% ([, , dredge]) => ({ dredge }) %}
transmuteKeyword -> "transmute" __ cost {% ([, , transmute]) => ({ transmute }) %}
bloodthirstKeyword -> "bloodthirsty" __ number {% ([, , bloodthirsty]) => ({ bloodthirsty }) %}
replicateKeyword -> "replicate" __ cost {% ([, , replicate]) => ({ replicate }) %}
graftKeyword -> "graft" __ number {% ([, , graft]) => ({ graft }) %}
recoverKeyword -> "recover" __ cost {% ([, , recover]) => ({ recover }) %}
rippleKeyword -> "ripple" __ number {% ([, , ripple]) => ({ ripple }) %}
suspendKeyword -> "suspend" __ number __ DASHDASH __ cost {% ([, , suspend, , , , cost]) => ({ suspend, cost }) %}
vanishingKeyword -> "vanishing" __ number {% ([, , vanishing]) => ({ vanishing }) %}
absordKeyword -> "absorb" __ number {% ([, , absorb]) => ({ absorb }) %}
fortifyKeyword -> "fortify" __ cost {% ([, , fortify]) => ({ fortify }) %}
frenzy -> "frenzy" __ number {% ([, , frenzy]) => ({ frenzy }) %}
poisonousKeyword -> "poisonous" __ number {% ([, , poisonous]) => ({ poisonous }) %}
evokeKeyword -> "evoke" __ cost {% ([, , evoke]) => ({ evoke }) %}
devourKeyword -> "devour" __ number {% ([, , devour]) => ({ devour }) %}
unearthKeyword -> "unearth" __ cost {% ([, , unearth]) => ({ unearth }) %}
annihilatorKeyword -> "annihilator" __ number {% ([, , annihilator]) => ({ annihilator }) %}
levelUpKeyword -> "level up" __ cost {% ([, , levelUp]) => ({ levelUp }) %}
miracleKeyword -> "miracle" __ cost {% ([, , miracle]) => ({ miracle }) %}
megamorphKeyword -> "megamorph" __ cost {% ([, , megamorph]) => ({ megamorph }) %}
affinityKeyword -> "affinity for" __ object {% ([, , affinityFor]) => ({ affinityFor }) %}
partnerKeyword -> "partner" {% () => "partner" %}
  | "partner with" __ [^\n]:+ {% ([, , partnerWith]) => ({ partnerWith: partnerWith.join('') }) %}
offeringKeyword -> object __ "offering" {% ([offering]) => ({ offering }) %}
frenzyKeyword -> "frenzy" __ number {% ([, , frenzy]) => ({ frenzy }) %}
soulshiftKeyword -> "soulshift" __ number {% ([, , soulshift]) => ({ soulshift }) %}
spliceKeyword -> "splice onto" __ object __ cost {% ([, , spliceOnto, , cost]) => ({ spliceOnto, cost }) %}
forecastKeyword -> "forecast" __ DASHDASH __ activatedAbility {% ([, , , , forecast]) => ({ forecast }) %}
championKeyword -> "champion" __ object {% ([, , champion]) => ({ champion }) %}
protectionKeyword -> "protection from" __ anyEntity {% ([, , protectionFrom]) => ({ protectionFrom }) %}
prowlKeyword -> "prowl" __ cost {% ([, , prowl]) => ({ prowl }) %}
reinforceKeyword -> "reinforce" __ number __ DASHDASH __ cost {% ([, , reinforce, , , , cost]) => ({ reinforce, cost }) %}
transfigureKeyword -> "transfigure" __ cost {% ([, , transfigure]) => ({ transfigure }) %}
bandingKeyword -> "banding" {% () => ({ bandsWith: "any" }) %}
  | "bands with" __ object {% () => ({ bandsWith: object }) %}
landwalkKeyword -> anyType "walk" {% ([landwalk]) => ({ landwalk }) %}
  | "nonbasic landwalk" {% () => ({ landwalk: { not: { type: "basic" } } }) %}
  | "snow landwalk" {% () => ({ landwalk: { type: "snow" } }) %}
auraSwapKeyword -> "aura swap" __ cost {% ([, , auraSwap]) => ({ auraSwap }) %}

abilityWordAbility -> abilityWord __ DASHDASH __ ability {% ([aw, , , , a]) => a %}
abilityWord ->  ("adamant"i
  | "addendum"i
  | "battalion"i
  | "bloodrush"i
  | "channel"i
  | "chroma"i
  | "cohort"i
  | "constellation"i
  | "converge"i
  | "council's dilemma"i
  | "delirium"i
  | "domain"i
  | "eminence"i
  | "enrage"i
  | "fateful hour"i
  | "ferocious"i
  | "formidable"i
  | "grandeur"i
  | "hellbent"i
  | "heroic"i
  | "imprint"i
  | "inspired"i
  | "join forces"i
  | "kinship"i
  | "landfall"i
  | "lieutenant"i
  | "metalcraft"i
  | "morbid"i
  | "parley"i
  | "radiance"i
  | "raid"i
  | "rally"i
  | "revolt"i
  | "spell mastery"i
  | "strive"i
  | "sweep"i
  | "temptingoffer"i
  | "threshold"i
  | "undergrowth"i
  | "will of the council") {% ([[aw]]) => aw.toLowerCase() %}

activatedAbility -> costs ":" __ effect (__ activationInstructions):? {% ([costs, , , activatedAbility, i]) => {
  const result = { costs, activatedAbility };
  if (i) result.instructions = i;
  return result;
} %}
activationInstructions -> "activate this ability only " activationInstruction "." {% ([, i]) => ({ only: i }) %}
  | "any player may activate this ability." {% () => "anyPlayer" %}
activationInstruction -> "once each turn" {% () => "onceATurn" %}
  | "any time you could cast a sorcery" {% () => "sorceryOnly" %}
  | "if" __ player __ "control" "s":? __ object {% ([, , actor, , , , , controls]) => ({ actor, controls }) %}
  | "only if" __ condition {% ([, , condition]) => ({ condition }) %}
# TODO: Make into AST
activatedAbilities -> (itsPossessive __):? "activated abilities" {% ([reference]) => reference ? { whose: reference, activatedAbilities: "any" } : { activatedAbilities: "any" } %}
  | "activated abilities of" __ object {% ([, , activatedAbilities]) => ({ whose: activatedAbilities, activatedAbilities: true }) %}
activatedAbilitiesVP -> CAN_T __ "be activated" (__ "unless they're mana abilities."):? {% ([, , , , manaOnly]) => manaOnly ? { cant: "activatedAbilities", unless: "manaAbility" } : { cant: "activatedAbilities" } %}

triggeredAbility -> triggerCondition "," __ interveningIfClause:? effect {% ([trigger, , , ifClause, effect]) => {
  const result = { trigger, effect };
  if (ifClause) result.ifClause = ifClause
  return result;
} %}
triggerCondition -> ("when" | "whenever") __ triggerConditionInner (__ triggerTiming):? {% ([, , inner, timing]) => {
  const result = { when: inner };
  if (timing) result.timing = timing[1];
  return result;
} %}
  | "at the beginning of" __ qualifiedPartOfTurn {% ([, , turnPhase]) => ({ turnPhase }) %}
  | "at end of combat" {% () => ({ turnPhase: "endCombat" }) %}
triggerConditionInner -> singleSentence {% ([s]) => s %}
  | player __ gains __ "life" {% ([actor]) => ({ actor, does: "gainsLife" }) %}
  | object __ "is dealt damage" {% ([what]) => ({ what, does: "dealtDamage" }) %}
  | object __ objectVerbPhrase {% ([what, , does]) => ({ what, does }) %}
interveningIfClause -> "if " condition "," {% ([, c]) => c %}
triggerTiming -> "each turn" {% () => "eachTurn" %}
  | "during each opponent" SAXON __ "turn" {% () => ({ reference: "each", what: { whose: "opponent", what: "turn" } }) %}

additionalCostToCastSpell -> "as an additional cost to cast this spell," __ imperative "." {% ([, , additionalCost]) => ({ additionalCost }) %}

staticOrSpell -> sentenceDot {% ([sd]) => sd %}
effect -> (sentenceDot
  | modalAbility) {% ([[e]]) => e %}

sentenceDot -> sentence (".":? __ additionalSentence):* ".":? {% ([s, ss]) => ss.length > 0 ? [s, ...ss.map(([, , s2]) => s2)] : s %}
additionalSentence -> sentence {% ([s]) => s %}
  | triggeredAbility {% ([t]) => t %}

sentence -> singleSentence {% ([ss]) => ss %}
  | singleSentence "," __ sentence {% ([s1, , , s2]) => ({ and: [s1, s2] }) %}
  | "then" __ sentence {% ([, , s]) => s %}
  | connected[sentence] {% ([c]) => c %}
  | "otherwise," __ sentence {% ([, , otherwise]) => ({ otherwise }) %}
  | sentence __ "rather than" __ sentence {% ([does, , , , ratherThan]) => ({ does, ratherThan }) %}
  | sentence __ "at" __ qualifiedPartOfTurn {% ([does, , , , at]) => ({ does, at }) %}
  | sentence __ "if" __ condition {% ([does, , , , condition]) => ({ does, condition }) %}
singleSentence -> imperative {% ([i]) => i %}
  | singleSentence ", where x is" __ numberDefinition {% ([does, , , X]) => ({ does, X }) %}
  | object __ objectVerbPhrase {% ([what, , does]) => ({ what, does }) %}
  | IT_S __ isWhat {% ([, , is]) => ({ is }) %}
  | player __ playerVerbPhrase {% ([actor, , does]) => ({ actor, does }) %}
  | "if" __ sentence "," __ replacementEffect {% ([, , condition, , , replacementEffect]) => ({ condition, replacementEffect }) %}
  | "if" __ condition "," __ sentence {% ([, , condition, , , effect]) => ({ condition, effect }) %}
  | "if" __ object __ "would" __ (objectVerbPhrase | objectInfinitive) "," __ sentenceInstead {% ([, , what, , , , [does], , , instead]) => ({ what, does, instead }) %}
  | "if" __ player __ "would" __ playerVerbPhrase "," __ sentenceInstead {% ([, , actor, , , , would, , , instead]) => ({ actor, would, instead }) %}
  | asLongAsClause "," __ sentence {% ([asLongAs, , , effect]) => ({ asLongAs, effect }) %}
  | duration "," __ sentence {% ([duration, , , effect]) => ({ duration, effect }) %}
  | "for each" __ object "," __ sentence {% ([, , forEach, , , effect]) => ({ forEach, effect }) %}
  | activatedAbilities __ activatedAbilitiesVP (__ duration):? {% ([abilities, , effect, duration]) => duration ? { ...abilities, ...effect, duration: duration[1] } : { ...abilities, ...effect } %}
  | itsPossessive __ numericalCharacteristic __ ("is" | "are each") __ "equal to" __ numberDefinition {% ([what, , characteristic, , , , , , setTo]) => ({ what, characteristic, setTo }) %}
  | "as" __ sentence "," __ sentence {% ([, , as, , , does]) => ({ as, does }) %}
  | "instead" __ singleSentence {% ([, , instead]) => ({ instead }) %}
  | playersPossessive __ "maximum hand size is" __ ("reduced" | "increased") __ "by" __ numberDefinition {% ([whose, , , , handSize, , , , amount])  => ({ whose, handSize, amount }) %}
sentenceInstead -> sentence __ "instead" {% ([instead]) => ({ instead }) %}
  | "instead" __ sentence {% ([, ,instead]) => ({ instead }) %}

forEachClause -> "for each" __ pureObject {% ([, , forEach]) => ({ forEach }) %}
 | "for each color of mana spent to cast" __ object {% ([, , forEachColorSpent]) => ({ forEachColorSpent }) %}

condition -> sentence {% ([s]) => s %}
  | (YOU_VE | "you") __ action __ duration {% ([, , done, , during]) => ({ done, during }) %}
  | IT_S __ "your turn" {% () => "yourTurn" %}
  | IT_S __ "not" __ playersPossessive __ "turn" {% ([, , notTurnOf]) => ({ notTurnOf }) %}
  | object __ "has" __ countableCount __ (counterKind __):? "counter" "s":? "on it" {% ([object, , , count, , hasCounter]) => ({ object, count, hasCounter }) %}
  | numberDefinition __ "is" __ numericalComparison {% ([number, , , , is]) => ({ number, is }) %}
  | "that mana is spent on" __ object {% ([, , manaSpentOn]) => ({ manaSpentOn }) %}
  | ("is" __):? "paired" __ withClause {% ([, , , pairedWith]) => ({ pairedWith }) %}
  | ("is" __):? "untapped" {% () => "untapped" %}
  | object __ "has the chosen name" {% ([what]) => ({ what, has: { reference: "chosen", what: "name" } }) %}
  | (numericalComparison {% ([condition]) => ({ condition }) %}| manaSymbol {% ([mana]) => ({ mana }) %}) __ "was spent to cast this spell" {% ([c]) => ({ ...c, value: { what: "mana", reference: { does: "spent", reference: "this", what: "spell" } } }) %}
  | object __ "was kicked with its" __ manacost __ "kicker" {% ([what, , , , mana]) => ({ what, kicked: { with: { mana } } }) %}
  | object __ "has" __ englishNumber __ counterKind __ "counter" "s":? " on it" {% ([what, , , , amount, , counterKind]) => ({ what, has: { amount, counterKind } }) %}

action -> "scried" {% () => "scried" %}
  | "surveilled" {% () => "surveilled" %}

entity -> (object 
  | player) {% ([[e]]) => e %}
anyEntity -> object {% ([e]) => e %}
  | pureObject {% ([e]) => e %}
  | player {% ([e]) => e %}
  | purePlayer {% ([e]) => e %}
  | color {% ([color]) => ({ color }) %}
  | "everything" {% () => "everything" %}
player -> "you" {% () => "you" %}
  | connected[player] {% ([c]) => c %}
  | "they" {% () => "they" %}
  | (commonReferencingPrefix __):* purePlayer {% ([references, player]) => references.length > 0 ? { references: references.map(([r]) => r), player } : player %}
  | "your opponent" "s":? {% ([, plural]) => plural ? "opponent" : "opponents" %}
  | "defending player" {% () => "defendingPlayer" %}
  | itsPossessive __ ("controller" {% () => "control" %} | "owner" {% () => "own" %}) "s":? {% ([whose, , does]) => ({ whose, does })  %}
  | "each of" __ player {% ([, , each]) => ({ each }) %}
  | "your team" {% () => "team" %}
purePlayer -> "player" "s":? {% () => "player" %}
  | "opponent" "s":? {% () => "opponents" %}
  | "no one" {% () => "noone" %}
object -> (referencingObjectPrefix __):? objectInner {% ([reference, object]) => reference ? { reference: reference[0], object } : object %}
objectInner -> "it" {% () => "it" %}
  | "them" {% () => "them" %}
  | "they" {% () => "they" %}
  | "rest" {% () => "rest" %}
  | "this emblem" {% () => "emblem" %}
  | object __ THAT_S __ isWhat {% ([object, , , , condition]) => ({ object, condition }) %}
  | connected[object] {% ([c]) => c %}
  | pureObject {% ([po]) => po %}
  | "each of" __ object {% ([, , each]) => ({ each }) %}
  | "the top" __ englishNumber __ "cards of" __ zone {% ([, , topCards, , , , from]) => ({ topCards, from }) %}
  | "the top of" __ zone {% ([, , topOf]) => ({ topOf }) %}
  | "the top card of" __ zone {% ([, , from]) => ({ topCards: 1, from }) %}
  | (counterKind __):? "counter" "s":? __ "on" __ object {% ([kind, , , , , , countersOn]) => kind ? { counterType: kind[0], countersOn } : { countersOn } %}
suffix -> player __ ((DON_T | DOESN_T) __):? ("control" | "own") "s":? {% ([actor, negate, , [does]]) => !negate ? { actor, does: { not: does } } : { actor, does } %}
  | "in" __ zone (__ "and in" __ zone):? {% ([, , zone, zone2]) => zone2 ? { and: [{ in: zone}, {in: zone2[3]}] } : { in: zone } %}
  | "not" __ suffix {% ([, , not]) => ({ not }) %}
  | "revealed this way" {% () => ({ reference: "thisWay", does: "reveal" }) %}
  | "from" __ (zone | object) {% ([, , [from]]) => ({ from }) %}
  | ("that" __):? "you cast" {% () => "youCast" %}
  | "that" __ didAction (__ duration):? {% ([, , didAction, when]) => when ? { didAction, when: when[1] } : { didAction } %}
  | "that targets only" __ object {% ([, , onlyTargets]) => ({ onlyTargets }) %}
  | "that targets" __ anyEntity {% ([, , targets]) => ({ targets }) %}
  | "tapped this way" {% () => "tappedThisWay" %}
  | ("destroyed" {% () => "destroy" %} | "exiled" {% () => "exile" %}) __ (fromZone __):? "this way" {% ([does, , from]) => from ? { from: from[0], reference: "thisWay", does } : { reference: "thisWay", does } %}
  | "of the" __ anyType __ "type of" __ playersPossessive __ "choice" {% ([, , type, , , , actor]) => ({ type, actor, does: "choose" }) %}
  | "on the battlefield" {% () => ({ in: "battlefield" }) %}
  | "of the chosen color" {% () => ({ color: "chosen" }) %}
  | object __ "could target" {% ([couldTarget]) => ({ couldTarget }) %}
  | "able to block" __ object {% ([, , canBlock]) => ({ canBlock }) %}
  | "that convoked" __ object {% ([, , convoked]) => ({ convoked }) %}
  | "from among them" {% () => "amongThem" %}
  | "named" __ CARD_NAME {% ([, , named]) => ({ named }) %}
  | YOU_VE __ "cast before it this turn" {% () => "youveCastBeforeThisTurn" %}
  | "not named" __ CARD_NAME {% ([, , named]) => ({ not: { named } }) %}
  | "attached to" __ object {% ([, , attachedTo]) => ({ attachedTo }) %}
  | "it targets" {% () => ({ what: "it", does: "targets" }) %}
  | "other than" __ object {% ([, , not]) => ({ not }) %}
  | objectAction __ "this way" {% ([does]) => ({ reference: "thisWay", does }) %}
  | "with base power and toughness" __ pt {% ([, , basePowerToughness]) => ({ basePowerToughness }) %}
  | "with total" __ numericalCharacteristic __ numericalComparison {% ([, , characteristic, , value]) => ({ total: { [characteristic]: value } }) %}
  | "dealt damage this way" {% () => ({ reference: "thisWay", does: "dealtDamage" }) %}
objectAction -> "sacrificed" {% () => "sacrifice" %}
  | "returned" {% () => "return" %}
pureObject -> connected[pureObject1] (__ suffix):?{% ([c, suffix]) => suffix ? { object: c, suffix: suffix[1] } : c %}
  | pureObject1 (__ suffix):?{% ([o, suffix]) => suffix ? { object: o, suffix: suffix[1] } : o %}
pureObject1 -> (prefix __):* (anyType __):? pureObjectInner {% ([prefixes, types, object, suffix]) => {
  if (prefixes.length === 0 && !suffix && !types) return object;
  const result = { object };
  if (types) result.types = types[0];
  if (prefixes.length > 0) result.prefixes = prefixes.map(([p]) => p);
  if (suffix) result.suffix = suffix[1];
  return result;
} %}
  | (prefix __):* anyType "s":? (__ suffix):? {% ([prefixes, type, , suffix]) => {
  const result = { type };
  if (prefixes.length > 0) result.prefixes = prefixes.map(([p]) => p);
  if (suffix) result.suffix = suffix[1];
  return result;
} %}
pureObjectInner -> ("copy" | "copies") (__ "of" __ object):? {% ([, copyOf]) => copyOf ? { copyOf } : "copy" %}
  | "card" "s":? {% () => "card" %}
  | "spell" "s":? {% () => "spell" %}
  | "type" "s":? {% () => "type" %}
  | pureObject __ "without" __ keyword {% ([object, , , , without]) => ({ object, without }) %}
  | pureObject __ withClause {% ([object, , condition]) => ({ object, condition }) %}
  | CARD_NAME {% ([c]) => c %}
  | "ability" {% () => "ability" %}
  | "abilities" {% () => "abilities" %}
  | "commander" {% () => "commander" %}
  | "token" {% () => "token" %}
  | "target" "s":? {% () => "target" %}
referencingObjectPrefix -> "the sacrificed" {% () => "sacrificed" %}
  | "any of" {% () => "any" %}
  | "the" {% () => "the" %}
  | "the rest of" {% () => "rest" %}
  | commonReferencingPrefix {% ([p]) => p %}
commonReferencingPrefix -> countableCount (__ "additional"):? (__ commonReferencingPrefixInner):? {% ([count, additional, inner]) => {
    const result = { count } 
    if (additional) result.additional = true;
    if (inner) result.reference = inner[1];
    return result;
  } %}
  | ("another" __):? (countableCount __):? "target" "s":?  {% ([another, count]) => {
    const targetCount = count ? count[0] : 1;
    return another ? { reference: "other", targetCount } : { targetCount }
  } %}
  | commonReferencingPrefixInner {% ([i]) => i %}
commonReferencingPrefixInner -> "each" {% () => "each" %}
  | "the" {% () => "the" %}
  | "any" {% () => "any" %}
  | "this" {% () => "this" %}
  | "attacking" {% () => "attacking" %}
  | "enchanted" {% () => "enchanted" %}
  | "equipped" {% () => "equipped" %}
  | "that" {% () => "that" %}
  | "that player" SAXON {% () => "thatPlayer" %}
  | "these" {% () => "these" %}
  | "those" {% () => "thsoe" %}
  | "another" {% () => "other" %}
  | "the chosen" {% () => "chosen" %}
  | "at least" __ englishNumber {% ([, , atLeast]) => ({ atLeast }) %}
  | "each other" {% () => ({ each: { reference: "other" } }) %}
  | "your" {% () => "your" %}
prefix -> "enchanted" {% () => "enchanted" %}
  | "the" {% () => "the" %}
  | "first" {% () => "first" %}
  | "attached" {% () => "attached" %}
  | "equipped" {% () => "equipped" %}
  | "historic" {% () => "historic" %}
  | "non" ("-" | __):? (anyType {% ([type]) => ({ type }) %} | color {% ([color]) => ({ color }) %}) {% ([, , not]) => ({ not }) %}
  | "exiled" {% () => "exiled" %}
  | "revealed" {% () => "revealed" %}
  | "permanent" SAXON {% () => "permanent's" %}
  | "activated" {% () => ({ abilityType: "activated" }) %}
  | "triggered" {% () => ({ abilityType: "triggered" }) %}
  | "token" {% () => "token" %}
  | "nontoken" {% () => ({ not: "token" }) %}
  | "nonsnow" {% () => ({ not: { type: "snow" } }) %}
  | color {% ([color]) => ({ color }) %}
  | "face-down" {% () => "faceDown" %}
  | "tapped" {% () => "tapped" %}
  | "untapped" {% () => ({ not: "tapped" }) %}
  | pt {% ([size]) => ({ size }) %}
  | "attacking" {% () => "attacking" %}
  | "blocking" {% () => "blocking" %}
  | connected[prefix] {% ([c]) => c %}
  | "other" {% () => "other" %}

didAction -> "dealt damage" {% () => "dealtDamage" %}
  | "was dealt damage" {% () => "damaged" %}

imperative -> "sacrifice" __ object {% ([, , sacrifice]) => ({ sacrifice }) %}
  | connected[imperative] {% ([c]) => c %}
  | "fateseal" __ number {% ([, , fateseal]) => ({ fateseal }) %}
  | "destroy" "s":? __ object {% ([, , , destroy]) => ({ destroy }) %}
  | "detain" __ object {% ([, , detain]) => ({ detain }) %}
  | "discard" "s":? __ object (__ "at random"):? {% ([, , , discard, random]) => random ? { discard, random: true } : { discard } %}
  | "return" "s":? __ object  (__ fromZone):? __ "to" __ zone (__ "tapped"):? (__ "attached to" __ object):? {% ([, , , returns, from, , , , to, tapped, attached]) => {
    result = tapped ? { returns, to, tapped: true } : { returns, to };
    if (attached) result.attached = attached[3];
    if (from) result.from = from[1];
    return result;
  } %}
  | "exile" "s":? __ object (__ "face down"):? (__ untilClause):? {% ([, , , exile, faceDown, until]) => {
    const result = { exile };
    if (faceDown) result.faceDown = true;
    if (until) result.until = until[1];
    return result;
  } %}
  | "create" "s":? __ tokenDescription {% ([, , , create]) => ({ create }) %}
  | ("copy" | "copies") __ object (__ countableCount):? {% ([, , copy, times]) => times ? { copy, times: times[1] } : { copy } %}
  | "lose" "s":? __ numberDefinition __ "life" {% ([, , , loseLife]) => ({ loseLife }) %}
  | "mill" "s"i:? __ numberDefinition __ "card" "s":? {% ([, , , mill]) => ({ mill }) %}
  | gains (__ numberDefinition):? __ "life" {% ([, gainLife]) => gainLife ? { gainLife: gainLife[1] } : "gainLife" %}
  | gains __ "control of" __ object (__ untilClause):? {% ([, , , , gainsControlOf, until]) => until ? { gainsControlOf, until } : { gainsControlOf } %}
  | "remove" "s":? __ countableCount __ (counterKind __):? "counter" "s":? __ "from" __ object {% ([, , , count, , counterKind, , , , , , removeCountersFrom]) => counterKind ? { count, removeCountersFrom, counterKind: counterKind[0] } : { count, removeCountersFrom } %}
  | ("cast" | "play") "s"i:? __ object (__ "without paying its mana cost"):? (__ duration):? (__ "only during" __ partOfTurn):? (__ "on each of" __ qualifiedPartOfTurn "s":?):? {% ([[cp], , , cast, withoutPaying, duration, onlyDuring, each]) => {
    const result = { [cp.toLowerCase()]: cast };
    if (withoutPaying) result.withoutPaying = true;
    if (duration) result.duration = duration[1];
    if (onlyDuring) result.onlyDuring = onlyDuring[3];
    if (each) result.each = each[3];
    return result;
  } %}
  | "surveil" __ number {% ([, , surveil]) => ({ surveil }) %}
  | "search" "es":? __ zone (__ "for" __ object):? {% ([, , , search, criteria]) => criteria ? { search, criteria: criteria[3] } : search %}
  | "choose" "s":? __ (object {% ([o]) => o %} | "a" __ anyType __ "type" {% ([, , type]) => ({ type }) %} | "not to" __ imperative {% ([, , not]) => ({ not }) %} | "a card name" {% () => "cardName" %} | "a color" {% () => "color" %}) {% ([, , , choose]) => ({ choose }) %}
  | "draw" "s":? __ ("a" __ "card" {% () => 1 %} | "an additional card" {% () => 1 %} | englishNumber __ "card" "s" {% ([n]) => n %}) {% ([, , , draw]) => ({ draw }) %}
  | "draw" "s":? __ "cards equal to" __ numberDefinition {% ([, , , , , draw]) => ({ draw }) %}
  | "shuffle" "s":? __ zone {% ([, , , shuffle]) => ({ shuffle }) %}
  | "shuffle" "s":? __ (object | zone) __ "into" __ zone {% ([, , , shuffle, , , , into]) => ({ shuffle, into }) %}
  | "counter" "s":? __ object {% ([, , counter]) => ({ counter }) %}
  | "tap" "s":? (__ "or untap"):? __ object {% ([, , untap, , tap]) => untap ? { does: { or: ["tap", "untap"] }, to: tap } : { tap } %}
  | "untap" "s":? (__ "and goad" "s":?):? __ object (__ "during" __ qualifiedPartOfTurn):? {% ([, , goad, , tap, during]) => {
      const result = during ? { tap, when: during[3] } : { tap };
      if (goad) result.goad = true;
      return result;
    } %}
  | "take" "s":? __ "an extra turn after this one" {% () => "takeExtraTurn" %}
  | "scry" __ number {% ([, , scry]) => ({ scry }) %}
  | "pay" "s":? __ manacost (__ "rather than pay the mana cost for" __ object):? {% ([, , , pay, rather]) => rather ? { pay, ratherThanCostOf: rather[3] } : { pay } %}
  | "pay" "s":? __ numericalNumber __ "life" {% ([, , , life]) => ({ pay: { life } }) %}
  | "add one mana of any color" {% () => ({ addOneOf: ["W", "U", "B", "R", "G"], amount: 1 }) %}
  | "add" "s":? __ englishNumber __ "mana of any one color" {% ([, , , amount]) => ({ addOneOf: ["w", "u", "b", "r", "g"], amount }) %}
  | "add" "s":? __ englishNumber __ "mana in any combination of" __ (manaSymbol __ "and/or" __ manaSymbol {% ([c1, , , , c2]) => [c1, c2] %} | "colors" {% () => ["w", "u", "b", "r", "g"] %}) {% ([, , , amount, , , , addCombinationOf]) => ({ addCombinationOf, amount }) %}
  | "add" "s":? __ manaSymbols (",":? __ "or" __ manaSymbols):* {% ([, , , m1, ms]) => ({ addOneOf: [m1, ...ms.map(([, , , , m2]) => m2)] }) %}
  | "prevent" __ damagePreventionAmount __ damageNoun __ (object __ "would deal" {% ([from]) => ({ from }) %} | "that would be dealt" (__ "to" __ anyEntity):? {% ([, to]) => to ? { to: to[3] } : { to: "any" } %}) (__ duration):?{% ([, , amount, , prevent, , to, duration]) => {
    const result = to ? { amount, prevent, ...to } : { amount, prevent };
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | "put" "s":? __ englishNumber __ counterKind __ "counter" "s":? __ "on" __ object {% ([, , , amount, , counterKind, , , , , , , putOn]) => ({ amount, counterKind, putOn }) %}
  | "choose" "s":? __ object {% ([, , , choose]) => ({ choose }) %}
  | "look" "s":? __ "at the top" __ englishNumber __ "cards of" __ zone ("," __ "then put them back in any order"):? {% ([, ,  , , , lookAtTop, , , , from, anyOrder]) => anyOrder ? { lookAtTop, from, anyOrder: true } : { lookAtTop, from } %}
  | "look" "s":? __ "at" __ object {% ([, , , , , lookAt]) => ({ lookAt }) %}
  | "reveal" "s":? __ (object | zone) (__ "at random" __ fromZone):? {% ([, , , [reveal], random]) => random ? { random: true, from: random[3], reveal } : { reveal } %}
  | "put" "s":? __ object __ intoZone (__ "tapped"):? (__ "and" __ object __ intoZone):? (__ "under" __ playersPossessive __ "control"):? {% ([, , , put, , into, tapped, additional, control]) => {
    let result = { put, into };
    if (tapped) result.tapped = true;
    if (control) result.control = control[3];
    if (additional) result = { and: [result, { put: additonal[3], into: additional[5] }] };
    return result;
  } %}
  | gains __ "control of" __ object {% ([, , , , gainControlOf]) => ({ gainControlOf }) %}
  | "may" __ sentence (". if you do," __ sentence):? {% ([, , may, ifDo]) => ifDo ? { may, ifDo: ifDo[2] } : { may } %}
  | "have" __ object __ (objectInfinitive {% ([property]) => ({ property }) %} | objectVerbPhrase {% ([does]) => ({ does }) %}) {% ([, , have, , property]) => ({ have, ...property }) %}
  | "have" __ player __ playerVerbPhrase {% ([, , actor, , does]) => ({ actor, does }) %}
  | "have your life total become" __ numberDefinition {% ([, , lifeTotalBecomes]) => ({ lifeTotalBecomes }) %}
  | "have" __ numericalComparison __ numberDefinition {% ([, , comparison, , value]) => ({ comparison, value }) %}
  | imperative __ "for each" __ pureObject {% ([does, , , , forEach]) => ({ does, forEach }) %}
  | imperative __ "unless" __ sentence {% ([does, , , , unless]) => ({ does, unless }) %}
  | "choose new targets for" __ object {% ([, , newTargets]) => ({ choose: { newTargets } }) %}
  | "switch the power and toughness of" __ object __ untilClause {% ([, , switchPowerToughness, , until]) => ({ switchPowerToughness, until }) %}
  | "do the same for" __ object {% ([, , doSameFor]) => ({ doSameFor }) %}
  | "spend mana as though it were mana of any type to cast" __ object {% ([, , spendManaAsAnyTypeFor]) => ({ spendManaAsAnyTypeFor }) %}
  | "transform" __ object {% ([, , transform]) => ({ transform }) %}
  | "flip a coin" {% () => "flipCoin" %}
  | "win the flip" {% () => "winFlip" %}
  | "lose the flip" {% () => "loseFlip" %}
  | "regenerate" __ object {% ([, , regenerate]) => ({ regenerate }) %}
  | "bolster" __ englishNumber {% ([, , bolster]) => ({ bolster }) %}
  | "populate" {% () => "populate" %}
  | imperative __ untilClause {% ([does, , until]) => ({ does, until }) %}
  | "support" __ number {% ([, , support]) => ({ support }) %}
  | "attach" __ object __ "to" __ object {% ([, , attach, , , , to]) => ({ attach, to }) %}
  | "end the turn" {% () => "endTurn" %}
  | "cast" __ numericalComparison __ "spell" __ duration {% ([, , comparison, , what, , duration]) => ({ cast: { comparison, what, duration } }) %}

playerVerbPhrase -> gains __ number __ "life" {% ([, , lifeGain]) => ({ lifeGain }) %}
  | gains __ "life equal to" __ itsPossessive __ numericalCharacteristic {% ([, , , , whose, , value]) => ({ lifeGain: { whose, value } }) %}
  | playerVerbPhrase __ "for each" __ pureObject {% ([does, , , , forEach]) => ({ does, forEach }) %}
  | playerVerbPhrase __ "for the first time each turn" {% ([does]) => ({ does, reference: "firstTime", duration: { reference: "each", what: "turn" } }) %}
  | controls __ ("no" __):? object {% ([, , negation, controls]) => negation ? { not: { controls } } : { controls } %}
  | owns __ object {% ([, , owns]) => ({ owns }) %}
  | (DON_T | DOESN_T) "lose this mana as steps and phases end." {% () => "doesntEmpty" %}
  | "puts" __ object __ intoZone {% ([, , what, , enters]) => ({ what, enters }) %}
  | "surveil" "s":? {% () => "surveil" %}
  | "life total becomes" __ englishNumber {% ([, , lifeTotalBecomes]) => ({ lifeTotalBecomes }) %}
  | "attack" ("s" | "ed"):? (__ player):? (__ "with" __ numericalComparison __ "creatures"):? (__ duration):? {% ([, , who, creatures, duration]) => {
    if (!who && !creatures && !duration) return "attack";
    const result = { does: "attack" };
    if (who) result.who = who[1];
    if (creatures) result.creatures = creatures[3];
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | imperative {% ([i]) => i %}
  | playerVerbPhrase ("," | ".") __ "then" __ playerVerbPhrase {% ([p1, , , , , p2]) => ({ and: [p1, p2] }) %}
  | CAN_T __ imperative {% ([, , cant]) => ({ cant }) %}
  | (DOESN_T | DON_T) {% () => { not: "do" } %}
  | ("does" | "do") {% () => "do" %}
  | "lose" "s":? __ "the game" {% () => "lose" %}
  | playerVerbPhrase __ "if" __ sentence {% ([does, , , , condition]) => ({ does, condition }) %}
  | playerVerbPhrase __ "this way" {% ([does]) => ({ does, reference: "thisWay" }) %}
  | gets __ "an emblem" __ withClause {% ([, , , , emblem]) => ({ emblem }) %}
  | "each" __ playerVerbPhrase {% ([, , each]) => ({ each }) %}
  | "cycle" __ object {% ([, , cycle]) => ({ cycle }) %}
  | "has no cards in hand" {% () => ({ not: { has: { what: "card", in: "hand" } } }) %}
  | "has" __ object __ objectVerbPhrase {% ([, , what, , does]) => ({ what, does }) %}
objectVerbPhrase -> connected[objectVerbPhrase] {% ([c]) => c %}
  | ("was" | "is") __ object {% ([, , is]) => ({ is }) %}
  | ("has" | "have") __ acquiredAbility (__ asLongAsClause):? {% ([, , haveAbility, asLongAs]) => asLongAs ? { haveAbility, asLongAs: asLongAs[1] } : { haveAbility } %}
  | ("has" | "have") __ "base power and toughness" __ pt {% ([, , , , basePowerToughness]) => ({ basePowerToughness }) %}
  | gains __ acquiredAbility (__ "and" __ gets __ ptModification):? {% ([, , gains, gets]) => gets ? { gains, ...gets[5] } : { gains } %}
  | gets __ ptModification (__ forEachClause):? (__ "and" __ gains __ acquiredAbility):? (__ untilClause):? (__ asLongAsClause):? {% ([, , powerToughnessMod, forEach, gains, until, asLongAs]) => {
    const result = { powerToughnessMod };
    if (forEach) result.forEach = forEach[1];
    if (gains) result.gains = gains[5];
    if (until) result.until = until[1];
    if (asLongAs) result.asLongAs = asLongAs[1];
    return result;
  } %}
  | "enter" "s":? __ "the battlefield with" __ (englishNumber {% ([n]) => n %} | englishNumber __ "additional" {% ([additional]) => ({ additional }) %}) __ counterKind __ "counter" "s":? __ "on it" (__ forEachClause):? {% ([, , , , amount, , counterKind, , , , , , forEach]) => ({ entersWith: forEach ? { amount, counterKind, forEach: forEach[1] } : { amount, counterKind } }) %}
  | "enter" "s":? __ "the battlefield with a number of" (__ "additional"):? __ counterKind __ "counters on it equal to" __ numberDefinition {% ([, additional, , counterKind, , , , amount]) => ({ entersWith: additional ? { counterKind, amount, additional: true } : { counterKind, amount } }) %}
  | "enter" "s":? __ "the battlefield" (__ "tapped"):? (__ "under" __ playersPossessive __ "control"):? (__ fromZone):? (__ "and with" __ (englishNumber {% ([n]) => n %} | englishNumber __ "additional" {% ([additional]) => ({ additional }) %}) __ counterKind __ "counter" "s":? __ "on it"):?  {% ([, , , , tapped, control, from, counters]) => {
    const result = { enter: "battlefield" }
    if (tapped) result.tapped = true;
    if (control) result.control = control[3];
    if (from) result.from = from[1];
    if (counters) result.with = { amount: counters[3], counterKind: counters[5] };
    return result;
  } %}
  | "leave" "s":? __ "the battlefield" {% () => ({ leaves: "battlefield" }) %}
  | "die" "s":? {% () => "die" %}
  | ("is" | "would be") __ "put" __ intoZone (__ fromZone):? {% ([, , , , enter, from]) => from ? { enter, from: from[1] } : { enter } %}
  | (CAN_T | DON_T | DOESN_T) __ cantClause {% ([, , cant]) => ({ cant }) %}
  | "deal" "s":? __ dealsWhat {% ([, , , deal]) => ({ deal }) %}
  | ("is" | "are") __ isWhat {% ([, , is]) => ({ is }) %}
  | "attack" "s":? (__ ("this" | "each") __ "combat if able"):? (__ "and" __ ISN_T __ "blocked"):? {% ([, , reference, isntBlocked]) => {
      const result = reference ? { mustAttack: reference[1][0] } : "attacks";
      return isntBlocked ? { and: [result, { not: "blocked" }] } : result;
    } %}
  | "block" "s":? (__ "this" __ "combat if able"):?
  | gains __ acquiredAbility {% ([, , gains]) => ({ gains }) %}
  | "untap during" __ qualifiedPartOfTurn {% ([, , untap]) => ({ untap }) %}
  | "blocks" (__ "or becomes blocked by"):? __ object {% ([, becomesBlocked, , blocks]) => becomesBlocked ? { or: [{ blocks }, { blockedBy: blocks}] } : { blocks } %}
  | "is countered this way" {% () => ({ reference: "thisWay", does: "countered" }) %}
  | "fights" __ object {% ([, , fights]) => ({ fights }) %}
  | "targets" __ object {% ([, , targets]) => ({ targets }) %}
  | "loses" __ keyword {% ([, , loses]) => ({ loses }) %}
  | "cost" "s":? __ ("up to" __):? manacost __  "less to cast" {% ([, , , , mana]) => ({ costReduction: { mana } }) %}
  | "can attack as though it didn\"t have defender" {% () => ({ ignores: "defender" }) %}
  | "can block an additional" __ object __ "each combat" {% ([, , blockAdditional]) => ({ blockAdditional }) %}
  | ("do" | "does") __ "so" {% () => "do" %}
  | "remain" "s":? __ "exiled" {% () => ({ remain: "exile" }) %}
  | "become" "s":? __ becomesWhat {% ([, , , become]) => ({ become }) %}
  | "lose" "s":? __ "all abilities" (__ untilClause):? {% ([, , , , until]) => until ? { loses: "allAbilities", until } : { loses: "allAbilities" } %}
  | ("is" | "are") __ "created" {% () => "created" %}
  | "cause" "s":? __ player __ "to" __ playerVerbPhrase {% ([, , , actor, , , , does]) => ({ cause: { actor, does } }) %}
  | objectVerbPhrase __ forEachClause {% ([does, , forEach]) => ({ does, forEach }) %}
  | objectVerbPhrase __ duration {% ([does, , duration]) => ({ does, duration }) %}
  | objectVerbPhrase __ "if" __ sentence {% ([does, , , , condition]) => ({ does, condition }) %}
  | "was kicked" {% () => "kicked" %}
  | "was milled this way" {% () => ({ reference: "thisWay", does: "milled" }) %}
  | "was cast from a graveyard" {% () => ({ does: "cast", from: "graveyard" }) %}
  | CAN_T __ "be countered" {% () => ({ cant: "countered" }) %}
  | ("the" __):? "damage" __ CAN_T __ "be prevented" {% () => ({ cantPrevent: "damage" }) %}
  | CAN_T __ "attack" __ duration {% ([, , , , cantAttack]) => ({ cantAttack }) %}
  | CAN_T __ "be blocked" (__ "by" __ object):? (__ duration):? {% ([, , , by, duration]) => {
    const result = { cant: { blockedBy: by ? by[3] : "any" } };
    if (duration) result.duration = duration[1];
    return result;
  } %}
  | "cost" __ cost __ "more to" __ ("cast" | "activate") {% ([, , costIncrease, , , , [action]]) => ({ costIncrease, action }) %}
  | "as" __ object (__ "in addition to its other types"):? {% ([, , as, inAddition]) => inAddition ? { as, inAddition: true } : { as } %}
  | "assign its combat damage as though it" __ WEREN_T __ "blocked" {% () => ({ damage: { as: { not: "blocked" } } }) %}
  | "remains tapped" {% () => ({ remains: "tapped" }) %}
  | objectVerbPhrase __ ("and" | "or") __ sentence {% ([does, , [connector], , next]) => ({ [connector]: [does, next] }) %}
objectInfinitive -> "be put" __ intoZone __ duration {% ([, , enter, , duration]) => ({ enter, duration }) %}
  | "be created under your control" {% () => ({ reference: { actor: "you", does: "control" }, does: "create" }) %}
  | "fight" __ object {% ([, , fight]) => ({ fight }) %}
  | "deal" __ dealsWhat {% ([, , deal]) => ({ deal }) %}

isWhat -> color {% ([color]) => ({ color }) %}
  | object (__ "in addition to its other" (__ "colors"):? (__ "and"):? (__ "types"):?):? {% ([object, addition]) => addition ? { object, inAddition: true } : { object } %}
  | inZone {% ([inZone]) => ({ inZone }) %}
  | "still" __ object {% ([, , still]) => ({ still }) %}
  | "turned face up" {% () => "turnedFaceUp" %}
  | "attacking" {% () => "attacking" %}
  | "blocking" {% () => "blocking" %}
  | "attacking" __ "or" __ "blocking" {% () => ({ or: ["attacking", "blocking"] }) %}
  | condition {% ([condition]) => ({ condition }) %}
  | "enchanted" {% () => "enchanted" %}
becomesWhat -> "tapped" {% () => "tap" %}
  | "untapped" {% () => ({ not: "tap" }) %}
  | "unattached" (__ "from" __ object) {% ([, to]) => ({ not: to ? { does: "attached", to: to[3] } : { does : "attached" } }) %}
  | "a copy of" __ object ("," __ exceptClauseInCopyEffect):? {% ([, , copyOf, except]) => except ? { copyOf, except: except[2] } : { copyOf } %}
  | "a" "n":? (__ pt):? (__ color):? __ anyType (__ "with base power and toughness" __ pt):? (__ "with" __ acquiredAbility):? (__ "in addition to its other types"):? {% ([, , size, color, , type, size2, withClause, inAddition]) => {
    const result = { type };
    if (color) result.color = color[1];
    if (size) result.size = size[1];
    else if (size2) result.size = size2[3];
    if (withClause) result.with = withClause[3];
    if (inAddition) result.inAddition = true;
    return result;
  } %}
  | "the basic land type" "s":? __ "of your choice" __ untilClause {% ([, , , , , until]) => ({ choose: "basicLandType", until }) %}
  | "blocked" (__ "by" __ object) {% ([, by]) => by ? { blockedBy: by[3] } : { blockedBy: "any" } %}
  | "colorless" {% () => ({ color: [] }) %}
  | "that type" {% () => ({ reference: "that", what: "type" }) %}
  | "renowned" {% () => "renowned" %}
exceptClauseInCopyEffect -> "except" __ copyException ("," __ ("and" __ ):? copyException):* {% ([, , e1, es]) => es.length > 0 ? { and: [e1, ...es.map(([, , , e2]) => e2)] } : e1 %}
copyException -> "its name is" __ CARD_NAME {% ([, , name]) => ({ name }) %}
  | IT_S __ isWhat {% ([, , is]) => ({ is }) %}
  | singleSentence {% ([s]) => s %}

itsPossessive -> object SAXON {% ([o]) => o %}
  | "its" {% () => ({ reference: "its" }) %}
  | "their" {% () => ({ reference: "their" }) %}
  | "your" {% () => ({ reference: "your" }) %}

acquiredAbility -> keyword {% ([k]) => k %}
  | "\"" ability "\"" {% ([, a]) => a %}
  | "“" ability "”" {% ([, a]) => a %}
  | acquiredAbility __ "and" __ acquiredAbility {% ([a1, , , , a2]) => ({ and: [a1, a2] }) %}
  | "this ability" {% () => "thisAbility" %}

gets -> "get" "s":?
controls -> "control" "s":?
owns -> "own" "s":?
gains -> "gain" "s":?

duration -> "this turn" {% () => ({ reference: "this", what: "turn" }) %}
  | "last turn" {% () => ({ reference: "last", what: "turn" }) %}
  | ("for" __):? asLongAsClause {% ([, asLongAs]) => ({ asLongAs }) %}
  | untilClause {% ([until]) => ({ until }) %}
  | "each turn" {% () => ({ each: "turn" }) %}
untilClause -> "until" __ untilClauseInner {% ([, , u]) => u %}
untilClauseInner -> sentence {% ([s]) => s %}
  | "end of turn" {% () => "endOfTurn" %}
  | "your next turn" {% () => "yourNextTurn" %}

numericalCharacteristic -> "toughness" {% () => "toughness" %}
  | "power" {% () => "power" %}
  | "converted mana cost" {% () => "cmc" %}
  | "life total" {% () => "lifeTotal" %}
  | "power and toughness" {% () => ({ and: ["power", "toughness"] }) %}

damagePreventionAmount -> "all" {% () => "all" %}
  | "the next" __ englishNumber {% ([, , next]) => next %}
damageNoun -> ("non":? "combat" __):? "damage" {% ([combat]) => ({ damage: combat ? (combat[0] ? { not: "combat" } : "combat") : "any" }) %}

tokenDescription -> englishNumber (__ pt):? (__ color):? __ permanentType __ "token" "s":? (__ withClause):? (__ "named" __ [^.]:+):? {% ([amount, size, color, , type, , , , withClause, name]) => {
  const result = { amount, type };
  if (size) result.size = size[1];
  if (color) result.color = color[1];
  if (withClause) result.with = withClause[1];
  if (name) result.name = name[3].join('');
  return result;
} %}
  | englishNumber __ "token" "s":? __ "that" SAXON __ "a copy of" __ object {% ([amount , , , , , , , , , copy]) => ({ amount, copy }) %}
  | connected[tokenDescription] {% ([c]) => c %}

color -> "white" {% () => "w" %}
  | "blue" {% () => "u" %}
  | "black" {% () => "b" %}
  | "red" {% () => "r" %}
  | "green" {% () => "g" %}
  | "colorless" {% () => "colorless" %}
  | "monocolored" {% () => "mono" %}
  | "multicolored" {% () => "multi" %}
  | connected[color] {% ([c]) => c %}

pt -> number "/" number {% ([power, , toughness]) => ({ power, toughness }) %}
ptModification -> PLUSMINUS number "/" PLUSMINUS number {% ([pmP, power, , pmT, toughness]) => ({ powerMod: '+' === pmP.toString() ? power : -power, toughnessMod: '+' === pmT.toString() ? toughness : -toughness }) %}
numberDefinition -> itsPossessive __ numericalCharacteristic {% ([whose, , characteristic]) => ({ whose, characteristic }) %}
  | "the" __ ("total" __):? "number of" __ object {% ([, , , , , count]) => ({ count }) %}
  | "the total" __ numericalCharacteristic __ "of" __ object {% ([, , total, , , , whose]) => ({ total, whose }) %}
  | "the greatest" __ numericalCharacteristic __ "among" __ anyEntity {% ([, , greatest, , , , among]) => ({ greatest, among }) %}
  | "life" {% () => "life" %}
  | englishNumber {% ([n]) => n %}
  | englishNumber __ (color __):? "mana" {% ([amount, , color]) => color ? { mana: { amount, color: color[0] } } : { mana: { amount } } %}
integerValue -> [0-9]:+ {% ([digits]) => parseInt(digits.join(''), 10) %}

withClause -> "with" __ withClauseInner {% ([, , withInner]) => ({ with: withInner }) %}
withClauseInner -> numericalCharacteristic __ numericalComparison {% ([value, , comparison]) => ({ value, comparison }) %}
  | "the highest" __ numericalCharacteristic __ "among" __ object {% ([, , hightest, , , , among]) => ({ highest, amont }) %}
  | "converted mana costs" __ numericalNumber __ "and" __ numericalNumber {% ([, , cmc, and]) => and ? { and: [{ cmc }, { cmc: and[3] }] } : { cmc } %}
  | counterKind __ "counter" "s":? __ "on" __ ("it" | "them") {% ([counterKind]) => ({ counterKind }) %}
  | "that name" {% () => ({ reference: "that", what: "name" }) %}
  | "the same name as" __ object {% ([, , sameNameAs]) => ({ sameNameAs }) %}
  | acquiredAbility {% ([ability]) => ({ ability }) %}
  | object {% ([object]) => ({ object }) %}

dealsWhat -> damageNoun __ "to" __ damageRecipient {% ([damage, , , , to]) => ({ ...damage, to }) %}
 | numberDefinition __ "damage to" __ damageRecipient {% ([amount, , , , damageTo]) => ({ amount, damageTo }) %}
 | "damage equal to" __ numberDefinition __ "to" __ damageRecipient {% ([, , amount, , , , damageTo]) => ({ amount, damageTo }) %}
 | "damage to" __ damageRecipient __ "equal to" __ numberDefinition {% ([, , damageTo, , , , amount]) => ({ amount, damageTo }) %}
 | numberDefinition __ "damage" __ divideAmongDamageTargets {% ([amount, , , , divideAmong]) => ({ amount, divideAmong }) %}
 | "damage equal to" __ numberDefinition __  divideAmongDamageTargets {% ([, , amount, , divideAmong]) => ({ amount, divideAmong }) %}

damageRecipient -> anyEntity {% ([o]) => o %}
  | "any target" {% () => "anyTarget" %}
  | ("target" __):? connected[damageRecipient] {% ([target, rs]) => target ? { target: rs } : rs %}
  | "itself" {% () => "self" %}
divideAmongDamageTargets -> "divided as you choose among" __ divideTargets {% ([, , divideTargets]) => divideTargets %}
divideTargets -> "one, two, or three targets" {% () => ({ targetCount: [1, 2, 3] }) %}
  | "any number of" __ object {% ([, , target]) => ({ targetCount: "any", target }) %}
  | "one or two targets" {% () => ({ targetCount: [1, 2] }) %}

englishNumber -> "a" {% () => 1 %}
  | "an" {% () => 1 %}
  | "a single" {% () => 1 %}
  | "one" {% () => 1 %}
  | "two" {% () => 2 %}
  | "twice" {% () => 2 %}
  | "three" {% () => 3 %}
  | "four" {% () => 4 %}
  | "five" {% () => 5 %}
  | "six" {% () => 6 %}
  | "seven" {% () => 7 %}
  | "eight" {% () => 8 %}
  | "nine" {% () => 9 %}
  | "ten" {% () => 10 %}
  | "that" __ ("many" | "much") {% () => ({ reference: "that", what: "amount" }) %}
  | number {% ([n]) => n %}
numericalNumber -> number {% ([n]) => n %}
  | "that much" {% () => ({ reference: "that", what: "amount" }) %}
number -> (integerValue
  | "x"i
  | "y"i
  | "z") {% ([[n]]) => n %}
numericalComparison -> numberDefinition __ "or greater" {% ([gte]) => ({ gte }) %}
  | numberDefinition __ "or less" {% ([lte]) => ({ lte }) %}
  | "less than or equal to" __ numberDefinition {% ([, , lte]) => ({ lte }) %}
  | "greater than" __ numberDefinition {% ([, , gt]) => ({ gt }) %}
  | "at least" __ numberDefinition {% ([, , gte]) => ({ gte }) %}
  | "more than" __ numberDefinition {% ([, , gt]) => ({ gt }) %}
  | numberDefinition __ "or more" {% ([gte]) => ({ gte }) %}
  | numberDefinition {% ([n]) => n %}
countableCount -> "exactly" __ englishNumber {% ([, , eq]) => ({ eq }) %}
  | englishNumber __ "or more" {% ([atLeast]) => ({ atLeast }) %}
  | "fewer than" __ englishNumber {% ([, , lessThan]) => ({ lessThan }) %}
  | "any number of" {% () => "anyNumber" %}
  | "one of" {% () => 1 %}
  | "up to" __ englishNumber {% ([, , upTo]) => ({ upTo }) %}
  | englishNumber {% ([n]) => n %}
  | "all" {% () => "all" %}
  | "both" {% () => "both" %}

cantClause -> cantClauseInner (__ "unless" __ condition):? {% ([cant, unless]) => unless ? { cant, unless: unless[3] } : cant %}
cantClauseInner -> "attack" {% () => "attack" %}
  | "block" (__ object):? {% ([, block]) => block ? { block } : "block" %}
  | "attack or block" {% () => ({ or: ["attack", "block"] }) %}
  | "attack or block alone" {% () => ({ or: [{ does: "attack", suffix: "alone" }, { does: "block", suffix: "alone" }] }) %}
  | "attack alone" {% () => ({ does: "attack", suffix: "alone" }) %}
  | "block alone" {% () => ({ does: "block", suffix: "alone" }) %}
  | "be blocked" {% () => "blocked" %}
  | "be countered" {% () => "countered" %}
  | "be blocked by more than" __ englishNumber __ "creature" "s":? {% ([, , gt]) => ({ blockedBy: { gt } }) %}
  | "be enchanted" (__ "by" __ object):? {% ([, by]) => by ? { what: by[3], does: "enchant" } : "enchanted" %}
  | objectVerbPhrase {% ([does]) => does %}
  | "be regenerated" {% () => "regenerate" %}

zone -> (playersPossessive | "a" (__ "single"):?) __ ownedZone {% ([[owner], , zone]) => ({ owner, zone }) %}
  | "exile" {% () => "exile" %}
  | "the battlefield" {% () => "battlefield" %}
  | "it" {% () => "it" %}
  | "anywhere" {% () => "anywhere" %}
ownedZone -> "graveyard" {% () => "graveyard" %}
  | "library" {% () => "library" %}
  | "libraries" {% () => "library" %}
  | "hand" {% () => "hand" %}
  | ownedZone "s" {% ([z]) => z %}
  | connected[ownedZone] {% ([c]) => c %}
intoZone -> "onto the battlefield" {% () => "battlefield" %}
  | "into" __ zone {% ([, , into]) => into %}
  | "on top of" __ zone {% ([, , onTopOf]) => ({ onTopOf }) %}
  | "on the bottom of" __ zone (__ "in" __  ("any" {% () => "any" %} | "a random" {% () => "random" %}) __ "order"):? {% ([, , bottom, order]) => order ? { bottom, order: order[3] } : { bottom } %}
inZone -> "on the battlefield" {% () => ({ in: "battlefield" }) %}
  | "in" __ zone {% ([, , inZone]) => ({ in: inZone }) %}
fromZone -> "from" __ zone {% ([, , z]) => z %}

permanentType -> "artifact" {% () => "artifact" %}
  | "creature" {% () => "creature" %}
  | "enchantment" {% () => "enchantment" %}
  | "land" {% () => "land" %}
  | "planeswalker" {% () => "planeswalker" %}
  | "basic" {% () => "basic" %}
  | "permanent" {% () => "permanent" %}
  | creatureType {% ([t]) => t %}
  | landType {% ([t]) => t %}
  | artifactType {% ([t]) => t %}
  | enchantmentType {% ([t]) => t %}
  | planeswalkerType {% ([t]) => t %}
  | permanentType __ permanentType {% ([t1, , t2]) => ({ and: [t1, t2] }) %}
  | connected[permanentType] {% ([c]) => c %}
anyType -> permanentType {% ([t]) => t %}
  | spellType {% ([t]) => t %}
  | "legendary" {% () => "legendary" %}
  | "[" anyType "]" {% ([, t]) => t %}
spellType -> "instant" {% () => "instant" %}
  | "sorcery" {% () => "sorcery" %}
  | "adventure" {% () => "adventure" %}
  | "arcane" {% () => "arcane" %}
  | "trap" {% () => "trap" %}
  | connected[spellType] {% ([c]) => c %}

asLongAsClause -> "as long as" __ condition {% ([, , c]) => c %}

replacementEffect -> sentence __ "instead of putting it" __ intoZone {% ([instead, , , , enters]) => ({ enters, instead }) %}
  | sentenceInstead {% ([s]) => s %}

costs -> connected[cost] {% ([c]) => c %}
  | cost ("," __ cost):* {% ([c, cs]) => cs.length > 0 ? { and: [c, ...cs.map(([, , c2]) => c2)] } : c %}
cost -> "{t}" {% () => "tap" %}
  | sentence {% ([s]) => s %}
  | manacost {% ([mana]) => ({ mana }) %}
  | loyaltyCost {% ([loyalty]) => ({ loyalty }) %}
loyaltyCost -> PLUSMINUS integerValue {% ([pm, int]) => pm === "+" ? int : -int %}
manacost -> manaSymbol:+ {% ([mg]) => mg %}
  | object SAXON __ "mana cost" {% ([costOf]) => ({ costOf }) %}
manaSymbols -> manaSymbol:+ {% ([s]) => s %}
manaSymbol -> "{" manaLetter ("/" manaLetter):? "}" {% ([, c, c2]) => c2 ? { hybrid: [c, c2[1]] } : c %}
manaLetter -> (integerValue
  | "x"i
  | "y"i
  | "z"i
  | "w"i
  | "u"i
  | "b"i
  | "r"i
  | "g"i
  | "c"i
  | "p"i
  | "s") {% ([[s]]) => s %}

qualifiedPartOfTurn -> turnQualification __ partOfTurn "s":? {% ([qualification, , partOfTurn]) => ({ qualification, partOfTurn }) %}
  | "combat on your turn" {% () => ({ qualification: "yourTurn", partOfTurn: "combat" }) %}
  | "combat" {% () => ({ partOfTurn: "combat" }) %}
  | "end of combat" {% () => ({ partOfTurn: "endCombat" }) %}
turnQualification -> (playersPossessive | "the") (__ "next"):? {% ([[whose, next]]) => next ? { next: { whose } } : { whose } %}
  | "this" {% () => "this" %}
  | "each" {% () => "each" %}
  | "this turn" SAXON {% () => ({ reference: "this", what: "turn" }) %}
  | "that turn" SAXON {% () => ({ refernce: "that", what: "turn" }) %}
  | "the next turn" SAXON {% () => ({ reference: "next", what: "turn" }) %}
  | "the beginning of" __ turnQualification {% ([, , beginningOf]) => ({ beginningOf }) %}
partOfTurn -> "turn" {% () => "turn" %}
  | "untap step" {% () => "untap" %}
  | "upkeep" {% () => "upkeep" %}
  | "draw step" {% () => "drawStep" %}
  | "precombat main phase" {% () => "precombatMain" %}
  | "main phase" {% () => "main" %}
  | "combat" {% () => "combat" %}
  | "declare attackers" {% () => "declareAttackers" %}
  | "declare blockers" {% () => "declareBlockers" %}
  | "combat damage step" {% () => "combatDamage" %}
  | "postcombat main phase" {% () => "postcombatMain" %}
  | "end step" {% () => "end" %}

playersPossessive -> "your" {% () => "your" %}
  | "their" {% () => "their" %}
  | player (SAXON | AP) {% ([player]) => player %}

AP -> "'" | "’"
CARD_NAME -> ("~" 
  | "Prossh"
  | "Elenda") {% () => "CARD_NAME" %}
CAN_T -> "can't" | "can’t"i
DON_T -> "don't" | "don’t"i
DOESN_T -> "doesn't" | "doesn’t"i
DASHDASH -> "--" | "—"
ISN_T -> "isn't" | "isn’t"i
IT_S -> "it's" | "it’s"i
PLUSMINUS -> "+" | "-" | "−"
SAXON -> AP "s"
THAT_S -> "that's" | "that’s"i
WEREN_T -> "weren't" | "weren’t"i
YOU_VE -> "you've" | "you’ve"i
