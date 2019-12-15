-- Revert freeChat:accounts_table from pg

BEGIN;

DROP TABLE membership.accounts;

COMMIT;
