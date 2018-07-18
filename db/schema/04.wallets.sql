SET search_path TO public;

DROP TABLE IF EXISTS wallets CASCADE;
CREATE TABLE IF NOT EXISTS wallets (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id           uuid NOT NULL REFERENCES owners(id),
  name               text NOT NULL,
  description        text,
  label              text,
  principal          boolean,
  current_balance    numeric(19,4) NOT NULL DEFAULT 0,
  available_balance  numeric(19,4) NOT NULL DEFAULT 0,
  created_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(owner_id, name),
  UNIQUE(owner_id, principal)
);

INSERT INTO wallets(owner_id, name, description, principal)
  SELECT owners.id, 'Lynx Wallet', 'Lynx mother wallet', true
  FROM owners INNER JOIN accounts ON owners.account_id=accounts.id
  WHERE owners.account_id::text=owners.uid AND accounts.name='Lynx';
