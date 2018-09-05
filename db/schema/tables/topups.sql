SET search_path TO public;

DROP TABLE IF EXISTS topups CASCADE;
CREATE TABLE IF NOT EXISTS topups (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id         uuid NOT NULL UNIQUE,
  wallet_id          uuid NOT NULL REFERENCES wallets(id),
  amount             numeric(19,4) NOT NULL,
  source             text NOT NULL,
  remarks            text,
  current_balance    numeric(19,4) NOT NULL CHECK(current_balance >= 0),
  available_balance  numeric(19,4) NOT NULL CHECK(available_balance >= 0),
  created_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
