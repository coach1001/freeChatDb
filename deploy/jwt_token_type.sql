-- Deploy freeChat:jwt_token_type to pg

BEGIN;

CREATE TYPE membership.jwt_token AS(token text);

COMMIT;
