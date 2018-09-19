SET search_path TO private;

DROP TABLE IF EXISTS audit_logs CASCADE;
CREATE TABLE IF NOT EXISTS audit_logs (
  id          bigserial NOT NULL PRIMARY KEY,
  db_user     text NOT NULL,
  db_name     text NOT NULL,
  db_schema   text NOT NULL,
  db_table    text NOT NULL,
  operation   text NOT NULL,
  old_record  json,
  new_record  json,
  query       text NOT NULL,
  created_at  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX audit_logs_created_at ON audit_logs(created_at);
