SET search_path TO public;

DROP TABLE IF EXISTS wallets CASCADE;
CREATE TABLE IF NOT EXISTS wallets (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id           uuid NOT NULL REFERENCES owners(id),
  name               text NOT NULL,
  description        text,
  label              text,
  type               t_wallet_type DEFAULT 'default',
  current_balance    numeric(19,4) NOT NULL DEFAULT 0 CHECK(current_balance >= 0),
  available_balance  numeric(19,4) NOT NULL DEFAULT 0 CHECK(available_balance >= 0),
  active             boolean DEFAULT true,
  deleted_at         timestamp,
  created_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(owner_id, name, active)
);
