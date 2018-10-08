SET search_path TO public;

DROP TABLE IF EXISTS debits CASCADE;
CREATE TABLE IF NOT EXISTS debits (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference_id       uuid UNIQUE REFERENCES debits(id),
  transaction_id     uuid NOT NULL REFERENCES transactions(id),
  wallet_id          uuid NOT NULL REFERENCES wallets(id),
  amount             numeric(19,4) NOT NULL CHECK(amount > 0),
  remarks            text,
  operation          t_operation NOT NULL,
  current_balance    numeric(19,4) NOT NULL CHECK(current_balance >= 0),
  available_balance  numeric(19,4) NOT NULL CHECK(available_balance >= 0),
  created_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX debits_created_at ON debits(created_at);
