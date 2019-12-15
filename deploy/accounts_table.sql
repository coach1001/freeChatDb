-- Deploy freeChat:accounts_table to pg

BEGIN;

CREATE TABLE membership.accounts(

    id uuid NOT NULL DEFAULT uuid_generate_v4(),
	email_address character varying(255) NOT NULL,
	_password_ text NOT NULL,
	first_name character varying(255) NOT NULL,
	last_name character varying(255) NOT NULL,
    phone character varying(255),
	status membership.account_status NOT NULL DEFAULT 'not_activated',
	role membership.account_roles NOT NULL DEFAULT 'anon',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

	CONSTRAINT pk_membership_accounts PRIMARY KEY (id),
	CONSTRAINT uq_membership_accounts_email_address UNIQUE (email_address),
	CONSTRAINT ck_membership_accounts_email_address CHECK (email_address ~* '^.+@.+\..+$' )
);

CREATE TRIGGER tg_membership_accounts_set_timestamp
BEFORE UPDATE ON membership.accounts
FOR EACH ROW
EXECUTE PROCEDURE tg_set_timestamp();

COMMIT;
