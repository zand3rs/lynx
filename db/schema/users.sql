DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE IF NOT EXISTS users (
  id            bigserial NOT NULL PRIMARY KEY,
  account_id    bigint NOT NULL REFERENCES accounts(id),
  uid           text NOT NULL,
  created_at    timestamp with time zone NOT NULL DEFAULT now(),
  updated_at    timestamp with time zone NOT NULL DEFAULT now(),
  UNIQUE(account_id, uid)
);
