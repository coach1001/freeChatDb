-- Deploy freeChat:token_type to pg

BEGIN;

CREATE TYPE membership.token_type AS ENUM ('validation','reset_password');

COMMIT;
