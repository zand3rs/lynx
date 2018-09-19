SET search_path TO public;

DROP TABLE IF EXISTS accounts CASCADE;
CREATE TABLE IF NOT EXISTS accounts (
  id            uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          text NOT NULL UNIQUE,
  description   text,
  type          t_account_type DEFAULT 'default',
  deleted_at    timestamp,
  created_at    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
