-- Revert freeChat:sign_up_function from pg

BEGIN;

DROP FUNCTION IF EXISTS api.sign_up(
    character varying(255),
	character varying(255),
	character varying(255),
	character varying(255), 
	character varying(255)) CASCADE;

COMMIT;
