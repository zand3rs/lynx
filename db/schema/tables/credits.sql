SET search_path TO public;

DROP TABLE IF EXISTS credits CASCADE;
CREATE TABLE IF NOT EXISTS credits (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  transaction_id     uuid NOT NULL UNIQUE REFERENCES transactions(id),
  request_id         uuid NOT NULL UNIQUE,
  wallet_id          uuid NOT NULL REFERENCES wallets(id),
  amount             numeric(19,4) NOT NULL,
  remarks            text,
  operation          t_op NOT NULL,
  current_balance    numeric(19,4) NOT NULL,
  available_balance  numeric(19,4) NOT NULL,
  created_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
