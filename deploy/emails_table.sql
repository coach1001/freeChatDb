-- Deploy freeChat:emails_table to pg

BEGIN;

CREATE TABLE membership.emails(

    id uuid NOT NULL DEFAULT uuid_generate_v4(),
	email_template uuid references membership.email_templates(id) ON DELETE SET NULL NOT NULL,
	_from_ character varying(255) NOT NULL,
	_to_ character varying(255) NOT NULL,
	doc_tokens jsonb,
	retries smallint NOT NULL DEFAULT 0,
	email_status membership.email_status NOT NULL DEFAULT 'awaiting',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

	CONSTRAINT pk_membership_emails PRIMARY KEY (id)

);

CREATE TRIGGER tg_membership_emails_set_timestamp
BEFORE UPDATE ON membership.emails
FOR EACH ROW
EXECUTE PROCEDURE tg_set_timestamp();

COMMIT;
