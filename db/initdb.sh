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
  "schema/common.sql"
  "schema/tables/accounts.sql"
  "schema/tables/clients.sql"
  "schema/tables/owners.sql"
  "schema/tables/wallets.sql"
  "schema/tables/topups.sql"
  "schema/tables/transactions.sql"
  "schema/tables/credits.sql"
  "schema/tables/debits.sql"
  "schema/functions/log_transaction.sql"
  "schema/functions/replay_transaction.sql"
  "schema/functions/create_wallet.sql"
  "schema/functions/debit_wallet.sql"
  "schema/functions/credit_wallet.sql"
  "schema/functions/process_transfer.sql"
  "schema/functions/commit_transaction.sql"
  "schema/functions/release_transaction.sql"
  "schema/records/system.sql"
  "schema/records/sample.sql"
)

for s in ${scripts[*]}; do
  ./sql.sh -h$DBHOST -d$DBNAME -u$DBNAME -p$DBPASS $s 
  [ "$?" != "0" ] && exit 1
done

exit 0
