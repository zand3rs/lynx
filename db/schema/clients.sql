DROP TABLE IF EXISTS clients CASCADE;
CREATE TABLE IF NOT EXISTS clients (
  id            bigserial NOT NULL PRIMARY KEY,
  uid           text NOT NULL UNIQUE,
  account_id    bigint NOT NULL REFERENCES accounts(id),
  created_at    timestamp with time zone NOT NULL DEFAULT now(),
  updated_at    timestamp with time zone NOT NULL DEFAULT now()
);
