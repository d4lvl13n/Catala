-- Seed data: 12 verbs with conjugations and example sentences
-- Matches verbs-fallback.json exactly

-- ========== VERBS ==========

INSERT INTO verbs (id, ca, fr, "group", sort_order) VALUES
('ser',    'Ser',    'Être',         'Irregular', 1),
('estar',  'Estar',  'Être (état)',  'Irregular', 2),
('tenir',  'Tenir',  'Avoir',        'Irregular', 3),
('fer',    'Fer',    'Faire',        'Irregular', 4),
('anar',   'Anar',   'Aller',        'Irregular', 5),
('voler',  'Voler',  'Vouloir',      'Irregular', 6),
('poder',  'Poder',  'Pouvoir',      'Irregular', 7),
('dir',    'Dir',    'Dire',         'Irregular', 8),
('saber',  'Saber',  'Savoir',       'Irregular', 9),
('parlar', 'Parlar', 'Parler',       '1er (-ar)', 10),
('menjar', 'Menjar', 'Manger',       '1er (-ar)', 11),
('viure',  'Viure',  'Vivre',        '3e (-re)',  12)
ON CONFLICT (id) DO UPDATE SET ca = EXCLUDED.ca, fr = EXCLUDED.fr, "group" = EXCLUDED."group", sort_order = EXCLUDED.sort_order;

-- ========== CONJUGATIONS ==========
-- Format: (verb_id, tense, pronoun_index, form)
-- Pronoun order: 0=Jo, 1=Tu, 2=Ell/Ella, 3=Nosaltres, 4=Vosaltres, 5=Ells/Elles

-- ser
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('ser', 'present', 0, 'sóc'),    ('ser', 'present', 1, 'ets'),     ('ser', 'present', 2, 'és'),
('ser', 'present', 3, 'som'),    ('ser', 'present', 4, 'sou'),     ('ser', 'present', 5, 'són'),
('ser', 'passat',  0, 'vaig ser'),('ser', 'passat', 1, 'vas ser'),  ('ser', 'passat',  2, 'va ser'),
('ser', 'passat',  3, 'vam ser'), ('ser', 'passat', 4, 'vau ser'),  ('ser', 'passat',  5, 'van ser'),
('ser', 'futur',   0, 'seré'),   ('ser', 'futur',  1, 'seràs'),    ('ser', 'futur',   2, 'serà'),
('ser', 'futur',   3, 'serem'),  ('ser', 'futur',  4, 'sereu'),    ('ser', 'futur',   5, 'seran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- estar
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('estar', 'present', 0, 'estic'),    ('estar', 'present', 1, 'estàs'),   ('estar', 'present', 2, 'està'),
('estar', 'present', 3, 'estem'),    ('estar', 'present', 4, 'esteu'),   ('estar', 'present', 5, 'estan'),
('estar', 'passat',  0, 'vaig estar'),('estar', 'passat', 1, 'vas estar'),('estar', 'passat',  2, 'va estar'),
('estar', 'passat',  3, 'vam estar'), ('estar', 'passat', 4, 'vau estar'),('estar', 'passat',  5, 'van estar'),
('estar', 'futur',   0, 'estaré'),   ('estar', 'futur',  1, 'estaràs'),  ('estar', 'futur',   2, 'estarà'),
('estar', 'futur',   3, 'estarem'),  ('estar', 'futur',  4, 'estareu'),  ('estar', 'futur',   5, 'estaran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- tenir
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('tenir', 'present', 0, 'tinc'),     ('tenir', 'present', 1, 'tens'),     ('tenir', 'present', 2, 'té'),
('tenir', 'present', 3, 'tenim'),    ('tenir', 'present', 4, 'teniu'),    ('tenir', 'present', 5, 'tenen'),
('tenir', 'passat',  0, 'vaig tenir'),('tenir', 'passat', 1, 'vas tenir'),('tenir', 'passat',  2, 'va tenir'),
('tenir', 'passat',  3, 'vam tenir'), ('tenir', 'passat', 4, 'vau tenir'),('tenir', 'passat',  5, 'van tenir'),
('tenir', 'futur',   0, 'tindré'),   ('tenir', 'futur',  1, 'tindràs'),  ('tenir', 'futur',   2, 'tindrà'),
('tenir', 'futur',   3, 'tindrem'),  ('tenir', 'futur',  4, 'tindreu'),  ('tenir', 'futur',   5, 'tindran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- fer
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('fer', 'present', 0, 'faig'),    ('fer', 'present', 1, 'fas'),      ('fer', 'present', 2, 'fa'),
('fer', 'present', 3, 'fem'),     ('fer', 'present', 4, 'feu'),      ('fer', 'present', 5, 'fan'),
('fer', 'passat',  0, 'vaig fer'), ('fer', 'passat', 1, 'vas fer'),   ('fer', 'passat',  2, 'va fer'),
('fer', 'passat',  3, 'vam fer'),  ('fer', 'passat', 4, 'vau fer'),   ('fer', 'passat',  5, 'van fer'),
('fer', 'futur',   0, 'faré'),    ('fer', 'futur',  1, 'faràs'),     ('fer', 'futur',   2, 'farà'),
('fer', 'futur',   3, 'farem'),   ('fer', 'futur',  4, 'fareu'),     ('fer', 'futur',   5, 'faran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- anar
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('anar', 'present', 0, 'vaig'),     ('anar', 'present', 1, 'vas'),      ('anar', 'present', 2, 'va'),
('anar', 'present', 3, 'anem'),     ('anar', 'present', 4, 'aneu'),     ('anar', 'present', 5, 'van'),
('anar', 'passat',  0, 'vaig anar'),('anar', 'passat',  1, 'vas anar'), ('anar', 'passat',  2, 'va anar'),
('anar', 'passat',  3, 'vam anar'), ('anar', 'passat',  4, 'vau anar'), ('anar', 'passat',  5, 'van anar'),
('anar', 'futur',   0, 'aniré'),    ('anar', 'futur',   1, 'aniràs'),   ('anar', 'futur',   2, 'anirà'),
('anar', 'futur',   3, 'anirem'),   ('anar', 'futur',   4, 'anireu'),   ('anar', 'futur',   5, 'aniran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- parlar
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('parlar', 'present', 0, 'parlo'),      ('parlar', 'present', 1, 'parles'),     ('parlar', 'present', 2, 'parla'),
('parlar', 'present', 3, 'parlem'),     ('parlar', 'present', 4, 'parleu'),     ('parlar', 'present', 5, 'parlen'),
('parlar', 'passat',  0, 'vaig parlar'),('parlar', 'passat',  1, 'vas parlar'), ('parlar', 'passat',  2, 'va parlar'),
('parlar', 'passat',  3, 'vam parlar'), ('parlar', 'passat',  4, 'vau parlar'), ('parlar', 'passat',  5, 'van parlar'),
('parlar', 'futur',   0, 'parlaré'),    ('parlar', 'futur',   1, 'parlaràs'),   ('parlar', 'futur',   2, 'parlarà'),
('parlar', 'futur',   3, 'parlarem'),   ('parlar', 'futur',   4, 'parlareu'),   ('parlar', 'futur',   5, 'parlaran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- menjar
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('menjar', 'present', 0, 'menjo'),      ('menjar', 'present', 1, 'menges'),     ('menjar', 'present', 2, 'menja'),
('menjar', 'present', 3, 'mengem'),     ('menjar', 'present', 4, 'mengeu'),     ('menjar', 'present', 5, 'mengen'),
('menjar', 'passat',  0, 'vaig menjar'),('menjar', 'passat',  1, 'vas menjar'), ('menjar', 'passat',  2, 'va menjar'),
('menjar', 'passat',  3, 'vam menjar'), ('menjar', 'passat',  4, 'vau menjar'), ('menjar', 'passat',  5, 'van menjar'),
('menjar', 'futur',   0, 'menjaré'),    ('menjar', 'futur',   1, 'menjaràs'),   ('menjar', 'futur',   2, 'menjarà'),
('menjar', 'futur',   3, 'menjarem'),   ('menjar', 'futur',   4, 'menjareu'),   ('menjar', 'futur',   5, 'menjaran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- voler
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('voler', 'present', 0, 'vull'),      ('voler', 'present', 1, 'vols'),      ('voler', 'present', 2, 'vol'),
('voler', 'present', 3, 'volem'),     ('voler', 'present', 4, 'voleu'),     ('voler', 'present', 5, 'volen'),
('voler', 'passat',  0, 'vaig voler'),('voler', 'passat',  1, 'vas voler'), ('voler', 'passat',  2, 'va voler'),
('voler', 'passat',  3, 'vam voler'), ('voler', 'passat',  4, 'vau voler'), ('voler', 'passat',  5, 'van voler'),
('voler', 'futur',   0, 'voldré'),    ('voler', 'futur',   1, 'voldràs'),   ('voler', 'futur',   2, 'voldrà'),
('voler', 'futur',   3, 'voldrem'),   ('voler', 'futur',   4, 'voldreu'),   ('voler', 'futur',   5, 'voldran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- poder
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('poder', 'present', 0, 'puc'),       ('poder', 'present', 1, 'pots'),      ('poder', 'present', 2, 'pot'),
('poder', 'present', 3, 'podem'),     ('poder', 'present', 4, 'podeu'),     ('poder', 'present', 5, 'poden'),
('poder', 'passat',  0, 'vaig poder'),('poder', 'passat',  1, 'vas poder'), ('poder', 'passat',  2, 'va poder'),
('poder', 'passat',  3, 'vam poder'), ('poder', 'passat',  4, 'vau poder'), ('poder', 'passat',  5, 'van poder'),
('poder', 'futur',   0, 'podré'),     ('poder', 'futur',   1, 'podràs'),    ('poder', 'futur',   2, 'podrà'),
('poder', 'futur',   3, 'podrem'),    ('poder', 'futur',   4, 'podreu'),    ('poder', 'futur',   5, 'podran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- dir
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('dir', 'present', 0, 'dic'),      ('dir', 'present', 1, 'dius'),     ('dir', 'present', 2, 'diu'),
('dir', 'present', 3, 'diem'),     ('dir', 'present', 4, 'dieu'),     ('dir', 'present', 5, 'diuen'),
('dir', 'passat',  0, 'vaig dir'), ('dir', 'passat',  1, 'vas dir'),  ('dir', 'passat',  2, 'va dir'),
('dir', 'passat',  3, 'vam dir'),  ('dir', 'passat',  4, 'vau dir'),  ('dir', 'passat',  5, 'van dir'),
('dir', 'futur',   0, 'diré'),     ('dir', 'futur',   1, 'diràs'),    ('dir', 'futur',   2, 'dirà'),
('dir', 'futur',   3, 'direm'),    ('dir', 'futur',   4, 'direu'),    ('dir', 'futur',   5, 'diran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- saber
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('saber', 'present', 0, 'sé'),        ('saber', 'present', 1, 'saps'),      ('saber', 'present', 2, 'sap'),
('saber', 'present', 3, 'sabem'),     ('saber', 'present', 4, 'sabeu'),     ('saber', 'present', 5, 'saben'),
('saber', 'passat',  0, 'vaig saber'),('saber', 'passat',  1, 'vas saber'), ('saber', 'passat',  2, 'va saber'),
('saber', 'passat',  3, 'vam saber'), ('saber', 'passat',  4, 'vau saber'), ('saber', 'passat',  5, 'van saber'),
('saber', 'futur',   0, 'sabré'),     ('saber', 'futur',   1, 'sabràs'),    ('saber', 'futur',   2, 'sabrà'),
('saber', 'futur',   3, 'sabrem'),    ('saber', 'futur',   4, 'sabreu'),    ('saber', 'futur',   5, 'sabran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- viure
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('viure', 'present', 0, 'visc'),       ('viure', 'present', 1, 'vius'),      ('viure', 'present', 2, 'viu'),
('viure', 'present', 3, 'vivim'),      ('viure', 'present', 4, 'viviu'),     ('viure', 'present', 5, 'viuen'),
('viure', 'passat',  0, 'vaig viure'), ('viure', 'passat',  1, 'vas viure'), ('viure', 'passat',  2, 'va viure'),
('viure', 'passat',  3, 'vam viure'),  ('viure', 'passat',  4, 'vau viure'), ('viure', 'passat',  5, 'van viure'),
('viure', 'futur',   0, 'viuré'),      ('viure', 'futur',   1, 'viuràs'),    ('viure', 'futur',   2, 'viurà'),
('viure', 'futur',   3, 'viurem'),     ('viure', 'futur',   4, 'viureu'),    ('viure', 'futur',   5, 'viuran')
ON CONFLICT (verb_id, tense, pronoun_index) DO UPDATE SET form = EXCLUDED.form;

-- ========== SENTENCES ==========

-- ser
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('ser', 'present', 0, 'Sóc francès.',               'Je suis français.'),
('ser', 'present', 2, 'Ell és molt simpàtic.',       'Il est très sympa.'),
('ser', 'present', 3, 'Som de França.',              'Nous sommes de France.'),
('ser', 'present', 5, 'Són a l''escola.',            'Ils sont à l''école.'),
('ser', 'passat',  0, 'Vaig ser el primer.',         'J''ai été le premier.'),
('ser', 'futur',   2, 'Serà un bon dia.',            'Ce sera une bonne journée.');

-- estar
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('estar', 'present', 0, 'Estic content.',                    'Je suis content.'),
('estar', 'present', 0, 'Estic cansat.',                     'Je suis fatigué.'),
('estar', 'present', 1, 'Estàs bé?',                         'Tu vas bien ?'),
('estar', 'present', 2, 'Està ploguent.',                     'Il pleut.'),
('estar', 'present', 3, 'Estem aprenent català.',             'Nous apprenons le catalan.'),
('estar', 'passat',  2, 'Va estar malalt una setmana.',       'Il a été malade une semaine.');

-- tenir
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('tenir', 'present', 0, 'Tinc fam.',       'J''ai faim.'),
('tenir', 'present', 0, 'Tinc un fill.',   'J''ai un fils.'),
('tenir', 'present', 1, 'Tens raó.',       'Tu as raison.'),
('tenir', 'present', 2, 'Té tres anys.',   'Il a trois ans.'),
('tenir', 'present', 0, 'Tinc set.',       'J''ai soif.'),
('tenir', 'present', 3, 'Tenim temps.',    'Nous avons le temps.');

-- fer
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('fer', 'present', 2, 'Avui fa molt de sol.',      'Aujourd''hui il fait très beau.'),
('fer', 'present', 0, 'Faig feina a casa.',         'Je travaille à la maison.'),
('fer', 'present', 1, 'Què fas?',                   'Qu''est-ce que tu fais ?'),
('fer', 'present', 3, 'Fem un cafè?',               'On prend un café ?'),
('fer', 'passat',  0, 'Vaig fer una passejada.',     'J''ai fait une promenade.'),
('fer', 'futur',   2, 'Farà bon temps demà.',        'Il fera beau demain.');

-- anar
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('anar', 'present', 0, 'Vaig a la platja.',            'Je vais à la plage.'),
('anar', 'present', 3, 'Anem al mercat.',               'Nous allons au marché.'),
('anar', 'present', 2, 'Va a l''escola cada dia.',      'Il va à l''école chaque jour.'),
('anar', 'present', 1, 'On vas?',                       'Où tu vas ?'),
('anar', 'passat',  0, 'Vaig anar al port ahir.',       'Je suis allé au port hier.'),
('anar', 'futur',   3, 'Anirem a Palma dissabte.',      'Nous irons à Palma samedi.');

-- parlar
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('parlar', 'present', 0, 'Parlo una mica de català.',       'Je parle un peu catalan.'),
('parlar', 'present', 1, 'Parles francès?',                  'Tu parles français ?'),
('parlar', 'present', 2, 'Parla massa ràpid.',               'Il parle trop vite.'),
('parlar', 'present', 3, 'Parlem demà.',                     'On en parle demain.'),
('parlar', 'passat',  0, 'Vaig parlar amb el veí.',          'J''ai parlé avec le voisin.'),
('parlar', 'futur',   0, 'Parlaré millor d''aquí un any.',  'Je parlerai mieux dans un an.');

-- menjar
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('menjar', 'present', 3, 'Mengem a les dues.',           'Nous mangeons à deux heures.'),
('menjar', 'present', 1, 'Què menges?',                   'Qu''est-ce que tu manges ?'),
('menjar', 'present', 0, 'Menjo pa amb tomàquet.',         'Je mange du pain à la tomate.'),
('menjar', 'present', 2, 'Menja molt bé aquí.',           'On mange très bien ici.'),
('menjar', 'passat',  0, 'Vaig menjar paella ahir.',      'J''ai mangé de la paella hier.'),
('menjar', 'futur',   3, 'Menjarem fora dissabte.',       'Nous mangerons dehors samedi.');

-- voler
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('voler', 'present', 0, 'Vull un cafè, si us plau.',     'Je veux un café, s''il vous plaît.'),
('voler', 'present', 1, 'Vols venir?',                    'Tu veux venir ?'),
('voler', 'present', 1, 'Què vols fer?',                  'Qu''est-ce que tu veux faire ?'),
('voler', 'present', 3, 'Volem aprendre català.',          'Nous voulons apprendre le catalan.'),
('voler', 'present', 2, 'No vol menjar.',                  'Il ne veut pas manger.'),
('voler', 'futur',   0, 'Voldré anar-hi demà.',           'Je voudrai y aller demain.');

-- poder
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('poder', 'present', 0, 'No puc anar-hi avui.',           'Je ne peux pas y aller aujourd''hui.'),
('poder', 'present', 1, 'Pots ajudar-me?',                'Tu peux m''aider ?'),
('poder', 'present', 3, 'Podem quedar demà.',              'On peut se voir demain.'),
('poder', 'present', 2, 'No pot venir.',                   'Il ne peut pas venir.'),
('poder', 'present', 1, 'Pots repetir, si us plau?',      'Tu peux répéter, s''il te plaît ?'),
('poder', 'passat',  0, 'Vaig poder acabar a temps.',      'J''ai pu finir à temps.');

-- dir
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('dir', 'present', 2, 'Què diu?',                      'Qu''est-ce qu''il dit ?'),
('dir', 'present', 0, 'Em dic Dam.',                    'Je m''appelle Dam.'),
('dir', 'present', 1, 'Com dius?',                      'Comment tu t''appelles ?'),
('dir', 'present', 5, 'Diuen que farà bon temps.',      'Ils disent qu''il fera beau.'),
('dir', 'passat',  0, 'Vaig dir que sí.',               'J''ai dit oui.'),
('dir', 'futur',   0, 'Li diré demà.',                  'Je lui dirai demain.');

-- saber
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('saber', 'present', 0, 'No ho sé.',                     'Je ne sais pas.'),
('saber', 'present', 1, 'Saps on és?',                   'Tu sais où c''est ?'),
('saber', 'present', 1, 'Saps parlar català?',            'Tu sais parler catalan ?'),
('saber', 'present', 2, 'Ell sap cuinar molt bé.',       'Il sait très bien cuisiner.'),
('saber', 'futur',   0, 'Ja ho sabré.',                   'Je le saurai.'),
('saber', 'passat',  0, 'Ho vaig saber ahir.',            'Je l''ai su hier.');

-- viure
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('viure', 'present', 0, 'Visc a Alcúdia.',                                  'J''habite à Alcúdia.'),
('viure', 'present', 1, 'On vius?',                                          'Tu habites où ?'),
('viure', 'present', 3, 'Vivim a Mallorca des de fa un temps.',              'Nous vivons à Majorque depuis un moment.'),
('viure', 'present', 2, 'Viu a prop de l''escola.',                          'Il habite près de l''école.'),
('viure', 'passat',  0, 'Vaig viure a París.',                               'J''ai vécu à Paris.'),
('viure', 'futur',   3, 'Viurem aquí molt de temps.',                        'Nous vivrons ici longtemps.');
