CREATE OR REPLACE FUNCTION private.commit_transaction (
  request_id      uuid,
  checksum        text,
  transaction_id  uuid,
  amount          numeric,
  remarks         text
)
RETURNS SETOF public.t_transfer AS $$
  DECLARE
    transaction public.transactions;
    ref_debit   public.debits;
    ref_credit  public.credits;
    debit       public.debits;
    credit      public.credits;
    operation   public.t_operation := 'commit';
  BEGIN

    -- perform some validations
    IF request_id IS NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Request ID is NULL';
    END IF;

    IF transaction_id IS NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Transaction ID is NULL';
    END IF;

    IF checksum IS NULL OR TRIM(checksum) = '' THEN
      RAISE not_null_violation USING MESSAGE = 'Checksum is empty';
    END IF;

    IF amount <= 0 THEN
      RAISE check_violation USING MESSAGE = 'Invalid amount';
    END IF;

    -- log transaction
    SELECT private.log_transaction (request_id, checksum) INTO transaction; 

    -- check for replays
    IF transaction.updated_at <> transaction.created_at THEN
      RETURN QUERY
        SELECT transaction.request_id, transaction.id, wallet_id,
          current_balance, available_balance, updated_at
          FROM public.debits WHERE transaction_id = transaction.id
        UNION
        SELECT transaction.request_id, transaction.id, wallet_id,
          current_balance, available_balance, updated_at
          FROM public.credits WHERE transaction_id = transaction.id;
    END IF;

    -- load reference
    SELECT * INTO ref_debit FROM public.debits
      WHERE transaction_id = transaction_id LIMIT 1;

    SELECT * INTO ref_credit FROM public.credits
      WHERE transaction_id = transaction_id LIMIT 1;

    -- only held transactions can be committed
    IF ref_debit.operation <> 'hold' OR ref_credit.operation <> 'hold' THEN
      RAISE check_violation USING MESSAGE = 'Invalid operation';
    END IF;

    -- execute debit
    SELECT private.debit_wallet (
        ref_debit.id, transaction.id, ref_debit.wallet_id, ref_debit.amount, COALESCE(amount, 0),
        remarks, operation
      ) INTO debit;

    -- execute credit
    SELECT private.credit_wallet (
        ref_credit.id, transaction.id, ref_credit.wallet_id, ref_credit.amount, COALESCE(amount, 0),
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
