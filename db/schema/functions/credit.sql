CREATE OR REPLACE FUNCTION private.credit(
  transaction_id uuid,
  wallet_id      uuid,
  amount         numeric,
  remarks        text,
  operation      t_operation
)
RETURNS credits AS $$
  DECLARE
    credit public.credits;
    wallet public.wallets;
  BEGIN
    -- update wallet
    UPDATE public.wallets SET
      current_balance = current_balance + amount,
      available_balance = available_balance + amount
    WHERE
      id = wallet_id
    RETURNING * INTO wallet;

    -- create a credit record
    INSERT INTO public.credits (
      transaction_id, wallet_id, amount, remarks, operation, current_balance, available_balance
    ) VALUES (
      transaction_id, wallet_id, amount, remarks, operation, wallet.current_balance, wallet.available_balance
    )
    RETURNING * INTO credit;

    RETURN credit;
  END;
$$ LANGUAGE plpgsql;
