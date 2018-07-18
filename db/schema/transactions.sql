SET search_path TO public;

DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE IF NOT EXISTS transactions (
  id                 uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  reference_id       uuid UNIQUE,
  request_id         uuid NOT NULL UNIQUE,
  sender             uuid NOT NULL,
  recipient          uuid NOT NULL,
  amount             numeric(19,4) NOT NULL,
  remarks            text,
  operation          t_op NOT NULL DEFAULT 'COMMIT',
  signature          text NOT NULL UNIQUE,
  created_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
