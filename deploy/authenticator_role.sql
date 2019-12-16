-- Deploy freeChat:authenticator_role to pg

BEGIN;

DO $$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = 'authenticator') THEN
      CREATE ROLE authenticator WITH LOGIN PASSWORD 'P0wfYsojI1niIxra' NOINHERIT;
      GRANT anon TO authenticator;
   END IF;
END $$;

COMMIT;
