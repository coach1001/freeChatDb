-- Revert freeChat:authenticator_role from pg

BEGIN;

DROP ROLE IF EXISTS authenticator;

COMMIT;
