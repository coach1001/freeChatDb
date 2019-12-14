-- Deploy freeChat:member_role to pg

BEGIN;

DO $$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = 'member') THEN
      CREATE ROLE member NOINHERIT;
   END IF;
END $$;


COMMIT;
