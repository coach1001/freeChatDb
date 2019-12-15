-- Revert freeChat:user_role_function from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.user_role(text, text) CASCADE;

COMMIT;
