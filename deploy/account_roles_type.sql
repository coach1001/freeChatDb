-- Deploy freeChat:account_roles_type to pg

BEGIN;

CREATE TYPE membership.account_roles AS ENUM ('anon','member');

COMMIT;
