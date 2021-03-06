-- Deploy freeChat:sign_up_function to pg

BEGIN;

CREATE FUNCTION api.sign_up (
	_email_address character varying(255),
	_password character varying(255),
	_confirm_password character varying(255),
	_first_name character varying(255), 
	_last_name character varying(255))
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	STRICT
	SECURITY INVOKER
	COST 1
	AS $$
DECLARE
	_validate_email_template_id uuid;
	_token_data membership.tokens%ROWTYPE;
	_account_id uuid;
	_otp_size text;
	_otp_fm text;
BEGIN
	_otp_size := '';
	_otp_fm := 'fm';

	FOR i IN 1..current_setting('app.settings.otp_size')::integer LOOP
		_otp_size := _otp_size || '9';
		_otp_fm := _otp_fm || '0';
  	END LOOP;

	IF _password <> _confirm_password THEN
		RAISE EXCEPTION 'password do not match';
	ELSE

		INSERT INTO membership.accounts(email_address, _password_, first_name, last_name)
	    VALUES (_email_address, _password, _first_name, _last_name)
		RETURNING id INTO _account_id;

		INSERT INTO membership.tokens(account, token_type, expires_at, token)
		VALUES (
			_account_id,
			'validation',
			current_timestamp + (current_setting('app.settings.otp_lifetime_minutes')::integer * interval '1 minute'),
			to_char(floor(random() * (_otp_size)::integer + 1)::integer, _otp_fm)
		)
		RETURNING * INTO _token_data;

		SELECT id INTO _validate_email_template_id 
		FROM membership.email_templates 
		WHERE token_type='validation' AND active=true LIMIT 1;

		INSERT INTO membership.emails(email_template, _from_,  _to_, doc_tokens, email_status)
		VALUES ( 
			_validate_email_template_id, 
			current_setting('app.settings.app_admin_email'),
			_email_address,
			jsonb_build_object(
				'emailAddress', _email_address,
				'firstName', _first_name,
				'lastName', _last_name,
				'appName', current_setting('app.settings.app_name'),
				'token', _token_data.token,
				'tokenExpiry', _token_data.expires_at::text
			),
			'awaiting'
		);

	END IF;
	
END;
$$;

COMMIT;
