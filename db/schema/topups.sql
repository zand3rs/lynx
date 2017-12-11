SET search_path TO public;

DROP TABLE IF EXISTS topups CASCADE;
CREATE TABLE IF NOT EXISTS topups (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  wallet_id          uuid NOT NULL REFERENCES wallets(id),
  amount             decimal(19,4) NOT NULL,
  remarks            text,
  current_balance    decimal(19,4) NOT NULL,
  available_balance  decimal(19,4) NOT NULL,
  created_at         timestamp with time zone NOT NULL DEFAULT now(),
  updated_at         timestamp with time zone NOT NULL DEFAULT now()
);
