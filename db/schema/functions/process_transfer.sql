CREATE OR REPLACE FUNCTION private.process_transfer (
  request_id   uuid,
  checksum     text,
  a_wallet_id  uuid,
  b_wallet_id  uuid,
  amount       numeric,
  remarks      text,
  hold         boolean
)
RETURNS public.t_transfer AS $$
  DECLARE
    transfer    public.t_transfer;
    transaction public.transactions;
    debit       public.debits;
    credit      public.credits;
    operation   public.t_operation := CASE WHEN hold THEN 'hold' ELSE 'commit' END;
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
    SELECT private.log_transaction (request_id, checksum) INTO transaction; 

    -- check for replays
    SELECT private.replay_transaction (transaction) INTO transfer;

    IF transfer IS NOT NULL THEN
      RETURN transfer;
    END IF;

    -- execute debit
    SELECT private.debit_wallet (
        NULL, transaction.id, a_wallet_id, 0, amount,
        remarks, operation
      ) INTO debit;

    -- execute credit
    SELECT private.credit_wallet (
        NULL, transaction.id, b_wallet_id, 0, amount,
        remarks, operation
      ) INTO credit;

    -- return transfer details
    SELECT transaction.request_id, transaction.id,
      debit.wallet_id, debit.current_balance, debit.available_balance, debit.updated_at,
      credit.wallet_id, credit.current_balance, credit.available_balance, credit.updated_at
      INTO transfer;

    RETURN transfer;
  END;
$$ LANGUAGE plpgsql;
