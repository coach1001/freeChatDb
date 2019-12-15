-- Deploy freeChat:check_if_role_exists_trigger to pg

BEGIN;

CREATE FUNCTION membership.tg_check_if_role_exists()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	STRICT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN	
	IF NOT EXISTS (SELECT 1 FROM pg_roles AS r WHERE r.rolname::text = new.role::text) THEN
        RAISE foreign_key_violation USING message = 'unknown role' || new.role;
    	RETURN NULL;
	END IF;
  	RETURN new;
END;
$$;

CREATE TRIGGER tg_membership_accounts_check_if_role_exists
AFTER INSERT OR UPDATE
ON membership.accounts
FOR EACH ROW
EXECUTE PROCEDURE membership.tg_check_if_role_exists();

COMMIT;
