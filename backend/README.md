# Catala Backend

Lightweight Postgres backend for serving verb content to the iOS app.

## Setup (Supabase)

1. Create a new Supabase project
2. Run the SQL files in order:

```bash
# In Supabase SQL Editor:
# 1. Run backend/sql/001_schema.sql
# 2. Run backend/sql/002_seed.sql
# 3. Run backend/api/get-verbs.sql
```

3. The API is auto-exposed at:
```
GET https://<project>.supabase.co/rest/v1/rpc/get_verbs
```

Add your Supabase `anon` key as the `apikey` header.

## Setup (Standalone Postgres)

```bash
psql -d catala -f backend/sql/001_schema.sql
psql -d catala -f backend/sql/002_seed.sql
psql -d catala -f backend/api/get-verbs.sql
```

Then call the function from any backend framework:
```sql
SELECT get_verbs();
```

## ETag Caching

The `version` field in the response contains the latest `updated_at` timestamp.
Use this as an ETag in your API layer:

```
ETag: "2026-04-04T12:00:00Z"
If-None-Match: "2026-04-04T12:00:00Z" → 304 Not Modified
```

## Adding a New Verb

```sql
-- 1. Add the verb
INSERT INTO verbs (id, ca, fr, "group", sort_order)
VALUES ('dormir', 'Dormir', 'Dormir', '3e (-ir)', 13);

-- 2. Add 18 conjugations (6 pronouns × 3 tenses)
INSERT INTO conjugations (verb_id, tense, pronoun_index, form) VALUES
('dormir', 'present', 0, 'dormo'), ('dormir', 'present', 1, 'dorms'), ...

-- 3. Add example sentences
INSERT INTO sentences (verb_id, tense, pronoun_index, ca, fr) VALUES
('dormir', 'present', 0, 'Dormo vuit hores.', 'Je dors huit heures.'), ...
```

The iOS app picks up new verbs on next launch. No app update needed.
