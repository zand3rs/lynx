-- system account
INSERT INTO accounts(id, name, description, type)
  VALUES('8000aa13-09f1-4130-82ef-26cf1a262623', 'Lynx', 'System account', 'system');

-- create owner record for the system account
INSERT INTO owners(account_id, uid)
  VALUES('8000aa13-09f1-4130-82ef-26cf1a262623', '8000aa13-09f1-4130-82ef-26cf1a262623');

-- create wallet for system account
INSERT INTO wallets(id, owner_id, name, description, principal, type)
  SELECT '7ee7c406-5325-4eee-b066-b3021a9f36ad', owners.id,
         'Lynx Wallet', 'System mother wallet', true, 'system'
  FROM owners
  WHERE account_id::text = uid AND uid = '8000aa13-09f1-4130-82ef-26cf1a262623';
