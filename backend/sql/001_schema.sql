-- Catala Backend Schema
-- Run this against your Postgres database (Supabase, Neon, or local)

CREATE TABLE IF NOT EXISTS verbs (
    id          TEXT PRIMARY KEY,
    ca          TEXT NOT NULL,
    fr          TEXT NOT NULL,
    "group"     TEXT NOT NULL,
    sort_order  INTEGER NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS conjugations (
    id              SERIAL PRIMARY KEY,
    verb_id         TEXT NOT NULL REFERENCES verbs(id) ON DELETE CASCADE,
    tense           TEXT NOT NULL CHECK (tense IN ('present', 'passat', 'futur')),
    pronoun_index   INTEGER NOT NULL CHECK (pronoun_index BETWEEN 0 AND 5),
    form            TEXT NOT NULL,
    UNIQUE (verb_id, tense, pronoun_index)
);

CREATE TABLE IF NOT EXISTS sentences (
    id              SERIAL PRIMARY KEY,
    verb_id         TEXT NOT NULL REFERENCES verbs(id) ON DELETE CASCADE,
    tense           TEXT NOT NULL CHECK (tense IN ('present', 'passat', 'futur')),
    pronoun_index   INTEGER NOT NULL CHECK (pronoun_index BETWEEN 0 AND 5),
    ca              TEXT NOT NULL,
    fr              TEXT NOT NULL
);

-- Index for fast verb lookups
CREATE INDEX IF NOT EXISTS idx_conjugations_verb ON conjugations(verb_id);
CREATE INDEX IF NOT EXISTS idx_sentences_verb ON sentences(verb_id);

-- Trigger to auto-update updated_at on verbs
CREATE OR REPLACE FUNCTION update_verb_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE verbs SET updated_at = now() WHERE id = NEW.verb_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_conjugation_update ON conjugations;
CREATE TRIGGER trg_conjugation_update
    AFTER INSERT OR UPDATE ON conjugations
    FOR EACH ROW EXECUTE FUNCTION update_verb_timestamp();

DROP TRIGGER IF EXISTS trg_sentence_update ON sentences;
CREATE TRIGGER trg_sentence_update
    AFTER INSERT OR UPDATE ON sentences
    FOR EACH ROW EXECUTE FUNCTION update_verb_timestamp();
