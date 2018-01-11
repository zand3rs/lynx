SET search_path TO public;

DROP TABLE IF EXISTS lynx.audit_logs CASCADE;
CREATE TABLE IF NOT EXISTS lynx.audit_logs (
  id          bigserial NOT NULL PRIMARY KEY,
  db_user     text NOT NULL,
  db_name     text NOT NULL,
  db_schema   text NOT NULL,
  db_table    text NOT NULL,
  operation   text NOT NULL,
  old_record  json,
  new_record  json,
  query       text NOT NULL,
  created_at  timestamp with time zone NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION lynx.log_changes() RETURNS trigger AS $$
  DECLARE
    old_record json := NULL;
    new_record json := NULL;

  BEGIN
    IF TG_OP IN('INSERT', 'UPDATE') THEN
      new_record := row_to_json(NEW.*);
    END IF;

    IF TG_OP IN('DELETE', 'UPDATE') THEN
      old_record := row_to_json(OLD.*);
    END IF;

    INSERT INTO lynx.audit_logs(db_user, db_name, db_schema, db_table, operation, old_record, new_record, query, created_at)
      VALUES(current_user, current_catalog, TG_TABLE_SCHEMA::text, TG_TABLE_NAME::text, TG_OP::text, old_record, new_record, current_query(), now());

    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS log_changes ON accounts;
DROP TRIGGER IF EXISTS log_changes ON clients;
DROP TRIGGER IF EXISTS log_changes ON credits;
DROP TRIGGER IF EXISTS log_changes ON debits;
DROP TRIGGER IF EXISTS log_changes ON topups;
DROP TRIGGER IF EXISTS log_changes ON transactions;
DROP TRIGGER IF EXISTS log_changes ON owners;
DROP TRIGGER IF EXISTS log_changes ON wallets;

CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON accounts
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON clients
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON credits
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON debits
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON topups
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON transactions
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON owners
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER log_changes AFTER INSERT OR UPDATE OR DELETE ON wallets
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();

