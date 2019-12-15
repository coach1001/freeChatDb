-- Revert freeChat:reset_password_function from pg

BEGIN;

DROP FUNCTION IF EXISTS public.reset_password (
    character varying,
    character varying,
    character varying,
    character varying
) CASCADE;

COMMIT;
