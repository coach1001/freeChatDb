-- Deploy freeChat:reset_password_function to pg

BEGIN;

CREATE FUNCTION api.reset_password (
    _email_address character varying,
    _password character varying,
    _confirm_password character varying,
    _token character varying)
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
	_account_status membership.account_status;
BEGIN

	IF _password <> _confirm_password THEN
		RAISE EXCEPTION 'password do not match';
	END IF;

	SELECT id, status INTO _account_id, _account_status
	FROM membership.accounts 
	WHERE email_address = _email_address LIMIT 1; 

	IF _account_id IS NULL OR _account_status::text <> 'activated' THEN
		RAISE EXCEPTION 'something went wrong';
	END IF;

	SELECT id, token, expires_at INTO _token_id, __token, _expires_at
	FROM membership.tokens 
	WHERE account = _account_id AND token_type = 'reset_password' AND redeemed = false
	ORDER BY id DESC LIMIT 1;

	IF __token IS NULL THEN
		RAISE EXCEPTION 'invalid reset token';	
	ELSIF _token = __token AND current_timestamp > _expires_at THEN
		RAISE EXCEPTION 'token expired';								
	ELSIF _token = __token AND current_timestamp < _expires_at THEN		
		UPDATE membership.accounts SET _password_ = _password
		WHERE id = _account_id;

		UPDATE membership.tokens SET redeemed = true
		WHERE id = _token_id;
	ELSE		
		RAISE EXCEPTION 'something went wrong with resetting your password';
	END IF;
    
END;
$$;

COMMIT;
