SET search_path TO public;

DROP TABLE IF EXISTS owners CASCADE;
CREATE TABLE IF NOT EXISTS owners (
  id            uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  account_id    uuid NOT NULL REFERENCES accounts(id),
  uid           text NOT NULL,
  created_at    timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(account_id, uid)
);

INSERT INTO owners(account_id, uid) SELECT id, id FROM accounts WHERE name='Lynx';
