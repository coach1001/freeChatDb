-- Revert freeChat:tokens_table from pg

BEGIN;

DROP TABLE membership.tokens CASCADE;

COMMIT;
