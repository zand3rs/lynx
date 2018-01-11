SET search_path TO public;

DROP TABLE IF EXISTS accounts CASCADE;
CREATE TABLE IF NOT EXISTS accounts (
  id            uuid NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          text NOT NULL UNIQUE,
  description   text,
  created_at    timestamp with time zone NOT NULL DEFAULT now(),
  updated_at    timestamp with time zone NOT NULL DEFAULT now()
);

INSERT INTO accounts(name, description) VALUES('Lynx', 'System account');
