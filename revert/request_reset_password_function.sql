-- Revert freeChat:request_reset_password_function from pg

BEGIN;

DROP FUNCTION IF EXISTS api.request_reset_password (character varying) CASCADE;

COMMIT;
