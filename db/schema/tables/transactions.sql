SET search_path TO public;

DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE IF NOT EXISTS transactions (
  id          uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id  uuid NOT NULL UNIQUE,
  type        t_tran_type NOT NULL,
  checksum    text NOT NULL,
  created_at  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transactions_created_at ON transactions(created_at);
