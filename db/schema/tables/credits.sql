SET search_path TO public;

DROP TABLE IF EXISTS credits CASCADE;
CREATE TABLE IF NOT EXISTS credits (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference_id       uuid UNIQUE REFERENCES credits(id),
  transaction_id     uuid NOT NULL UNIQUE REFERENCES transactions(id),
  wallet_id          uuid NOT NULL REFERENCES wallets(id),
  amount             numeric(19,4) NOT NULL CHECK(amount > 0),
  remarks            text,
  operation          t_operation NOT NULL,
  current_balance    numeric(19,4) NOT NULL CHECK(current_balance >= 0),
  available_balance  numeric(19,4) NOT NULL CHECK(available_balance >= 0),
  created_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX credits_created_at ON credits(created_at);
