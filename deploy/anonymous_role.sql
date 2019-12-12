-- Deploy freeChat:anonymous_role to pg

BEGIN;

DO $$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = 'anon') THEN
      CREATE ROLE anon NOINHERIT;
   END IF;
END $$;

COMMIT;
