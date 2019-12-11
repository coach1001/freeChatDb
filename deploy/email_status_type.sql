-- Deploy freeChat:email_status_type to pg

BEGIN;

CREATE TYPE membership.email_status AS  ENUM ('PROCESSING','AWAITING_RETRY','SENT','FAILED','AWAITING');

COMMIT;
