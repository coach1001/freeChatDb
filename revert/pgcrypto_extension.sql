-- Revert freeChat:pgcrypto_extension from pg

BEGIN;

DROP EXTENSION pgcrypto;

COMMIT;
