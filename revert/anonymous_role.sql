-- Revert freeChat:anonymous_role from pg

BEGIN;

DROP ROLE IF EXISTS anon;

COMMIT;
