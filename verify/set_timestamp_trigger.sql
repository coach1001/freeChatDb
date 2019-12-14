-- Verify freeChat:set_timestamp_trigger on pg

BEGIN;

DROP FUNCTION IF EXISTS tg_set_timestamp();

ROLLBACK;
