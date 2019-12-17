-- Deploy freeChat:anon_permissions to pg

BEGIN;

GRANT USAGE ON SCHEMA api, membership TO anon;
GRANT SELECT ON TABLE pg_authid TO anon;
GRANT SELECT, INSERT, UPDATE ON TABLE membership.accounts TO anon;
GRANT SELECT, INSERT, UPDATE ON TABLE membership.tokens TO anon;
GRANT SELECT, INSERT ON TABLE membership.emails TO anon;
GRANT SELECT ON TABLE membership.email_templates TO anon;

GRANT EXECUTE ON FUNCTION 
	api.sign_in(
		character varying,
		character varying
	) TO anon;

GRANT EXECUTE ON FUNCTION 
	api.sign_up(
		character varying,
		character varying,
		character varying,
		character varying,
		character varying
	) TO anon;

GRANT EXECUTE ON FUNCTION 
	api.request_reset_password(
		character varying
	) TO anon;

GRANT EXECUTE ON FUNCTION 
	api.reset_password(
		character varying,
		character varying,
		character varying,
		character varying
	) TO anon;

GRANT EXECUTE ON FUNCTION 
	api.validate_account(
		character varying,
		character varying
	) TO anon;

COMMIT;
