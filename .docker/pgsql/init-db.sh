#!/bin/bash
set -e
set -u

function create_user_and_db() {
    local database=$1

    echo "Creating user and database '$database'"

    echo "User name $POSTGRES_USER"
    #CREATE USER $POSTGRES_USER;

    psql -v ON_ERROR_STOP=1 -U $POSTGRES_USER -d postgres <<-EOSQL
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO "$POSTGRES_USER";
EOSQL
}

if [ -n "$POSTGRES_DB_TEST" ]; then
    echo "Database(s) creation requested: $POSTGRES_DB_TEST"
    create_user_and_db $POSTGRES_DB_TEST
    echo "Database $POSTGRES_DB_TEST created"
fi

if [ -n "$POSTGRES_DB" ]; then
    echo "Database(s) creation requested: $POSTGRES_DB"
    create_user_and_db $POSTGRES_DB
    echo "Database $POSTGRES_DB created"
fi