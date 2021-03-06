SET search_path TO public;

CREATE OR REPLACE FUNCTION debit_wallet (
  reference_id    uuid,
  transaction_id  uuid,
  wallet_id       uuid,
  reserved_amount numeric,
  approved_amount numeric,
  remarks         text,
  operation       t_operation
)
RETURNS debits AS $$
  DECLARE
    debit debits;
    wallet wallets;

    current_amount   numeric := 0;
    available_amount numeric := 0;
    actual_amount    numeric := 0;
  BEGIN
    -- perform some validations
    IF approved_amount IS NULL OR approved_amount < 0 THEN
      RAISE check_violation USING MESSAGE = 'Invalid approved amount';
    END IF;

    IF reserved_amount IS NULL OR reserved_amount < 0 THEN
      RAISE check_violation USING MESSAGE = 'Invalid reserved amount';
    END IF;

    IF reserved_amount > 0 AND approved_amount > reserved_amount THEN
      RAISE check_violation USING MESSAGE = 'Approved amount > reserved amount';
    END IF;

    -- compute debit amount
    CASE operation
      WHEN 'commit' THEN
        current_amount := approved_amount;
        available_amount := approved_amount - reserved_amount;
        actual_amount := approved_amount;
      WHEN 'release' THEN
        available_amount := approved_amount - reserved_amount;
        actual_amount := reserved_amount;
      WHEN 'hold' THEN
        available_amount := approved_amount;
        actual_amount := approved_amount;
      ELSE
        RAISE check_violation USING MESSAGE = 'Invalid operation';
    END CASE;

    -- update wallet
    UPDATE wallets SET
      current_balance = current_balance - current_amount,
      available_balance = available_balance - available_amount,
      updated_at = CURRENT_TIMESTAMP
    WHERE
      id = wallet_id
    RETURNING * INTO wallet;

    RAISE NOTICE 'wallet: %', wallet;

    -- wallet validations
    IF wallet IS NULL THEN
      RAISE check_violation USING MESSAGE = 'Wallet not found: ' || wallet_id;
    END IF;

    IF wallet.current_balance < 0 OR wallet.available_balance < 0 THEN
      RAISE check_violation USING MESSAGE = 'Insufficient funds';
    END IF;

    -- create a debit record
    INSERT INTO debits (
      reference_id, transaction_id, wallet_id, amount, remarks, operation, current_balance, available_balance
    ) VALUES (
      reference_id, transaction_id, wallet_id, actual_amount, remarks, operation, wallet.current_balance, wallet.available_balance
    )
    RETURNING * INTO debit;

    RETURN debit;
  END;
$$ LANGUAGE plpgsql;
