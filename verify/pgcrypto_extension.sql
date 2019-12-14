-- Verify freeChat:pgcrypto_extension on pg

BEGIN;

DO $$
BEGIN
    ASSERT (SELECT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto'));
END $$;

ROLLBACK;
