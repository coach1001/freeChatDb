-- Verify freeChat:account_roles_type on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'account_roles'));
END $$;

ROLLBACK;
