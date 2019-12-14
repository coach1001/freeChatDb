-- Deploy freeChat:set_timestamp_trigger to pg

BEGIN;

CREATE OR REPLACE FUNCTION tg_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMIT;
