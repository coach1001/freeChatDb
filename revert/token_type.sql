-- Revert freeChat:token_type from pg

BEGIN;

DROP TYPE IF EXISTS  membership.token_type CASCADE;

COMMIT;
