-- Verify freeChat:token_type on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'token_type'));
END $$;

ROLLBACK;
