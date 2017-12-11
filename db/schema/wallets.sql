SET search_path TO public;

DROP TABLE IF EXISTS wallets CASCADE;
CREATE TABLE IF NOT EXISTS wallets (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id           uuid NOT NULL REFERENCES owners(id),
  principal          boolean,
  name               text NOT NULL,
  description        text,
  label              text,
  current_balance    decimal(19,4) NOT NULL DEFAULT 0.00,
  available_balance  decimal(19,4) NOT NULL DEFAULT 0.00,
  created_at         timestamp with time zone NOT NULL DEFAULT now(),
  updated_at         timestamp with time zone NOT NULL DEFAULT now(),
  UNIQUE(owner_id, principal)
);
