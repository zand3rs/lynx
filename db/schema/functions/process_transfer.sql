CREATE OR REPLACE FUNCTION private.process_transfer (
  request_id  uuid,
  checksum    text,
  sender      uuid,
  recipient   uuid,
  amount      numeric,
  remarks     text,
  hold        boolean
)
RETURNS SETOF public.t_transfer AS $$
  DECLARE
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

    IF sender IS NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Sender is NULL';
    END IF;

    IF recipient IS NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Recipient is NULL';
    END IF;

    IF sender = recipient THEN
      RAISE check_violation USING MESSAGE = 'Sender: ' || sender::text || ' = Recipient: ' || recipient::text;
    END IF;

    IF amount IS NULL OR amount <= 0 THEN
      RAISE check_violation USING MESSAGE = 'Invalid amount';
    END IF;

    -- log transaction
    SELECT private.log_transaction (request_id, checksum) INTO transaction; 

    -- check for replays
    IF transaction.updated_at <> transaction.created_at THEN
      -- return transfer details
      RETURN QUERY
        SELECT transaction.request_id, transaction.id, wallet_id,
          current_balance, available_balance, updated_at
          FROM public.debits WHERE transaction_id = transaction.id
        UNION
        SELECT transaction.request_id, transaction.id, wallet_id,
          current_balance, available_balance, updated_at
          FROM public.credits WHERE transaction_id = transaction.id;
    END IF;

    -- execute debit
    SELECT private.debit_wallet (
        NULL, transaction.id, sender, 0, amount,
        remarks, operation
      ) INTO debit;

    -- execute credit
    SELECT private.credit_wallet (
        NULL, transaction.id, recipient, 0, amount,
        remarks, operation
      ) INTO credit;

    -- return transfer details
    RETURN QUERY
      SELECT transaction.request_id, transaction.id, debit.wallet_id,
        debit.current_balance, debit.available_balance, debit.updated_at
      UNION
      SELECT transaction.request_id, transaction.id, credit.wallet_id,
        credit.current_balance, credit.available_balance, credit.updated_at;

  END;
$$ LANGUAGE plpgsql;
