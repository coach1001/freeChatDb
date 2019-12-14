-- Revert freeChat:algorithm_sign_function from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.algorithm_sign(text, text, text);

COMMIT;
