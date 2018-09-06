CREATE OR REPLACE FUNCTION private.log_changes() RETURNS trigger AS $$
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

    INSERT INTO private.audit_logs(db_user, db_name, db_schema, db_table, operation, old_record, new_record, query, created_at)
      VALUES(current_user, current_catalog, TG_TABLE_SCHEMA::text, TG_TABLE_NAME::text, TG_OP::text, old_record, new_record, current_query(), now());

    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;
