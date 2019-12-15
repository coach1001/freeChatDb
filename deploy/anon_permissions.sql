-- Deploy freeChat:anon_permissions to pg

BEGIN;

GRANT USAGE ON SCHEMA public, membership TO anon;
GRANT SELECT ON TABLE pg_authid TO anon;
GRANT SELECT, INSERT, UPDATE ON TABLE membership.accounts TO anon;
GRANT SELECT, INSERT, UPDATE ON TABLE membership.tokens TO anon;
GRANT SELECT, INSERT ON TABLE membership.emails TO anon;
GRANT SELECT ON TABLE membership.email_templates TO anon;

GRANT EXECUTE ON FUNCTION 
	public.sign_in(
		character varying,
		character varying
	) to anon;

GRANT EXECUTE ON FUNCTION 
	public.sign_up(
		character varying,
		character varying,
		character varying,
		character varying,
		character varying
	) to anon;

COMMIT;
