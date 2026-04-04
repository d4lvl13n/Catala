-- Supabase: Create this as a Postgres function, then expose via PostgREST RPC
-- Call via: GET /rest/v1/rpc/get_verbs

CREATE OR REPLACE FUNCTION get_verbs()
RETURNS JSON AS $$
DECLARE
    result JSON;
    latest_update TIMESTAMPTZ;
BEGIN
    -- Get latest update timestamp for ETag
    SELECT MAX(updated_at) INTO latest_update FROM verbs;

    SELECT json_build_object(
        'verbs', (
            SELECT json_agg(
                json_build_object(
                    'id', v.id,
                    'ca', v.ca,
                    'fr', v.fr,
                    'group', v."group",
                    'tenses', (
                        SELECT json_object_agg(
                            tense,
                            forms ORDER BY tense
                        )
                        FROM (
                            SELECT
                                c.tense,
                                json_agg(c.form ORDER BY c.pronoun_index) AS forms
                            FROM conjugations c
                            WHERE c.verb_id = v.id
                            GROUP BY c.tense
                        ) t
                    ),
                    'sentences', (
                        SELECT COALESCE(json_agg(
                            json_build_object(
                                'tense', s.tense,
                                'pronounIndex', s.pronoun_index,
                                'ca', s.ca,
                                'fr', s.fr
                            )
                        ), '[]'::json)
                        FROM sentences s
                        WHERE s.verb_id = v.id
                    )
                )
                ORDER BY v.sort_order
            )
            FROM verbs v
        ),
        'version', latest_update
    ) INTO result;

    RETURN result;
END;
$$ LANGUAGE plpgsql STABLE;
