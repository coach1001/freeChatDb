-- Revert freeChat:verify_function from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.verify(text, text, text) CASCADE;

COMMIT;
