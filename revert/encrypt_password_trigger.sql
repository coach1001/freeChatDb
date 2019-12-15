-- Revert freeChat:encrypt_password_trigger from pg

BEGIN;

DROP TRIGGER tg_membership_accounts_encrypt_password on membership.accounts;
DROP FUNCTION IF EXISTS membership.tg_encrypt_password() CASCADE;

COMMIT;
