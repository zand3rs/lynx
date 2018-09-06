SET search_path TO public;

DROP TRIGGER IF EXISTS record_history ON accounts;
DROP TRIGGER IF EXISTS record_history ON clients;
DROP TRIGGER IF EXISTS record_history ON credits;
DROP TRIGGER IF EXISTS record_history ON debits;
DROP TRIGGER IF EXISTS record_history ON topups;
DROP TRIGGER IF EXISTS record_history ON transactions;
DROP TRIGGER IF EXISTS record_history ON owners;
DROP TRIGGER IF EXISTS record_history ON wallets;

CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON accounts
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON clients
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON credits
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON debits
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON topups
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON transactions
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON owners
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();
CREATE TRIGGER record_history AFTER INSERT OR UPDATE OR DELETE ON wallets
  FOR EACH ROW EXECUTE PROCEDURE lynx.log_changes();

