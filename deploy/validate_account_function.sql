-- Deploy freeChat:validate_account_function to pg

BEGIN;

CREATE FUNCTION public.validate_account(_email_address character varying, _token character varying)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
DECLARE
	_account_id uuid;
	_token_id uuid;	
	__token character varying;		
	_expires_at TIMESTAMPTZ;
BEGIN
	SELECT id INTO _account_id FROM membership.accounts 
	WHERE email_address = _email_address LIMIT 1; 

	IF _account_id IS NULL THEN
		RAISE EXCEPTION 'account does not exist';	
	END IF;

	SELECT id, token, expires_at INTO _token_id, __token, _expires_at
	FROM membership.tokens 
	WHERE account = _account_id AND token_type = 'validation' AND redeemed = false
	ORDER BY id DESC LIMIT 1;

	IF __token IS NULL THEN
		RAISE EXCEPTION 'invalid validation token';	
	ELSIF _token = __token AND current_timestamp > _expires_at THEN
		RAISE EXCEPTION 'token expired';								
	ELSIF _token = __token AND current_timestamp < _expires_at THEN		
		UPDATE membership.accounts SET status = 'activated', role = 'member'
		WHERE id = _account_id;		

		UPDATE membership.tokens SET redeemed = true
		WHERE id = _token_id;
	ELSE		
		RAISE EXCEPTION 'something went wrong with validating your account';
	END IF;
END;
$$;

COMMIT;
