-- Revert freeChat:account_roles_type from pg

BEGIN;

DROP TYPE IF EXISTS  membership.account_roles CASCADE;

COMMIT;
