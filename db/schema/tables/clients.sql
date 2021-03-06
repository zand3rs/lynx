SET search_path TO public;

DROP TABLE IF EXISTS clients CASCADE;
CREATE TABLE IF NOT EXISTS clients (
  id            uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  account_id    uuid NOT NULL REFERENCES accounts(id),
  uid           text NOT NULL UNIQUE,
  scope         json,
  created_at    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(account_id, uid)
);
