-- Deploy freeChat:email_status_type to pg

BEGIN;

CREATE TYPE membership.email_status AS  ENUM ('processing','awaiting_retry','sent','failed','awaiting');

COMMIT;
