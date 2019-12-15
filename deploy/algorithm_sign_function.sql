-- Deploy freeChat:algorithm_sign_function to pg

BEGIN;

CREATE FUNCTION membership.algorithm_sign(signables text, secret text, algorithm text)
	RETURNS text
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$
WITH
  	alg AS (
    	SELECT 
			CASE
      			WHEN algorithm = 'HS256' THEN 'sha256'
      			WHEN algorithm = 'HS384' THEN 'sha384'
      			WHEN algorithm = 'HS512' THEN 'sha512'
      		ELSE '' END AS id)  -- hmac throws error
	SELECT membership.url_encode(membership.hmac(signables, secret, alg.id)) FROM alg;
$$;

COMMIT;
