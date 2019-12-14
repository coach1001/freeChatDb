-- Verify freeChat:member_role on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'member'));
END $$;


ROLLBACK;
