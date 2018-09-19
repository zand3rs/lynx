CREATE OR REPLACE FUNCTION private.credit_wallet (
  reference_id    uuid,
  transaction_id  uuid,
  wallet_id       uuid,
  reserved_amount numeric,
  approved_amount numeric,
  remarks         text,
  operation       t_operation
)
RETURNS public.credits AS $$
  DECLARE
    credit public.credits;
    wallet public.wallets;

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

    -- compute credit amount
    CASE operation
      WHEN 'commit' THEN
        current_amount := approved_amount - reserved_amount;
        available_amount := approved_amount;
        actual_amount := approved_amount;
      WHEN 'release' THEN
        current_amount := approved_amount - reserved_amount;
        actual_amount := reserved_amount;
      WHEN 'hold' THEN
        current_amount := approved_amount;
        actual_amount := approved_amount;
      ELSE
        RAISE check_violation USING MESSAGE = 'Invalid operation';
    END CASE;

    -- update wallet
    UPDATE public.wallets SET
      current_balance = current_balance + current_amount,
      available_balance = available_balance + available_amount,
      updated_at = CURRENT_TIMESTAMP
    WHERE
      id = wallet_id
    RETURNING * INTO wallet;

    -- wallet validations
    IF wallet IS NULL THEN
      RAISE check_violation USING MESSAGE = 'Wallet not found: ' || wallet_id;
    END IF;

    IF wallet.current_balance < 0 OR wallet.available_balance < 0 THEN
      RAISE check_violation USING MESSAGE = 'Insufficient funds';
    END IF;

    -- create a credit record
    INSERT INTO public.credits (
      reference_id, transaction_id, wallet_id, amount, remarks, operation, current_balance, available_balance
    ) VALUES (
      reference_id, transaction_id, wallet_id, actual_amount, remarks, operation, wallet.current_balance, wallet.available_balance
    )
    RETURNING * INTO credit;

    RETURN credit;
  END;
$$ LANGUAGE plpgsql;
