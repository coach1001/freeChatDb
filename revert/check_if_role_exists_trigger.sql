-- Revert freeChat:check_if_role_exists_trigger from pg

BEGIN;

DROP TRIGGER tg_membership_accounts_check_if_role_exists on membership.accounts;
DROP FUNCTION IF EXISTS membership.tg_check_if_role_exists() CASCADE;

COMMIT;
