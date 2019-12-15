-- Deploy freeChat:tokens_table to pg

BEGIN;

CREATE TABLE membership.tokens(


	id uuid NOT NULL DEFAULT uuid_generate_v4(),
	account uuid references membership.accounts(id) ON DELETE SET NULL NOT NULL,
	token_type membership.token_type NOT NULL DEFAULT 'validation',
	expires_at TIMESTAMPTZ NOT NULL,
	token text NOT NULL,
	redeemed boolean NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

	CONSTRAINT pk_membership_tokens PRIMARY KEY (id)

);

CREATE TRIGGER tg_membership_tokens_set_timestamp
BEFORE UPDATE ON membership.tokens
FOR EACH ROW
EXECUTE PROCEDURE tg_set_timestamp();

COMMIT;
