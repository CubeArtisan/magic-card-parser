@include "./magicCard.ne"

typeLine -> (superType __):* type (__ type):* (__ DASHDASH (__ subType):+):? {% ([superType, t1, ts, subType]) => {
  const result = { type: t1 };
  if (ts.length > 0) result.type = { and: [t1, ...ts.map(([, t]) => t )] };
  if (superType.length === 1) result.superType = superType[0][0];
  else if (superType.length > 1) result.superType = { and: superType.map(([st]) => st) };
  if (subType) {
    if (subType[2].length === 1) result.subType = subType[2][0][1];
    else result.subType = { and: subType[2].map(([, st]) => st) };
  }
  return result;
} %}
