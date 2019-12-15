-- Revert freeChat:set_timestamp_trigger from pg

BEGIN;

DROP FUNCTION IF EXISTS tg_set_timestamp();

COMMIT;
