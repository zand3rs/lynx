SET search_path TO public;

DROP TABLE IF EXISTS debits CASCADE;
CREATE TABLE IF NOT EXISTS debits (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  transaction_id     uuid NOT NULL UNIQUE REFERENCES transactions(id),
  request_id         uuid NOT NULL UNIQUE,
  wallet_id          uuid NOT NULL REFERENCES wallets(id),
  amount             decimal(19,4) NOT NULL,
  remarks            text,
  operation          t_op NOT NULL,
  current_balance    decimal(19,4) NOT NULL,
  available_balance  decimal(19,4) NOT NULL,
  created_at         timestamp with time zone NOT NULL DEFAULT now(),
  updated_at         timestamp with time zone NOT NULL DEFAULT now()
);
