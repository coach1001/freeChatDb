-- Deploy freeChat:verify_function to pg

BEGIN;

CREATE FUNCTION membership.verify(token text, secret text, algorithm text DEFAULT 'HS256'::text)
	RETURNS TABLE (header json, payload json, valid boolean)
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	ROWS 1000
	AS $$
SELECT
    convert_from(membership.url_decode(r[1]), 'utf8')::json AS header,
    convert_from(membership.url_decode(r[2]), 'utf8')::json AS payload,
    r[3] = membership.algorithm_sign(r[1] || '.' || r[2], secret, algorithm) AS valid
    FROM regexp_split_to_array(token, '\.') r;
$$;

COMMIT;
