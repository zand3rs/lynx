-- sample account
INSERT INTO accounts(id, name, description)
  VALUES('aa1f89fa-de78-473b-bca0-9a3eb65a2045', 'Sample', 'Sample account');

-- create owner record for the system account
INSERT INTO owners(account_id, uid)
  VALUES('aa1f89fa-de78-473b-bca0-9a3eb65a2045', 'aa1f89fa-de78-473b-bca0-9a3eb65a2045');

-- create wallet for system account
INSERT INTO wallets(id, owner_id, name, description, principal, type)
  SELECT 'a05bd3b4-55fa-402d-8ce7-d6d63abc77b1', owners.id,
         'Sample Wallet', 'Sample mother wallet', true, 'account'
  FROM owners
  WHERE account_id::text = uid AND uid = 'aa1f89fa-de78-473b-bca0-9a3eb65a2045';
