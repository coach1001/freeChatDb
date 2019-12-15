-- Deploy freeChat:encrypt_password_trigger to pg

BEGIN;

CREATE FUNCTION membership.tg_encrypt_password ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	STRICT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN  
	IF TG_OP = 'INSERT' OR new._password_ <> old._password_ THEN
    	new._password_ = membership.crypt(new._password_, membership.gen_salt('bf'));
	END IF;
	RETURN new;
END;
$$;

CREATE TRIGGER tg_membership_accounts_encrypt_password
BEFORE INSERT OR UPDATE
ON membership.accounts
FOR EACH ROW
EXECUTE PROCEDURE membership.tg_encrypt_password();

COMMIT;
