-- Revert freeChat:membership_schema from pg

BEGIN;

DROP SCHEMA membership CASCADE;

COMMIT;
