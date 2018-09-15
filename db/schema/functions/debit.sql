CREATE OR REPLACE FUNCTION private.debit(
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
    debit public.debits;
    wallet public.wallets;

    current_amount   numeric := 0;
    available_amount numeric := 0;
    actual_amount    numeric := 0;
  BEGIN

    -- approved_amount should be greater than or equal to reserved_amount
    IF approved_amount > reserved_amount THEN
      RAISE EXCEPTION 'Approved amount is greater than reserved amount!';
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
        RAISE EXCEPTION 'Invalid operation!';
    END CASE;

    -- update wallet
    UPDATE public.wallets SET
      current_balance = current_balance - current_amount,
      available_balance = available_balance - available_amount
    WHERE
      id = wallet_id AND
      (current_balance - current_amount) >= 0 AND
      (available_balance - available_amount) >= 0
    RETURNING * INTO wallet;

    -- create a debit record
    INSERT INTO public.debits (
      reference_id, transaction_id, wallet_id, amount, remarks, operation, current_balance, available_balance
    ) VALUES (
      reference_id, transaction_id, wallet_id, actual_amount, remarks, operation, wallet.current_balance, wallet.available_balance
    )
    RETURNING * INTO debit;

    RETURN debit;
  END;
$$ LANGUAGE plpgsql;
