-- Revert freeChat:url_decode_function from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.url_decode(data text) CASCADE;

COMMIT;
