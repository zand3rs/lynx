#!/bin/bash

DBHOST="localhost"
DBNAME="lynx"
DBUSER="lynx"
DBPASS="anbu"

while read -p "Continue initializing the database? (y/n): " confirm; do
  case $confirm in
    y|Y) break ;;
    n|N) exit 1 ;;
  esac
done

scripts=(
  "schema/init.sql"
  "schema/tables/accounts.sql"
  "schema/tables/clients.sql"
  "schema/tables/owners.sql"
  "schema/tables/wallets.sql"
  "schema/tables/topups.sql"
  "schema/tables/transactions.sql"
  "schema/tables/credits.sql"
  "schema/tables/debits.sql"
  #"schema/tables/audit_logs.sql"
  #"schema/functions/log_changes.sql"
  #"schema/triggers/record_history.sql"
)

for s in ${scripts[*]}; do
  ./sql.sh -h$DBHOST -d$DBNAME -u$DBNAME -p$DBPASS $s 
done

exit 0
