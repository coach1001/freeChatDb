-- Deploy freeChat:account_status_type to pg

BEGIN;

CREATE TYPE membership.account_status AS ENUM ('NOT_ACTIVATED','ACTIVATED','BANNED');

COMMIT;
