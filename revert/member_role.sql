-- Revert freeChat:member_role from pg

BEGIN;

DROP ROLE IF EXISTS member;

COMMIT;
