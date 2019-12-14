-- Deploy freeChat:pgcrypto_extension to pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA membership;

COMMIT;
