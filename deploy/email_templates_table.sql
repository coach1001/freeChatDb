-- Deploy freeChat:email_templates_table to pg

BEGIN;

CREATE TABLE membership.email_templates(

    id uuid NOT NULL DEFAULT uuid_generate_v4(),
	token_type membership.token_type NOT NULL,
	subject character varying(255) NOT NULL,
	body text NOT NULL,
    active boolean NOT NULL DEFAULT false, 
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

	CONSTRAINT pk_membership_email_templates PRIMARY KEY (id)
);

CREATE TRIGGER tg_membership_email_templates_set_timestamp
BEFORE UPDATE ON membership.email_templates
FOR EACH ROW
EXECUTE PROCEDURE tg_set_timestamp();

COMMIT;
