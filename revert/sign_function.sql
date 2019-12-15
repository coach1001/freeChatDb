-- Revert freeChat:sign_function from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.sign(json, text, text) CASCADE;

COMMIT;
