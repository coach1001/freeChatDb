-- Revert freeChat:email_status_type from pg

BEGIN;

DROP TYPE IF EXISTS  membership.email_status;

COMMIT;
