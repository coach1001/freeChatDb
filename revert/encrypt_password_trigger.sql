-- Revert freeChat:encrypt_password_trigger from pg

BEGIN;

DROP FUNCTION IF EXISTS membership.tg_encrypt_password() CASCADE;

COMMIT;
