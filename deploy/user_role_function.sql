-- Deploy freeChat:user_role_function to pg

BEGIN;

CREATE FUNCTION membership.user_role(_email_address text, _password text)
	RETURNS name
	LANGUAGE plpgsql
	VOLATILE 
	STRICT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	RETURN (
		SELECT ROLE FROM membership.accounts
		WHERE accounts.email_address = user_role._email_address
		AND 
		accounts._password_ = membership.crypt(user_role._password, accounts._password_));
END;
$$;

COMMIT;
