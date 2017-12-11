#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage: $0 dbuser dbname dbpass [file.sql]"
    exit 1
fi

DBUSER=$1
DBNAME=$2
DBPASS=$3
SQLFILE=$4

if [ ! -z "$SQLFILE" ]; then
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f $SQLFILE
else
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/init.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/accounts.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/clients.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/owners.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/wallets.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/topups.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/transactions.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/credits.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/debits.sql
    PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -b -f schema/audit_logs.sql
fi

exit 0
