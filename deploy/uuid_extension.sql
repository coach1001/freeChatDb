-- Deploy freeChat:uuid_extension to pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

COMMIT;
