-- Revert freeChat:email_templates_table from pg

BEGIN;

DROP TABLE membership.email_templates CASCADE;

COMMIT;
