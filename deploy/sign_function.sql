-- Deploy freeChat:sign_function to pg

BEGIN;

CREATE FUNCTION membership.sign(payload json, secret text, algorithm text DEFAULT 'HS256'::text)
	RETURNS text
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$
WITH
    header AS (SELECT  membership.url_encode(convert_to('{"alg":"' || algorithm || '","typ":"JWT"}', 'utf8')) AS data),
    payload AS (SELECT membership.url_encode(convert_to(payload::text, 'utf8')) AS data),
    signables AS (SELECT header.data || '.' || payload.data AS data FROM header, payload)
    SELECT signables.data || '.' || membership.algorithm_sign(signables.data, secret, algorithm) FROM signables;
$$;

COMMIT;
