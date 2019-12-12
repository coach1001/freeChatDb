-- Deploy freeChat:account_status_type to pg

BEGIN;

CREATE TYPE membership.account_status AS ENUM ('not_activated','activated','banned');

COMMIT;
