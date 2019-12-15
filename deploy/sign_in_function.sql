-- Deploy freeChat:sign_in_function to pg

BEGIN;

CREATE FUNCTION public.sign_in (_email_address character varying(255), _password character varying(255))
	RETURNS membership.jwt_token
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY DEFINER
	COST 1
	AS $$
DECLARE
	_role name;
	_account_state text;
	_result membership.jwt_token;
	_account_id uuid;
	_first_name text;
	_last_name text;
BEGIN
	SELECT membership.user_role(_email_address, _password) INTO _role;
	
    SELECT status FROM membership.accounts
	WHERE email_address = _email_address INTO _account_state;		

	IF _role IS NULL THEN
    	RAISE invalid_password USING message = 'invalid email address or password';
	ELSIF _account_state = 'not_activated' THEN
		RAISE EXCEPTION 'account not validated';
	ELSIF _account_state = 'banned' THEN
		RAISE EXCEPTION 'account banned';
	ELSE
		SET search_path TO membership;
		SELECT id, first_name, last_name INTO _account_id, _first_name, _last_name FROM accounts WHERE email_address = _email_address ;
  		
        SELECT sign(row_to_json(r), current_setting('app.settings.jwt_secret')) 
		    AS token FROM (
	            SELECT _role AS role, _account_id AS account_id, sign_in._email_address AS email_address,
                extract(epoch FROM now())::integer + 60*60*current_setting('app.settings.jwt_lifetime_hours')::integer AS exp) r
	   	    INTO _result;
  		RETURN _result;	

	END IF;
END;
$$;

COMMIT;
