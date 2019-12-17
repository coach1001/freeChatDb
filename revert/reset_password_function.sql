-- Revert freeChat:reset_password_function from pg

BEGIN;

DROP FUNCTION IF EXISTS api.reset_password (
    character varying,
    character varying,
    character varying,
    character varying
) CASCADE;

COMMIT;
