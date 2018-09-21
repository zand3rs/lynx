SET search_path TO public;

CREATE OR REPLACE FUNCTION replay_transaction (
  transaction transactions
)
RETURNS t_transfer AS $$
  DECLARE
    transfer t_transfer;
  BEGIN
    IF transaction IS NOT NULL AND
       transaction.updated_at <> transaction.created_at THEN
       -- it is considered a replay if updated_at is not equal to created_at
        SELECT transaction.request_id, transaction.id,
               a.wallet_id, a.current_balance, a.available_balance, a.updated_at,
               b.wallet_id, b.current_balance, b.available_balance, b.updated_at
          INTO transfer
          FROM debits a, credits b
          WHERE a.transaction_id = transaction.id AND b.transaction_id = transaction.id
          LIMIT 1;
    END IF;

    RETURN transfer;
  END;
$$ LANGUAGE plpgsql;
