#!/bin/bash

SQL_OPTIONS=""
SQL_SCRIPT=""
DB_PASS=""

usage() {
  echo "Usage:"
  echo "    $0 [options] <sql-script>"
  echo "options:"
  echo "    -h <host>"
  echo "    -d <dbname>"
  echo "    -u <user>"
  echo "    -p <pass>"
  exit 1
}

while getopts ":h:d:u:p:h" opt; do
  case ${opt} in
    h)
      SQL_OPTIONS="$SQL_OPTIONS -h$OPTARG"
      ;;
    d)
      SQL_OPTIONS="$SQL_OPTIONS -d$OPTARG"
      ;;
    u)
      SQL_OPTIONS="$SQL_OPTIONS -U$OPTARG"
      ;;
    p)
      DB_PASS="$OPTARG"
      ;;
    h|\?)
      usage
      ;;
  esac
done
shift $((OPTIND -1))

if [ $# -gt 0 ]; then
  SQL_SCRIPT="$1"
fi

if [ -z "$SQL_SCRIPT" ]; then
  usage
fi

## check if directory
if [ -d "$SQL_SCRIPT" ]; then
  SQL_SCRIPT="${SQL_SCRIPT%/}/*"
fi

## execute script
for SQL in $SQL_SCRIPT; do
  if [ -f "$SQL" ]; then
    echo "Executing $SQL..."
    PGPASSWORD=$DB_PASS psql $SQL_OPTIONS -b -f $SQL
  fi
done

exit 0
