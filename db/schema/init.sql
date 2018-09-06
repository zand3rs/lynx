DROP SCHEMA IF EXISTS private CASCADE;
CREATE SCHEMA IF NOT EXISTS private;

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA IF NOT EXISTS public;

SET search_path TO public;

DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TYPE IF EXISTS t_op CASCADE;
CREATE TYPE t_op AS ENUM ('COMMIT', 'HOLD', 'RELEASE');

DROP TYPE IF EXISTS t_status CASCADE;
CREATE TYPE t_status AS ENUM ('SUCCESS', 'FAIL', 'PENDING', 'PROCESSING');
