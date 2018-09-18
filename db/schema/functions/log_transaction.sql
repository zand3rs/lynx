CREATE OR REPLACE FUNCTION private.log_transaction (
  request_id  uuid,
  checksum    text
)
RETURNS public.transactions AS $$
  DECLARE
    transaction public.transactions;
  BEGIN
    INSERT INTO public.transactions (
      request_id, checksum
    ) VALUES (
      request_id, checksum
    )
    -- update timestamp for replayed transactions
    ON CONFLICT (request_id) DO UPDATE
      SET updated_at = CURRENT_TIMESTAMP
    RETURNING * INTO transaction;

    -- throw error if replay and checksums do not match
    IF transaction.updated_at <> transaction.created_at AND
       transaction.checksum <> checksum THEN
      RAISE unique_violation USING MESSAGE = 'Duplicate request_id: ' || request_id::text;
    END IF;

    RETURN transaction;
  END;
$$ LANGUAGE plpgsql;
