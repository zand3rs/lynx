SET search_path TO public;

CREATE OR REPLACE FUNCTION commit_transaction (
  request_id      uuid,
  checksum        text,
  transaction_id  uuid,
  amount          numeric,
  remarks         text
)
RETURNS t_transfer AS $$
  DECLARE
    transfer    t_transfer;
    transaction transactions;
    ref_debit   debits;
    ref_credit  credits;
    debit       debits;
    credit      credits;
    operation   t_operation := 'commit';
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
    SELECT * INTO transaction FROM log_transaction(request_id, checksum) LIMIT 1;

    -- check for replays, return if found
    SELECT * INTO transfer FROM replay_transaction(transaction) LIMIT 1;

    IF transfer IS NOT NULL THEN
      RETURN transfer;
    END IF;

    -- load reference
    SELECT * INTO ref_debit FROM debits
      WHERE transaction_id = transaction_id LIMIT 1;

    SELECT * INTO ref_credit FROM credits
      WHERE transaction_id = transaction_id LIMIT 1;

    -- only held transactions can be committed
    IF ref_debit.operation <> 'hold' OR ref_credit.operation <> 'hold' THEN
      RAISE check_violation USING MESSAGE = 'Invalid operation';
    END IF;

    -- execute debit
    SELECT * INTO debit FROM debit_wallet(
        ref_debit.id, transaction.id, ref_debit.wallet_id, ref_debit.amount, COALESCE(amount, 0),
        remarks, operation
      ) LIMIT 1;

    -- execute credit
    SELECT * INTO credit FROM credit_wallet(
        ref_credit.id, transaction.id, ref_credit.wallet_id, ref_credit.amount, COALESCE(amount, 0),
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
