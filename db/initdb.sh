#!/bin/bash

CWD=${0%/*}

DBHOST="localhost"
DBNAME="lynx"
DBUSER="lynx"
DBPASS="anbu"

while read -p "Continue initializing the database? (y/n): " confirm; do
  case $confirm in
    y|Y) break ;;
    n|N) exit 0 ;;
  esac
done

scripts=(
  "$CWD/schema/common.sql"
  "$CWD/schema/tables/accounts.sql"
  "$CWD/schema/tables/clients.sql"
  "$CWD/schema/tables/owners.sql"
  "$CWD/schema/tables/wallets.sql"
  "$CWD/schema/tables/topups.sql"
  "$CWD/schema/tables/transactions.sql"
  "$CWD/schema/tables/credits.sql"
  "$CWD/schema/tables/debits.sql"
  "$CWD/schema/tables/audit_logs.sql"
  "$CWD/schema/functions/log_changes.sql"
  "$CWD/schema/functions/log_transaction.sql"
  "$CWD/schema/functions/replay_transaction.sql"
  "$CWD/schema/functions/create_wallet.sql"
  "$CWD/schema/functions/debit_wallet.sql"
  "$CWD/schema/functions/credit_wallet.sql"
  "$CWD/schema/functions/process_transfer.sql"
  "$CWD/schema/functions/commit_transaction.sql"
  "$CWD/schema/functions/release_transaction.sql"
  "$CWD/schema/records/system.sql"
  "$CWD/schema/records/sample.sql"

)

for s in ${scripts[*]}; do
  $CWD/sql.sh -h$DBHOST -d$DBNAME -u$DBNAME -p$DBPASS $s
  [ "$?" != "0" ] && exit 1
done

exit 0
