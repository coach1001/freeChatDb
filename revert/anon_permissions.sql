-- Revert freeChat:anon_permissions from pg

BEGIN;

REVOKE USAGE ON SCHEMA api, membership FROM anon;
REVOKE SELECT ON TABLE pg_authid FROM anon;
REVOKE SELECT, INSERT, UPDATE ON TABLE membership.accounts FROM anon;
REVOKE SELECT, INSERT, UPDATE ON TABLE membership.tokens FROM anon;
REVOKE SELECT, INSERT ON TABLE membership.emails FROM anon;
REVOKE SELECT ON TABLE membership.email_templates FROM anon;

REVOKE EXECUTE ON FUNCTION 
	api.sign_in(
		character varying,
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	api.sign_up(
		character varying,
		character varying,
		character varying,
		character varying,
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	api.request_reset_password(
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	api.reset_password(
		character varying,
		character varying,
		character varying,
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	api.validate_account(
		character varying,
		character varying
	) FROM anon;

COMMIT;
