SET search_path TO public;

CREATE OR REPLACE FUNCTION log_transaction (
  _request_id  uuid,
  _checksum    text
)
RETURNS transactions AS $$
  DECLARE
    transaction transactions;
  BEGIN
    INSERT INTO transactions (
      request_id, checksum
    ) VALUES (
      _request_id, _checksum
    )
    -- update timestamp for replayed transactions
    ON CONFLICT (request_id) DO UPDATE
      SET updated_at = CURRENT_TIMESTAMP
    RETURNING * INTO transaction;

    -- throw error if replay and checksums do not match
    IF transaction.updated_at <> transaction.created_at AND
       transaction.checksum <> _checksum THEN
      RAISE unique_violation USING MESSAGE = 'Duplicate request_id: ' || _request_id;
    END IF;

    RETURN transaction;
  END;
$$ LANGUAGE plpgsql;
