#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 dbuser dbname dbpass"
    exit 1
fi

DBUSER=$1
DBNAME=$2
DBPASS=$3

# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f init.sql

# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/init.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/accounts.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/clients.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/topups.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/transactions.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/credits.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/debits.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/users.sql
# PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/wallets.sql

PGPASSWORD=$DBPASS psql -U $DBUSER -d $DBNAME -a -f schema/audit_logs.sql

