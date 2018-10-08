SET search_path TO public;

DROP TABLE IF EXISTS topups CASCADE;
CREATE TABLE IF NOT EXISTS topups (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference_id       uuid UNIQUE REFERENCES topups(id),
  transaction_id     uuid NOT NULL UNIQUE REFERENCES transactions(id),
  wallet_id          uuid NOT NULL REFERENCES wallets(id),
  amount             numeric(19,4) NOT NULL CHECK(amount > 0),
  source             text NOT NULL,
  remarks            text,
  operation          t_operation NOT NULL,
  current_balance    numeric(19,4) NOT NULL CHECK(current_balance >= 0),
  available_balance  numeric(19,4) NOT NULL CHECK(available_balance >= 0),
  created_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX topups_created_at ON topups(created_at);
