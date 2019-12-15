-- Revert freeChat:uuid_extension from pg

BEGIN;

DROP EXTENSION "uuid-ossp" CASCADE;

COMMIT;
