-- Deploy freeChat:pgcrypto_extension to pg

BEGIN;

CREATE EXTENSION pgcrypto WITH SCHEMA membership;

COMMIT;
