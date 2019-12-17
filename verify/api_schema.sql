-- Verify freeChat:api_schema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('api', 'usage');

ROLLBACK;
