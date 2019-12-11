-- Verify freeChat:membership_schema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('membership', 'usage');

ROLLBACK;
