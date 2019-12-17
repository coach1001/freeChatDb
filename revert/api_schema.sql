-- Revert freeChat:api_schema from pg

BEGIN;

DROP SCHEMA api CASCADE;

COMMIT;
