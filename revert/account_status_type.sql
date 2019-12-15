-- Revert freeChat:account_status_type from pg

BEGIN;

DROP TYPE IF EXISTS  membership.account_status CASCADE;

COMMIT;
