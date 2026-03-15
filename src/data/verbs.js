import theme from "../theme";

/**
 * Verb database.
 *
 * Each entry contains:
 *  - id        – unique slug
 *  - ca / fr   – infinitive in Catalan / French
 *  - group     – conjugation group label
 *  - color     – accent colour for UI highlights
 *  - tenses    – { present, passat, futur } arrays of 6 conjugated forms
 *  - sentences – contextual example sentences
 */
const VERBS = [
  {
    id: "ser",
    ca: "Ser",
    fr: "Être",
    group: "Irregular",
    color: theme.accent,
    tenses: {
      present: ["sóc", "ets", "és", "som", "sou", "són"],
      passat: ["vaig ser", "vas ser", "va ser", "vam ser", "vau ser", "van ser"],
      futur: ["seré", "seràs", "serà", "serem", "sereu", "seran"],
    },
    sentences: [
      { form: 0, ca: "Sóc francès.", fr: "Je suis français.", tense: "present" },
      { form: 2, ca: "Ell és molt simpàtic.", fr: "Il est très sympa.", tense: "present" },
      { form: 3, ca: "Som de França.", fr: "Nous sommes de France.", tense: "present" },
      { form: 5, ca: "Són a l'escola.", fr: "Ils sont à l'école.", tense: "present" },
      { form: 0, ca: "Vaig ser el primer.", fr: "J'ai été le premier.", tense: "passat" },
      { form: 2, ca: "Serà un bon dia.", fr: "Ce sera une bonne journée.", tense: "futur" },
    ],
  },
  {
    id: "estar",
    ca: "Estar",
    fr: "Être (état)",
    group: "Irregular",
    color: theme.pink,
    tenses: {
      present: ["estic", "estàs", "està", "estem", "esteu", "estan"],
      passat: ["vaig estar", "vas estar", "va estar", "vam estar", "vau estar", "van estar"],
      futur: ["estaré", "estaràs", "estarà", "estarem", "estareu", "estaran"],
    },
    sentences: [
      { form: 0, ca: "Estic content.", fr: "Je suis content.", tense: "present" },
      { form: 0, ca: "Estic cansat.", fr: "Je suis fatigué.", tense: "present" },
      { form: 1, ca: "Estàs bé?", fr: "Tu vas bien ?", tense: "present" },
      { form: 2, ca: "Està ploguent.", fr: "Il pleut.", tense: "present" },
      { form: 3, ca: "Estem aprenent català.", fr: "Nous apprenons le catalan.", tense: "present" },
      { form: 2, ca: "Va estar malalt una setmana.", fr: "Il a été malade une semaine.", tense: "passat" },
    ],
  },
  {
    id: "tenir",
    ca: "Tenir",
    fr: "Avoir",
    group: "Irregular",
    color: theme.blue,
    tenses: {
      present: ["tinc", "tens", "té", "tenim", "teniu", "tenen"],
      passat: ["vaig tenir", "vas tenir", "va tenir", "vam tenir", "vau tenir", "van tenir"],
      futur: ["tindré", "tindràs", "tindrà", "tindrem", "tindreu", "tindran"],
    },
    sentences: [
      { form: 0, ca: "Tinc fam.", fr: "J'ai faim.", tense: "present" },
      { form: 0, ca: "Tinc un fill.", fr: "J'ai un fils.", tense: "present" },
      { form: 1, ca: "Tens raó.", fr: "Tu as raison.", tense: "present" },
      { form: 2, ca: "Té tres anys.", fr: "Il a trois ans.", tense: "present" },
      { form: 0, ca: "Tinc set.", fr: "J'ai soif.", tense: "present" },
      { form: 3, ca: "Tenim temps.", fr: "Nous avons le temps.", tense: "present" },
    ],
  },
  {
    id: "fer",
    ca: "Fer",
    fr: "Faire",
    group: "Irregular",
    color: theme.gold,
    tenses: {
      present: ["faig", "fas", "fa", "fem", "feu", "fan"],
      passat: ["vaig fer", "vas fer", "va fer", "vam fer", "vau fer", "van fer"],
      futur: ["faré", "faràs", "farà", "farem", "fareu", "faran"],
    },
    sentences: [
      { form: 2, ca: "Avui fa molt de sol.", fr: "Aujourd'hui il fait très beau.", tense: "present" },
      { form: 0, ca: "Faig feina a casa.", fr: "Je travaille à la maison.", tense: "present" },
      { form: 1, ca: "Què fas?", fr: "Qu'est-ce que tu fais ?", tense: "present" },
      { form: 3, ca: "Fem un cafè?", fr: "On prend un café ?", tense: "present" },
      { form: 0, ca: "Vaig fer una passejada.", fr: "J'ai fait une promenade.", tense: "passat" },
      { form: 2, ca: "Farà bon temps demà.", fr: "Il fera beau demain.", tense: "futur" },
    ],
  },
  {
    id: "anar",
    ca: "Anar",
    fr: "Aller",
    group: "Irregular",
    color: "#6B5B95",
    tenses: {
      present: ["vaig", "vas", "va", "anem", "aneu", "van"],
      passat: ["vaig anar", "vas anar", "va anar", "vam anar", "vau anar", "van anar"],
      futur: ["aniré", "aniràs", "anirà", "anirem", "anireu", "aniran"],
    },
    sentences: [
      { form: 0, ca: "Vaig a la platja.", fr: "Je vais à la plage.", tense: "present" },
      { form: 3, ca: "Anem al mercat.", fr: "Nous allons au marché.", tense: "present" },
      { form: 2, ca: "Va a l'escola cada dia.", fr: "Il va à l'école chaque jour.", tense: "present" },
      { form: 1, ca: "On vas?", fr: "Où tu vas ?", tense: "present" },
      { form: 0, ca: "Vaig anar al port ahir.", fr: "Je suis allé au port hier.", tense: "passat" },
      { form: 3, ca: "Anirem a Palma dissabte.", fr: "Nous irons à Palma samedi.", tense: "futur" },
    ],
  },
  {
    id: "parlar",
    ca: "Parlar",
    fr: "Parler",
    group: "1er (-ar)",
    color: "#3D7A68",
    tenses: {
      present: ["parlo", "parles", "parla", "parlem", "parleu", "parlen"],
      passat: ["vaig parlar", "vas parlar", "va parlar", "vam parlar", "vau parlar", "van parlar"],
      futur: ["parlaré", "parlaràs", "parlarà", "parlarem", "parlareu", "parlaran"],
    },
    sentences: [
      { form: 0, ca: "Parlo una mica de català.", fr: "Je parle un peu catalan.", tense: "present" },
      { form: 1, ca: "Parles francès?", fr: "Tu parles français ?", tense: "present" },
      { form: 2, ca: "Parla massa ràpid.", fr: "Il parle trop vite.", tense: "present" },
      { form: 3, ca: "Parlem demà.", fr: "On en parle demain.", tense: "present" },
      { form: 0, ca: "Vaig parlar amb el veí.", fr: "J'ai parlé avec le voisin.", tense: "passat" },
      { form: 0, ca: "Parlaré millor d'aquí un any.", fr: "Je parlerai mieux dans un an.", tense: "futur" },
    ],
  },
  {
    id: "menjar",
    ca: "Menjar",
    fr: "Manger",
    group: "1er (-ar)",
    color: "#B5651D",
    tenses: {
      present: ["menjo", "menges", "menja", "mengem", "mengeu", "mengen"],
      passat: ["vaig menjar", "vas menjar", "va menjar", "vam menjar", "vau menjar", "van menjar"],
      futur: ["menjaré", "menjaràs", "menjarà", "menjarem", "menjareu", "menjaran"],
    },
    sentences: [
      { form: 3, ca: "Mengem a les dues.", fr: "Nous mangeons à deux heures.", tense: "present" },
      { form: 1, ca: "Què menges?", fr: "Qu'est-ce que tu manges ?", tense: "present" },
      { form: 0, ca: "Menjo pa amb tomàquet.", fr: "Je mange du pain à la tomate.", tense: "present" },
      { form: 2, ca: "Menja molt bé aquí.", fr: "On mange très bien ici.", tense: "present" },
      { form: 0, ca: "Vaig menjar paella ahir.", fr: "J'ai mangé de la paella hier.", tense: "passat" },
      { form: 3, ca: "Menjarem fora dissabte.", fr: "Nous mangerons dehors samedi.", tense: "futur" },
    ],
  },
  {
    id: "voler",
    ca: "Voler",
    fr: "Vouloir",
    group: "Irregular",
    color: "#8B5E83",
    tenses: {
      present: ["vull", "vols", "vol", "volem", "voleu", "volen"],
      passat: ["vaig voler", "vas voler", "va voler", "vam voler", "vau voler", "van voler"],
      futur: ["voldré", "voldràs", "voldrà", "voldrem", "voldreu", "voldran"],
    },
    sentences: [
      { form: 0, ca: "Vull un cafè, si us plau.", fr: "Je veux un café, s'il vous plaît.", tense: "present" },
      { form: 1, ca: "Vols venir?", fr: "Tu veux venir ?", tense: "present" },
      { form: 1, ca: "Què vols fer?", fr: "Qu'est-ce que tu veux faire ?", tense: "present" },
      { form: 3, ca: "Volem aprendre català.", fr: "Nous voulons apprendre le catalan.", tense: "present" },
      { form: 2, ca: "No vol menjar.", fr: "Il ne veut pas manger.", tense: "present" },
      { form: 0, ca: "Voldré anar-hi demà.", fr: "Je voudrai y aller demain.", tense: "futur" },
    ],
  },
  {
    id: "poder",
    ca: "Poder",
    fr: "Pouvoir",
    group: "Irregular",
    color: "#4A7C59",
    tenses: {
      present: ["puc", "pots", "pot", "podem", "podeu", "poden"],
      passat: ["vaig poder", "vas poder", "va poder", "vam poder", "vau poder", "van poder"],
      futur: ["podré", "podràs", "podrà", "podrem", "podreu", "podran"],
    },
    sentences: [
      { form: 0, ca: "No puc anar-hi avui.", fr: "Je ne peux pas y aller aujourd'hui.", tense: "present" },
      { form: 1, ca: "Pots ajudar-me?", fr: "Tu peux m'aider ?", tense: "present" },
      { form: 3, ca: "Podem quedar demà.", fr: "On peut se voir demain.", tense: "present" },
      { form: 2, ca: "No pot venir.", fr: "Il ne peut pas venir.", tense: "present" },
      { form: 1, ca: "Pots repetir, si us plau?", fr: "Tu peux répéter, s'il te plaît ?", tense: "present" },
      { form: 0, ca: "Vaig poder acabar a temps.", fr: "J'ai pu finir à temps.", tense: "passat" },
    ],
  },
  {
    id: "dir",
    ca: "Dir",
    fr: "Dire",
    group: "Irregular",
    color: "#6B8E5A",
    tenses: {
      present: ["dic", "dius", "diu", "diem", "dieu", "diuen"],
      passat: ["vaig dir", "vas dir", "va dir", "vam dir", "vau dir", "van dir"],
      futur: ["diré", "diràs", "dirà", "direm", "direu", "diran"],
    },
    sentences: [
      { form: 2, ca: "Què diu?", fr: "Qu'est-ce qu'il dit ?", tense: "present" },
      { form: 0, ca: "Em dic Dam.", fr: "Je m'appelle Dam.", tense: "present" },
      { form: 1, ca: "Com dius?", fr: "Comment tu t'appelles ?", tense: "present" },
      { form: 5, ca: "Diuen que farà bon temps.", fr: "Ils disent qu'il fera beau.", tense: "present" },
      { form: 0, ca: "Vaig dir que sí.", fr: "J'ai dit oui.", tense: "passat" },
      { form: 0, ca: "Li diré demà.", fr: "Je lui dirai demain.", tense: "futur" },
    ],
  },
  {
    id: "saber",
    ca: "Saber",
    fr: "Savoir",
    group: "Irregular",
    color: "#5B7B9A",
    tenses: {
      present: ["sé", "saps", "sap", "sabem", "sabeu", "saben"],
      passat: ["vaig saber", "vas saber", "va saber", "vam saber", "vau saber", "van saber"],
      futur: ["sabré", "sabràs", "sabrà", "sabrem", "sabreu", "sabran"],
    },
    sentences: [
      { form: 0, ca: "No ho sé.", fr: "Je ne sais pas.", tense: "present" },
      { form: 1, ca: "Saps on és?", fr: "Tu sais où c'est ?", tense: "present" },
      { form: 1, ca: "Saps parlar català?", fr: "Tu sais parler catalan ?", tense: "present" },
      { form: 2, ca: "Ell sap cuinar molt bé.", fr: "Il sait très bien cuisiner.", tense: "present" },
      { form: 0, ca: "Ja ho sabré.", fr: "Je le saurai.", tense: "futur" },
      { form: 0, ca: "Ho vaig saber ahir.", fr: "Je l'ai su hier.", tense: "passat" },
    ],
  },
  {
    id: "viure",
    ca: "Viure",
    fr: "Vivre",
    group: "3e (-re)",
    color: "#9B6B4A",
    tenses: {
      present: ["visc", "vius", "viu", "vivim", "viviu", "viuen"],
      passat: ["vaig viure", "vas viure", "va viure", "vam viure", "vau viure", "van viure"],
      futur: ["viuré", "viuràs", "viurà", "viurem", "viureu", "viuran"],
    },
    sentences: [
      { form: 0, ca: "Visc a Alcúdia.", fr: "J'habite à Alcúdia.", tense: "present" },
      { form: 1, ca: "On vius?", fr: "Tu habites où ?", tense: "present" },
      { form: 3, ca: "Vivim a Mallorca des de fa un temps.", fr: "Nous vivons à Majorque depuis un moment.", tense: "present" },
      { form: 2, ca: "Viu a prop de l'escola.", fr: "Il habite près de l'école.", tense: "present" },
      { form: 0, ca: "Vaig viure a París.", fr: "J'ai vécu à Paris.", tense: "passat" },
      { form: 3, ca: "Viurem aquí molt de temps.", fr: "Nous vivrons ici longtemps.", tense: "futur" },
    ],
  },
];

export default VERBS;
