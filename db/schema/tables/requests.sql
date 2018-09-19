SET search_path TO public;

DROP TABLE IF EXISTS requests CASCADE;
CREATE TABLE IF NOT EXISTS requests (
  id          uuid NOT NULL,
  checksum    text NOT NULL,
  created_at  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(id, checksum)
);

CREATE INDEX requests_created_at ON requests(created_at);
