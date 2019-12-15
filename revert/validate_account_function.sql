-- Revert freeChat:validate_account_function from pg

BEGIN;

DROP FUNCTION IF EXISTS public.validate_account(character varying, character varying) CASCADE;

COMMIT;
