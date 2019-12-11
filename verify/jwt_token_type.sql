-- Verify freeChat:jwt_token_type on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'jwt_token'));
END $$;

ROLLBACK;
