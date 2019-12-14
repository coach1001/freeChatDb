-- Verify freeChat:url_encode_function on pg

BEGIN;

DO $$
DECLARE
    result varchar;
BEGIN
   result := (SELECT membership.url_encode('BASE64 ENCODE THIS PLEASE'));
   ASSERT result = 'QkFTRTY0IEVOQ09ERSBUSElTIFBMRUFTRQ';
END $$;

ROLLBACK;
