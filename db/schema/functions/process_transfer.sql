SET search_path TO public;

CREATE OR REPLACE FUNCTION process_transfer (
  request_id   uuid,
  checksum     text,
  a_wallet_id  uuid,
  b_wallet_id  uuid,
  amount       numeric,
  remarks      text,
  hold         boolean
)
RETURNS t_transfer AS $$
  DECLARE
    transfer    t_transfer;
    transaction transactions;
    debit       debits;
    credit      credits;
    operation   t_operation := CASE WHEN hold THEN 'hold' ELSE 'commit' END;
  BEGIN
    -- perform some validations
    IF request_id IS NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Request ID is NULL';
    END IF;

    IF checksum IS NULL OR TRIM(checksum) = '' THEN
      RAISE not_null_violation USING MESSAGE = 'Checksum is empty';
    END IF;

    IF a_wallet_id IS NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Invalid source wallet';
    END IF;

    IF b_wallet_id IS NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Invalid destination wallet';
    END IF;

    IF b_wallet_id = a_wallet_id THEN
      RAISE check_violation USING MESSAGE = 'Destination wallet is also the source wallet';
    END IF;

    IF amount IS NULL OR amount <= 0 THEN
      RAISE check_violation USING MESSAGE = 'Invalid amount';
    END IF;

    -- log transaction
    SELECT * INTO transaction FROM log_transaction(request_id, checksum) LIMIT 1;

    -- check for replays, return if found
    SELECT * INTO transfer FROM replay_transaction(transaction) LIMIT 1;

    IF transfer IS NOT NULL THEN
      RETURN transfer;
    END IF;

    -- execute debit
    SELECT * INTO debit FROM debit_wallet(
        NULL, transaction.id, a_wallet_id, 0, amount,
        remarks, operation
      ) LIMIT 1;

    -- execute credit
    SELECT * INTO credit FROM credit_wallet(
        NULL, transaction.id, b_wallet_id, 0, amount,
        remarks, operation
      ) LIMIT 1;

    -- return transfer details
    SELECT transaction.request_id, transaction.id,
      debit.wallet_id, debit.current_balance, debit.available_balance, debit.updated_at,
      credit.wallet_id, credit.current_balance, credit.available_balance, credit.updated_at
      INTO transfer;

    RETURN transfer;
  END;
$$ LANGUAGE plpgsql;
