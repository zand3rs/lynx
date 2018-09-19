-- set system account's wallet balance
UPDATE wallets SET current_balance=1000000, available_balance=1000000
  WHERE id='7ee7c406-5325-4eee-b066-b3021a9f36ad';

-- sample account
INSERT INTO accounts(id, name, description)
  VALUES('aa1f89fa-de78-473b-bca0-9a3eb65a2045', 'Sample', 'Sample account');

-- create owners for the sample account
INSERT INTO owners(account_id, uid)
  VALUES('aa1f89fa-de78-473b-bca0-9a3eb65a2045', 'aa1f89fa-de78-473b-bca0-9a3eb65a2045');

INSERT INTO owners(account_id, uid)
  VALUES('aa1f89fa-de78-473b-bca0-9a3eb65a2045', 'a18fa94c-5f56-4b3b-bd38-18b9977d4f88');

INSERT INTO owners(account_id, uid)
  VALUES('aa1f89fa-de78-473b-bca0-9a3eb65a2045', 'a28fa94c-5f56-4b3b-bd38-18b9977d4f88');

-- create mother wallet for sample account
INSERT INTO wallets(id, owner_id, name, description, principal, type, current_balance, available_balance)
  SELECT 'a05bd3b4-55fa-402d-8ce7-d6d63abc77b1', owners.id,
         'Sample Mother Wallet', 'Sample mother wallet', true, 'account', 100000, 100000
  FROM owners
  WHERE uid = 'aa1f89fa-de78-473b-bca0-9a3eb65a2045';

-- create wallets for sample account
INSERT INTO wallets(id, owner_id, name, description, current_balance, available_balance)
  SELECT 'a15bd3b4-55fa-402d-8ce7-d6d63abc77b1', owners.id,
         'Sample Wallet 1', 'Sample wallet 1', 10000, 10000
  FROM owners
  WHERE uid = 'a18fa94c-5f56-4b3b-bd38-18b9977d4f88';

INSERT INTO wallets(id, owner_id, name, description, current_balance, available_balance)
  SELECT 'a25bd3b4-55fa-402d-8ce7-d6d63abc77b1', owners.id,
         'Sample Wallet 2', 'Sample wallet 2', 10000, 10000
  FROM owners
  WHERE uid = 'a28fa94c-5f56-4b3b-bd38-18b9977d4f88';
