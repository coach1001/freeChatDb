-- Database generated with pgModeler (PostgreSQL Database Modeler).

-- pgModeler  version: 0.9.1

-- PostgreSQL version: 10.0

-- Project Site: pgmodeler.io

-- Model Author: ---



SET check_function_bodies = false;

-- ddl-end --



-- object: web_anon | type: ROLE --

-- DROP ROLE IF EXISTS web_anon;


-- ############################ DONE
CREATE ROLE web_anon WITH 

	ENCRYPTED PASSWORD '********';

-- ddl-end --



-- object: authenticated_user | type: ROLE --

-- DROP ROLE IF EXISTS authenticated_user;

-- ############################ DONE
CREATE ROLE authenticated_user WITH 

	INHERIT

	ENCRYPTED PASSWORD '********';

-- ddl-end --



-- object: authenticator | type: ROLE --

-- DROP ROLE IF EXISTS authenticator;

-- ############################ DONE
CREATE ROLE authenticator WITH ;

-- ddl-end --


-- Database creation must be done outside a multicommand file.

-- These commands were put in this file only as a convenience.

-- -- object: test | type: DATABASE --

-- -- DROP DATABASE IF EXISTS test;

-- CREATE DATABASE test

-- 	ENCODING = 'UTF8'

-- 	LC_COLLATE = 'English_United States.1252'

-- 	LC_CTYPE = 'English_United States.1252'

-- 	TABLESPACE = pg_default

-- 	OWNER = postgres;

-- -- ddl-end --

-- 



-- object: authentication | type: SCHEMA --

-- DROP SCHEMA IF EXISTS authentication CASCADE;
-- ############################ DONE
CREATE SCHEMA authentication;

-- ddl-end --

ALTER SCHEMA authentication OWNER TO postgres;

-- ddl-end --



SET search_path TO pg_catalog,public,authentication;

-- ddl-end --



-- object: authentication.token_type | type: TYPE --

-- DROP TYPE IF EXISTS authentication.token_type CASCADE;

-- ############################ DONE
CREATE TYPE authentication.token_type AS

 ENUM ('validation','reset_password');

-- ddl-end --

ALTER TYPE authentication.token_type OWNER TO postgres;

-- ddl-end --



-- object: authentication.account_status | type: TYPE --

-- DROP TYPE IF EXISTS authentication.account_status CASCADE;

-- ############################ DONE
CREATE TYPE authentication.account_status AS

 ENUM ('not_activated','activated','banned');

-- ddl-end --

ALTER TYPE authentication.account_status OWNER TO postgres;

-- ddl-end --



-- object: authentication.tokens_id_seq | type: SEQUENCE --

-- DROP SEQUENCE IF EXISTS authentication.tokens_id_seq CASCADE;

-- ############################ DONE
CREATE SEQUENCE authentication.tokens_id_seq

	INCREMENT BY 1

	MINVALUE -9223372036854775808

	MAXVALUE 9223372036854775807

	START WITH 1

	CACHE 1

	NO CYCLE

	OWNED BY NONE;

-- ddl-end --



-- object: authentication.account_roles | type: TYPE --

-- DROP TYPE IF EXISTS authentication.account_roles CASCADE;

-- ############################ DONE
CREATE TYPE authentication.account_roles AS

 ENUM ('web_anon','authenticated_user');

-- ddl-end --

ALTER TYPE authentication.account_roles OWNER TO postgres;

-- ddl-end --



-- object: authentication.accounts_id_seq | type: SEQUENCE --

-- DROP SEQUENCE IF EXISTS authentication.accounts_id_seq CASCADE;

-- ############################ DONE
CREATE SEQUENCE authentication.accounts_id_seq

	INCREMENT BY 1

	MINVALUE -9223372036854775808

	MAXVALUE 9223372036854775807

	START WITH 1

	CACHE 1

	NO CYCLE

	OWNED BY NONE;

-- ddl-end --



-- object: authentication.email_templates_id_seq | type: SEQUENCE --

-- DROP SEQUENCE IF EXISTS authentication.email_templates_id_seq CASCADE;

-- ############################ DONE
CREATE SEQUENCE authentication.email_templates_id_seq

	INCREMENT BY 1

	MINVALUE -9223372036854775808

	MAXVALUE 9223372036854775807

	START WITH 1

	CACHE 1

	NO CYCLE

	OWNED BY NONE;

-- ddl-end --



-- object: authentication.email_status | type: TYPE --

-- DROP TYPE IF EXISTS authentication.email_status CASCADE;

-- ############################ DONE
CREATE TYPE authentication.email_status AS

 ENUM ('processing','awaiting_retry','sent','failed','awaiting');

-- ddl-end --

ALTER TYPE authentication.email_status OWNER TO postgres;

-- ddl-end --



-- object: authentication.outgoing_emails_id_seq | type: SEQUENCE --

-- DROP SEQUENCE IF EXISTS authentication.outgoing_emails_id_seq CASCADE;

-- ############################ DONE
CREATE SEQUENCE authentication.outgoing_emails_id_seq

	INCREMENT BY 1

	MINVALUE -9223372036854775808

	MAXVALUE 9223372036854775807

	START WITH 1

	CACHE 1

	NO CYCLE

	OWNED BY NONE;

-- ddl-end --



-- object: pgcrypto | type: EXTENSION --

-- DROP EXTENSION IF EXISTS pgcrypto CASCADE;

-- ############################ DONE
CREATE EXTENSION pgcrypto

      WITH SCHEMA authentication

      VERSION '1.3';

-- ddl-end --

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

-- ddl-end --



-- object: authentication.url_encode | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.url_encode(bytea) CASCADE;

-- ############################ DONE
CREATE FUNCTION authentication.url_encode ( data bytea)

	RETURNS text

	LANGUAGE sql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 100

	AS $$

    SELECT translate(encode(data, 'base64'), E'+/=\n', '-_');

$$;

-- ddl-end --

ALTER FUNCTION authentication.url_encode(bytea) OWNER TO postgres;

-- ddl-end --



-- object: authentication.url_decode | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.url_decode(text) CASCADE;

-- ############################ DONE
CREATE FUNCTION authentication.url_decode ( data text)

	RETURNS bytea

	LANGUAGE sql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 100

	AS $$



WITH t AS (SELECT translate(data, '-_', '+/') AS trans),

     rem AS (SELECT length(t.trans) % 4 AS remainder FROM t) -- compute padding size

    SELECT decode(

        t.trans ||

        CASE WHEN rem.remainder > 0

           THEN repeat('=', (4 - rem.remainder))

           ELSE '' END,

    'base64') FROM t, rem;



$$;

-- ddl-end --

ALTER FUNCTION authentication.url_decode(text) OWNER TO postgres;

-- ddl-end --



-- object: authentication.algorithm_sign | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.algorithm_sign(text,text,text) CASCADE;

-- ############################ DONE
CREATE FUNCTION authentication.algorithm_sign ( signables text,  secret text,  algorithm text)

	RETURNS text

	LANGUAGE sql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 100

	AS $$



WITH

  alg AS (

    SELECT CASE

      WHEN algorithm = 'HS256' THEN 'sha256'

      WHEN algorithm = 'HS384' THEN 'sha384'

      WHEN algorithm = 'HS512' THEN 'sha512'

      ELSE '' END AS id)  -- hmac throws error

SELECT authentication.url_encode(hmac(signables, secret, alg.id)) FROM alg;



$$;

-- ddl-end --

ALTER FUNCTION authentication.algorithm_sign(text,text,text) OWNER TO postgres;

-- ddl-end --



-- object: authentication.sign | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.sign(json,text,text) CASCADE;

-- ############################ DONE
CREATE FUNCTION authentication.sign ( payload json,  secret text,  algorithm text DEFAULT 'HS256'::text)

	RETURNS text

	LANGUAGE sql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 100

	AS $$



WITH

  header AS (

    SELECT  authentication.url_encode(convert_to('{"alg":"' || algorithm || '","typ":"JWT"}', 'utf8')) AS data

    ),

  payload AS (

    SELECT authentication.url_encode(convert_to(payload::text, 'utf8')) AS data

    ),

  signables AS (

    SELECT header.data || '.' || payload.data AS data FROM header, payload

    )

SELECT

    signables.data || '.' ||

    authentication.algorithm_sign(signables.data, secret, algorithm) FROM signables;



$$;

-- ddl-end --

ALTER FUNCTION authentication.sign(json,text,text) OWNER TO postgres;

-- ddl-end --



-- object: authentication.verify | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.verify(IN text,IN text,IN text) CASCADE;

CREATE FUNCTION authentication.verify (IN token text, IN secret text, IN algorithm text DEFAULT 'HS256'::text)

	RETURNS TABLE ( header json,  payload json,  valid boolean)

	LANGUAGE sql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 100

	ROWS 1000

	AS $$



  SELECT

    convert_from(authentication.url_decode(r[1]), 'utf8')::json AS header,

    convert_from(authentication.url_decode(r[2]), 'utf8')::json AS payload,

    r[3] = authentication.algorithm_sign(r[1] || '.' || r[2], secret, algorithm) AS valid

  FROM regexp_split_to_array(token, '\.') r;



$$;

-- ddl-end --

ALTER FUNCTION authentication.verify(IN text,IN text,IN text) OWNER TO postgres;

-- ddl-end --



-- object: public.sign_up | type: FUNCTION --

-- DROP FUNCTION IF EXISTS public.sign_up(IN character varying(255),IN character varying(255),IN character varying(255),IN character varying(255),IN character varying(255)) CASCADE;

CREATE FUNCTION public.sign_up (IN _email_address character varying(255), IN _password character varying(255), IN _confirm_password character varying(255), IN _first_name character varying(255), IN _last_name character varying(255))

	RETURNS void

	LANGUAGE plpgsql

	VOLATILE 

	STRICT

	SECURITY INVOKER

	COST 1

	AS $$

DECLARE

	_validate_email_template_id bigint;

	_token_data authentication.tokens%ROWTYPE;

	_account_id  bigint;

BEGIN

	IF _password <> _confirm_password THEN

		RAISE EXCEPTION 'PASSWORDS DO NOT MATCH';

	ELSE

		

		INSERT INTO authentication.accounts(email_address, _password_, first_name, last_name)

	    VALUES (_email_address, _password, _first_name, _last_name)

		RETURNING id INTO _account_id;



		INSERT INTO authentication.tokens(account, token_type, expires_at, token)

		VALUES (_account_id,'validation', current_timestamp + (current_setting('app.settings.otp_lifetime_minutes')::integer * interval '1 minute'),to_char(floor(random() * 9999 + 1)::int, 'fm0000')) 

		RETURNING * INTO _token_data;

	

		SELECT id INTO _validate_email_template_id 

		FROM authentication.email_templates 

		WHERE token_type='validation' LIMIT 1;



		INSERT INTO authentication.outgoing_emails(

			email_template, _from_,  _to_, doc_tokens, email_status)

		VALUES ( 

			_validate_email_template_id, 

			current_setting('app.settings.app_admin_email'),

			_email_address,

			jsonb_build_object(

				'emailAddress', _email_address,

				'firstName', _first_name,

				'lastName', _last_name,

				'appName', current_setting('app.settings.app_name'),

				'token', _token_data.token,

				'tokenExpiry', _token_data.expires_at::text

			),

			'awaiting'

		);		

	END IF;

END;

$$;

-- ddl-end --

ALTER FUNCTION public.sign_up(IN character varying(255),IN character varying(255),IN character varying(255),IN character varying(255),IN character varying(255)) OWNER TO postgres;

-- ddl-end --



-- object: authentication.jwt_token | type: TYPE --

-- DROP TYPE IF EXISTS authentication.jwt_token CASCADE;

CREATE TYPE authentication.jwt_token AS

(

  token text

);

-- ddl-end --

ALTER TYPE authentication.jwt_token OWNER TO postgres;

-- ddl-end --



-- object: authentication.check_if_role_exists | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.check_if_role_exists() CASCADE;

CREATE FUNCTION authentication.check_if_role_exists ()

	RETURNS trigger

	LANGUAGE plpgsql

	VOLATILE 

	STRICT

	SECURITY INVOKER

	COST 1

	AS $$

BEGIN	

	IF NOT EXISTS (SELECT 1 FROM pg_roles AS r WHERE r.rolname::text = new.role::text) THEN

    	RAISE foreign_key_violation USING message = 'UNKNOWN ROLE' || new.role;

    	RETURN null;

	END IF;

  	RETURN new;

END;



$$;

-- ddl-end --

ALTER FUNCTION authentication.check_if_role_exists() OWNER TO postgres;

-- ddl-end --



-- object: authentication.encrypt_password | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.encrypt_password() CASCADE;

CREATE FUNCTION authentication.encrypt_password ()

	RETURNS trigger

	LANGUAGE plpgsql

	VOLATILE 

	STRICT

	SECURITY INVOKER

	COST 1

	AS $$



BEGIN  

	IF TG_OP = 'INSERT' OR new._password_ <> old._password_ THEN

    	new._password_ = authentication.crypt(new._password_, authentication.gen_salt('bf'));

	END IF;

	RETURN new;

END;



$$;

-- ddl-end --

ALTER FUNCTION authentication.encrypt_password() OWNER TO postgres;

-- ddl-end --



-- object: authentication.user_role | type: FUNCTION --

-- DROP FUNCTION IF EXISTS authentication.user_role(IN text,IN text) CASCADE;

CREATE FUNCTION authentication.user_role (IN _email_address text, IN _password text)

	RETURNS name

	LANGUAGE plpgsql

	VOLATILE 

	STRICT

	SECURITY INVOKER

	COST 1

	AS $$

BEGIN

	RETURN (

		SELECT ROLE FROM authentication.accounts

		WHERE accounts.email_address = user_role._email_address

		AND 

		accounts._password_ = authentication.crypt(user_role._password, accounts._password_));

END;



$$;

-- ddl-end --

ALTER FUNCTION authentication.user_role(IN text,IN text) OWNER TO postgres;

-- ddl-end --



-- object: public.sign_in | type: FUNCTION --

-- DROP FUNCTION IF EXISTS public.sign_in(IN character varying(255),IN character varying(255)) CASCADE;

CREATE FUNCTION public.sign_in (IN _email_address character varying(255), IN _password character varying(255))

	RETURNS authentication.jwt_token

	LANGUAGE plpgsql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY DEFINER

	COST 1

	AS $$

DECLARE

	_role name;

	_account_state text;

	_result authentication.jwt_token;

	_account_id bigint;

	_first_name text;

	_last_name text;

BEGIN

	SELECT authentication.user_role(_email_address, _password) INTO _role;

	SELECT status FROM authentication.accounts

	WHERE email_address = _email_address INTO _account_state;		

	IF _role IS NULL THEN

    	RAISE invalid_password USING message = 'INVALID EMAIL ADDRESS OR PASSWORD';	

	ELSIF _account_state = 'not_activated' THEN

		RAISE EXCEPTION 'ACCOUNT NOT VALIDATED';

	ELSIF _account_state = 'banned' THEN

		RAISE EXCEPTION 'ACCOUNT BANNED';

	ELSE

		SET search_path TO authentication;

		SELECT id, first_name, last_name INTO _account_id, _first_name, _last_name FROM accounts WHERE email_address = _email_address ;

  		SELECT sign(row_to_json(r), current_setting('app.settings.jwt_secret')) 

		AS token FROM (

	      SELECT _role AS role, _account_id AS account_id, sign_in._email_address AS email_address,

         extract(epoch FROM now())::integer + 60*60*current_setting('app.settings.jwt_lifetime_hours')::integer AS exp) r

	   	 INTO _result;

  		RETURN _result;	

	END IF;

END;

$$;

-- ddl-end --

ALTER FUNCTION public.sign_in(IN character varying(255),IN character varying(255)) OWNER TO postgres;

-- ddl-end --



-- object: authentication.tokens | type: TABLE --

-- DROP TABLE IF EXISTS authentication.tokens CASCADE;

CREATE TABLE authentication.tokens(

	id bigint NOT NULL DEFAULT nextval('authentication.tokens_id_seq'::regclass),

	account bigint NOT NULL,

	token_type authentication.token_type NOT NULL DEFAULT 'validation',

	expires_at timestamp with time zone NOT NULL,

	token text NOT NULL,

	redeemed boolean NOT NULL DEFAULT false,

	CONSTRAINT pk_tokens PRIMARY KEY (id)



);

-- ddl-end --

ALTER TABLE authentication.tokens OWNER TO postgres;

-- ddl-end --



-- object: authentication.email_templates | type: TABLE --

-- DROP TABLE IF EXISTS authentication.email_templates CASCADE;

CREATE TABLE authentication.email_templates(

	id bigint NOT NULL DEFAULT nextval('authentication.email_templates_id_seq'::regclass),

	token_type authentication.token_type NOT NULL,

	subject character varying(255),

	body text,

	CONSTRAINT pk_email_templates PRIMARY KEY (id),

	CONSTRAINT uq_email_templates_token_types UNIQUE (token_type)

);

-- ddl-end --

ALTER TABLE authentication.email_templates OWNER TO postgres;

-- ddl-end --



-- object: authentication.accounts | type: TABLE --

-- DROP TABLE IF EXISTS authentication.accounts CASCADE;

CREATE TABLE authentication.accounts(

	id bigint NOT NULL DEFAULT nextval('authentication.accounts_id_seq'::regclass),

	email_address character varying(255) NOT NULL,

	_password_ text NOT NULL,

	first_name character varying(255) NOT NULL,

	last_name character varying(255) NOT NULL,

	status authentication.account_status NOT NULL DEFAULT 'not_activated',

	role authentication.account_roles NOT NULL DEFAULT 'web_anon',

	CONSTRAINT pk_users PRIMARY KEY (id),

	CONSTRAINT uq_users_email_address UNIQUE (email_address),

	CONSTRAINT ck_valid_email_address CHECK (email_address ~* '^.+@.+\..+$' )

);

-- ddl-end --

ALTER TABLE authentication.accounts OWNER TO postgres;

-- ddl-end --



-- object: authentication.outgoing_emails | type: TABLE --

-- DROP TABLE IF EXISTS authentication.outgoing_emails CASCADE;

CREATE TABLE authentication.outgoing_emails(

	id bigint NOT NULL DEFAULT nextval('authentication.outgoing_emails_id_seq'::regclass),

	email_template bigint NOT NULL,

	_from_ character varying(255) NOT NULL,

	_to_ character varying(255) NOT NULL,

	doc_tokens jsonb,

	retries smallint NOT NULL DEFAULT 0,

	email_status authentication.email_status NOT NULL DEFAULT 'awaiting',

	CONSTRAINT pk_outgoing_emails PRIMARY KEY (id)



);

-- ddl-end --

ALTER TABLE authentication.outgoing_emails OWNER TO postgres;

-- ddl-end --



-- object: tg_check_if_role_exists | type: TRIGGER --

-- DROP TRIGGER IF EXISTS tg_check_if_role_exists ON authentication.accounts CASCADE;

CREATE TRIGGER tg_check_if_role_exists

	AFTER INSERT OR UPDATE

	ON authentication.accounts

	FOR EACH ROW

	EXECUTE PROCEDURE authentication.check_if_role_exists();

-- ddl-end --



-- object: tg_encrypt_password | type: TRIGGER --

-- DROP TRIGGER IF EXISTS tg_encrypt_password ON authentication.accounts CASCADE;

CREATE TRIGGER tg_encrypt_password

	BEFORE INSERT OR UPDATE

	ON authentication.accounts

	FOR EACH ROW

	EXECUTE PROCEDURE authentication.encrypt_password();

-- ddl-end --



-- object: public.validate_account | type: FUNCTION --

-- DROP FUNCTION IF EXISTS public.validate_account(IN character varying,IN character varying) CASCADE;

CREATE FUNCTION public.validate_account (IN _email_address character varying, IN _token character varying)

	RETURNS void

	LANGUAGE plpgsql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 1

	AS $$

DECLARE

	_account_id bigint;

	_token_id bigint;	

	__token character varying;		

	_expires_at timestamp with time zone;

BEGIN



	SELECT id INTO _account_id FROM authentication.accounts 

	WHERE email_address = _email_address LIMIT 1; 

	

	IF _account_id IS NULL THEN

		RAISE EXCEPTION 'ACCOUNT DOES NOT EXIST';	

	END IF;



	SELECT id, token, expires_at INTO _token_id, __token, _expires_at

	FROM authentication.tokens 

	WHERE account = _account_id AND token_type = 'validation' AND redeemed = false

	ORDER BY id DESC

	LIMIT 1;



	IF __token IS NULL THEN

		RAISE EXCEPTION 'INVALID VALIDATION TOKEN';	

	ELSIF _token = __token AND current_timestamp > _expires_at THEN

		RAISE EXCEPTION 'TOKEN EXPIRED';								

	ELSIF _token = __token AND current_timestamp < _expires_at THEN		

		UPDATE authentication.accounts SET status = 'activated', role = 'authenticated_user'

		WHERE id = _account_id;		

		UPDATE authentication.tokens SET redeemed = true

		WHERE id = _token_id;

	ELSE		

		RAISE EXCEPTION 'SOMETHING WENT WRONG WITH VALIDATING YOUR ACCOUNT';

	END IF;

	

END;

$$;

-- ddl-end --

ALTER FUNCTION public.validate_account(IN character varying,IN character varying) OWNER TO postgres;

-- ddl-end --



-- object: public.request_reset_password | type: FUNCTION --

-- DROP FUNCTION IF EXISTS public.request_reset_password(IN character varying) CASCADE;

CREATE FUNCTION public.request_reset_password (IN _email_address character varying)

	RETURNS void

	LANGUAGE plpgsql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 1

	AS $$

DECLARE

	_validate_email_template_id bigint;

	_token_data authentication.tokens%ROWTYPE;

	_account_id  bigint;

	_first_name character varying;

	_last_name character varying;

	_account_status authentication.account_status;

BEGIN

		

	SELECT id, first_name, last_name, status 

	INTO _account_id, _first_name, _last_name, _account_status

	FROM authentication.accounts 

	WHERE email_address = _email_address LIMIT 1;

	

	IF _account_id IS NULL OR _account_status::text <> 'activated' THEN

		RAISE EXCEPTION 'SOMETHING WENT WRONG';

	END IF;



	INSERT INTO authentication.tokens(account, token_type, expires_at, token)

	VALUES (_account_id, 'reset_password', current_timestamp + (current_setting('app.settings.otp_lifetime_minutes')::integer * interval '1 minute'),to_char(floor(random() * 9999 + 1)::int, 'fm0000')) 

	RETURNING * INTO _token_data;

	

	SELECT id INTO _validate_email_template_id 

	FROM authentication.email_templates 

	WHERE token_type='reset_password' LIMIT 1;



	INSERT INTO authentication.outgoing_emails(email_template, _from_,  _to_, doc_tokens, email_status)

	VALUES ( 

		_validate_email_template_id, 

		current_setting('app.settings.app_admin_email'),

		_email_address,

		jsonb_build_object(

				'emailAddress', _email_address,

				'firstName', _first_name,

				'lastName', _last_name,

				'appName', current_setting('app.settings.app_name'),

				'token', _token_data.token,

				'tokenExpiry', _token_data.expires_at::text

			),

			'awaiting'

		);		



END;

$$;

-- ddl-end --

ALTER FUNCTION public.request_reset_password(IN character varying) OWNER TO postgres;

-- ddl-end --



-- object: public.reset_password | type: FUNCTION --

-- DROP FUNCTION IF EXISTS public.reset_password(IN character varying,IN character varying,IN character varying,IN character varying) CASCADE;

CREATE FUNCTION public.reset_password (IN _email_address character varying, IN _password character varying, IN _confirm_password character varying, IN _token character varying)

	RETURNS void

	LANGUAGE plpgsql

	VOLATILE 

	CALLED ON NULL INPUT

	SECURITY INVOKER

	COST 1

	AS $$

DECLARE

	_account_id bigint;

	_token_id bigint;	

	__token character varying;		

	_expires_at timestamp with time zone;

	_account_status authentication.account_status;

BEGIN



	IF _password <> _confirm_password THEN

		RAISE EXCEPTION 'PASSWORDS DO NOT MATCH';

	END IF;



	SELECT id, status INTO _account_id, _account_status

	FROM authentication.accounts 

	WHERE email_address = _email_address LIMIT 1; 

	

	IF _account_id IS NULL OR _account_status::text <> 'activated' THEN

		RAISE EXCEPTION 'SOMETHING WENT WRONG';

	END IF;



	SELECT id, token, expires_at INTO _token_id, __token, _expires_at

	FROM authentication.tokens 

	WHERE account = _account_id AND token_type = 'reset_password' AND redeemed = false

	ORDER BY id DESC	

	LIMIT 1;



	IF __token IS NULL THEN

		RAISE EXCEPTION 'INVALID RESET TOKEN';	

	ELSIF _token = __token AND current_timestamp > _expires_at THEN

		RAISE EXCEPTION 'TOKEN EXPIRED';								

	ELSIF _token = __token AND current_timestamp < _expires_at THEN		

		UPDATE authentication.accounts SET _password_ = _password

		WHERE id = _account_id;		

		UPDATE authentication.tokens SET redeemed = true

		WHERE id = _token_id;

	ELSE		

		RAISE EXCEPTION 'SOMETHING WENT WRONG WITH RESETTING YOUR PASSWORD';

	END IF;

	

END;

$$;

-- ddl-end --

ALTER FUNCTION public.reset_password(IN character varying,IN character varying,IN character varying,IN character varying) OWNER TO postgres;

-- ddl-end --



-- object: fk_account_tokens | type: CONSTRAINT --

-- ALTER TABLE authentication.tokens DROP CONSTRAINT IF EXISTS fk_account_tokens CASCADE;

ALTER TABLE authentication.tokens ADD CONSTRAINT fk_account_tokens FOREIGN KEY (account)

REFERENCES authentication.accounts (id) MATCH FULL

ON DELETE NO ACTION ON UPDATE CASCADE;

-- ddl-end --



-- object: fk_template_outgoing_emails | type: CONSTRAINT --

-- ALTER TABLE authentication.outgoing_emails DROP CONSTRAINT IF EXISTS fk_template_outgoing_emails CASCADE;

ALTER TABLE authentication.outgoing_emails ADD CONSTRAINT fk_template_outgoing_emails FOREIGN KEY (email_template)

REFERENCES authentication.email_templates (id) MATCH FULL

ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ddl-end --





-- Appended SQL commands --

GRANT web_anon TO authenticator;

GRANT USAGE ON SCHEMA public, authentication TO web_anon;



GRANT SELECT ON TABLE pg_authid TO web_anon;



GRANT SELECT, INSERT, UPDATE ON TABLE authentication.accounts TO web_anon;

GRANT SELECT, INSERT, UPDATE ON TABLE authentication.tokens TO web_anon;

GRANT SELECT, INSERT ON TABLE authentication.outgoing_emails TO web_anon;

GRANT SELECT ON TABLE authentication.email_templates TO web_anon;



GRANT USAGE, SELECT ON SEQUENCE authentication.accounts_id_seq TO web_anon;

GRANT USAGE, SELECT ON SEQUENCE authentication.tokens_id_seq TO web_anon;

GRANT USAGE, SELECT ON SEQUENCE authentication.outgoing_emails_id_seq TO web_anon;



GRANT EXECUTE ON FUNCTION 

	sign_in(

		character varying,

		character varying

	) to web_anon;



GRANT EXECUTE ON FUNCTION 

	sign_up(

		character varying,

		character varying,

		character varying,

		character varying,

		character varying

	) to web_anon;



INSERT INTO authentication.email_templates(

	token_type, subject, body)

VALUES (

	'validation', 

	'{{appName}}, {{emailAddress}} - Account Validation', 

	'{{firstName}} {{lastName}}, Your One Time Pin  is  {{token}}

This token will expire at {{tokenExpiry}}');



INSERT INTO authentication.email_templates(

	token_type, subject, body)

VALUES (

	'reset_password', 

	'{{appName}}, {{emailAddress}} - Account Password Reset', 

	'{{firstName}} {{lastName}}, Your One Time Pin  is  {{token}}

This token will expire at {{tokenExpiry}}');

---