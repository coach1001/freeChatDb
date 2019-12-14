-- Verify freeChat:url_decode_function on pg

BEGIN;

DO $$
DECLARE
    result varchar;
BEGIN
   result := (SELECT membership.url_decode('QkFTRTY0IEVOQ09ERSBUSElTIFBMRUFTRQ'));
   ASSERT result = '\x42415345363420454e434f4445205448495320504c45415345';
END $$;

ROLLBACK;
