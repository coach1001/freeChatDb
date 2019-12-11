-- Revert freeChat:jwt_token_type from pg

BEGIN;

DROP TYPE IF EXISTS  membership.jwt_token;

COMMIT;
