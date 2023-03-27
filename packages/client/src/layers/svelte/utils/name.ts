const firstNameList = [
  "Absolon",
  "Clikette",
  "Dowble",
  "Sigood",
  "Roset",
  "Mordaunt",
  "Kolette",
  "Archebawl",
  "Loyre",
  "Frere",
  "Barefote",
  "Tynker",
  "Stepfaste",
  "Holy",
  "Filthe",
  "Envye",
  "Wyse",
  "Grey",
  "Wype ",
  "Smol",
  "Wastell",
  "Childe",
  "Blameles",
  "Gege",
  "E.Z.",
];

const middleNameList = [
  "Mirthquake",
  "Follyhard",
  "Foolfire",
  "Jesteron",
  "Tricksterion",
  "Foolhardy",
  "Jesteria",
  "Prankstor",
  "Jesterious",
  "Foolferno",
  "Foolmarch",
  "Fooltar",
];

const lastNameList = ["I", "II", "III", "IV"];

function toTitleCase(str: string) {
  return str.replace(/\w\S*/g, function (txt) {
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
  });
}

// export function hashStrings(str1, str2) {
//   const hash = crypto.createHash('sha256');
//   hash.update(str1);
//   hash.update(str2);
//   return hash.digest('hex');
// }

function reverseString(str: string): string {
  if (str === "") return "";
  else return reverseString(str.substr(1)) + str.charAt(0);
}

export function idToAvatar(id: string) {
  return !id ? "" : "img/avatars2/" + String(parseInt(id) % 5) + ".jpeg";
}

export function idToName(id: string) {
  if (!id) return "";

  id = reverseString(id);

  const firstNameIndex = Number(id[0] + id[1]) || 0;
  const firstName = firstNameList[firstNameIndex % firstNameList.length];

  const middleNameIndex = Number(id[2] + id[3]) || 0;
  const middleName = middleNameList[middleNameIndex % middleNameList.length];

  return firstName + " " + middleName
}


const castleFirstNames = [
  "The Castle of",
  "The Star of",
  "The Blaze of",
  "The Great Recycler of",
  "The Semaphor of",
  "The Calling of",
  "The Warmth of",
  "The Light of",
  "The Comforter of",
  "The Sign of",
  "The Tower of",
  "The Vessel of",
];

const castleSecondNames = [
  "Tereris",
  "Juffo",
  "Justyz",
  "Kano",
  "Barchtel",
  "Barkins",
  "The Hound",
  "The Fool",
  "Syn",
  "Violette",
  "Noon",
  "Joliboye",
  "Jogeler",
  "Camphor",
  "Stalk",
  "Dawnse",
  "Gord",
  "Foly",
  "Kardu",
  "Bolka",
];

export function seedToCastleName(id: string) {
  if (!id) return "";

  let numId = parseInt(id);
  let stringId = numId.toString();

  const firstNameIndex = Number(stringId[0]) || 0;
  const firstName = castleFirstNames[firstNameIndex % castleFirstNames.length];

  const secondNameIndex = Number(stringId[6]) || 0;
  const secondName = castleSecondNames[secondNameIndex % castleSecondNames.length];

  return firstName + " " + secondName;
}
