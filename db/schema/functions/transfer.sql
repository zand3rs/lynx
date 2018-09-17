CREATE OR REPLACE FUNCTION private.transfer (
  reference_id  uuid,
  sender        uuid,
  recipient     uuid,
  amount        numeric,
  remarks       text,
  operation     t_operation,
  checksum      text
)
RETURNS TABLE (
  transaction_id uuid,
  sender_wallet_id uuid,
  sender_current_balance numeric,
  sender_available_balance numeric,
  sender_updated_at timestamp,
  recipient_wallet_id uuid,
  recipient_current_balance numeric,
  recipient_available_balance numeric,
  recipient_updated_at timestamp
) AS $$
  DECLARE
    transaction public.transactions;
    ref_debit   public.debits;
    ref_credit  public.credits;
    debit       public.debits;
    credit      public.credits;
    transfer    record;
  BEGIN

    INSERT INTO public.transactions (
      request_id, checksum
    ) VALUES (
      request_id, checksum
    )
    ON CONFLICT (request_id) DO UPDATE
      SET updated_at = CURRENT_TIMESTAMP
    RETURNING * INTO transaction;

    -- check for replayed transactions
    IF transaction.updated_at <> transaction.created_at THEN
      -- throw error if checksums do not match
      IF transaction.checksum <> checksum THEN
        RAISE unique_violation USING MESSAGE = 'Duplicate request_id: ' || request_id;
      END IF;

      -- load transfer details
      SELECT transaction.id,
             d.wallet_id,
             d.current_balance, d.available_balance, d.updated_at,
             c.wallet_id,
             c.current_balance, c.available_balance, c.updated_at
        INTO transfer FROM credits c, debits, d
        WHERE d.transaction_id = transaction.id AND
              c.transaction_id = transaction.id;

      RETURN transfer;
    END IF;

    -- load reference
    IF reference_id IS NOT NULL THEN
      SELECT * INTO ref_debit FROM public.debits
        WHERE transaction_id = reference_id LIMIT 1;

      SELECT * INTO ref_credit FROM public.credits
        WHERE transaction_id = reference_id LIMIT 1;
    END IF;

    -- execute debit
    SELECT private.debit (
        ref_debit.id, transaction.id, sender,
        COALESCE(ref_debit.amount, 0), COALESCE(amount, 0),
        remarks, operation
      ) INTO debit;

    -- execute credit
    SELECT private.credit (
        ref_credit.id, transaction.id, recipient,
        COALESCE(ref_credit.amount, 0), COALESCE(amount, 0),
        remarks, operation
      ) INTO credit;

    -- load transfer details
    SELECT transaction.id,
           debit.wallet_id,
           debit.current_balance, debit.available_balance, debit.updated_at,
           credit.wallet_id,
           credit.current_balance, credit.available_balance, credit.updated_at
      INTO transfer;

    RETURN transfer;
  END;
$$ LANGUAGE plpgsql;
