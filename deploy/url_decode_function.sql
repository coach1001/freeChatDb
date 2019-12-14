-- Deploy freeChat:url_decode_function to pg

BEGIN;

CREATE FUNCTION membership.url_decode(data text)
	RETURNS bytea
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$
WITH t AS (SELECT translate(data, '-_', '+/') AS trans),
    rem AS (SELECT length(t.trans) % 4 AS remainder FROM t) -- compute padding size
    SELECT decode(
        t.trans ||
        CASE WHEN rem.remainder > 0
           THEN repeat('=', (4 - rem.remainder))
           ELSE '' END,
    'base64') FROM t, rem;
$$;

COMMIT;
