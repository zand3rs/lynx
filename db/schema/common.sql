DROP SCHEMA IF EXISTS private CASCADE;
CREATE SCHEMA IF NOT EXISTS private;

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA IF NOT EXISTS public;

SET search_path TO public;

DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TYPE IF EXISTS t_operation CASCADE;
CREATE TYPE t_operation AS ENUM ('commit', 'hold', 'release');

DROP TYPE IF EXISTS t_transfer CASCADE;
CREATE TYPE t_transfer AS (
  request_id        uuid,
  transaction_id    uuid,
  wallet_id         uuid,
  current_balance   numeric,
  available_balance numeric,
  updated_at        timestamp
);
