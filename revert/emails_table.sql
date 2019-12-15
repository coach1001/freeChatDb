-- Revert freeChat:emails_table from pg

BEGIN;

DROP TABLE membership.emails;

COMMIT;
