-- Verify freeChat:email_status_type on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'email_status'));
END $$;


ROLLBACK;
