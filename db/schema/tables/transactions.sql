SET search_path TO public;

DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE IF NOT EXISTS transactions (
  id          uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id  uuid NOT NULL UNIQUE,
  checksum    text NOT NULL,
  created_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transactions_created_at ON transactions(created_at);
