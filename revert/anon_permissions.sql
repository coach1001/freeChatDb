-- Revert freeChat:anon_permissions from pg

BEGIN;

REVOKE USAGE ON SCHEMA public, membership FROM anon;
REVOKE SELECT ON TABLE pg_authid FROM anon;
REVOKE SELECT, INSERT, UPDATE ON TABLE membership.accounts FROM anon;
REVOKE SELECT, INSERT, UPDATE ON TABLE membership.tokens FROM anon;
REVOKE SELECT, INSERT ON TABLE membership.emails FROM anon;
REVOKE SELECT ON TABLE membership.email_templates FROM anon;

REVOKE EXECUTE ON FUNCTION 
	public.sign_in(
		character varying,
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	public.sign_up(
		character varying,
		character varying,
		character varying,
		character varying,
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	public.request_reset_password(
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	public.reset_password(
		character varying,
		character varying,
		character varying,
		character varying
	) FROM anon;

REVOKE EXECUTE ON FUNCTION 
	public.validate_account(
		character varying,
		character varying
	) FROM anon;

COMMIT;
