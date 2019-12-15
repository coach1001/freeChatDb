-- Revert freeChat:sign_in_function from pg

BEGIN;

DROP FUNCTION IF EXISTS public.sign_in(character varying(255), character varying(255)) CASCADE;

COMMIT;
