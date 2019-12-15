-- Revert freeChat:check_if_role_exists_trigger from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.tg_check_if_role_exists() CASCADE;

COMMIT;
