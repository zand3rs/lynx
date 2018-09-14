SET search_path TO public;

DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE IF NOT EXISTS transactions (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference_id       uuid REFERENCES transactions(id),
  request_id         uuid NOT NULL UNIQUE,
  sender             uuid NOT NULL,
  recipient          uuid NOT NULL,
  amount             numeric(19,4) NOT NULL,
  remarks            text,
  operation          t_operation NOT NULL DEFAULT 'commit',
  created_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX transactions_reference_id ON transactions(reference_id);
CREATE INDEX transactions_created_at ON transactions(created_at);
