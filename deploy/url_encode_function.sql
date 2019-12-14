-- Deploy freeChat:url_encode_function to pg

BEGIN;

CREATE FUNCTION membership.url_encode(data bytea)
	RETURNS text
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$
    SELECT translate(encode(data, 'base64'), E'+/=\n', '-_');
$$;

COMMIT;
