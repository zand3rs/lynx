DROP DATABASE IF EXISTS lynx;
DROP USER IF EXISTS lynx;

CREATE USER lynx PASSWORD 'anbu' SUPERUSER;
CREATE DATABASE lynx OWNER lynx;
