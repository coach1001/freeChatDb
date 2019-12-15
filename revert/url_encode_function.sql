-- Revert freeChat:url_encode_function from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.url_encode(data bytea) CASCADE;

COMMIT;
