-- Deploy freeChat:default_email_templates to pg

BEGIN;

INSERT INTO membership.email_templates(token_type, subject, body, active)
VALUES (
	'validation', 
	'{{appName}}, {{emailAddress}} - Account Validation', 
	'{{firstName}} {{lastName}}, Your One Time Pin  is  {{token}}
	This token will expire at {{tokenExpiry}}', true);

INSERT INTO membership.email_templates(token_type, subject, body, active)
VALUES (
	'reset_password', 
	'{{appName}}, {{emailAddress}} - Account Password Reset', 
	'{{firstName}} {{lastName}}, Your One Time Pin  is  {{token}}
	This token will expire at {{tokenExpiry}}', true);

COMMIT;
