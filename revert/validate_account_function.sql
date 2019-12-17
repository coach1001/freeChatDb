-- Revert freeChat:validate_account_function from pg

BEGIN;

DROP FUNCTION IF EXISTS api.validate_account(character varying, character varying) CASCADE;

COMMIT;
