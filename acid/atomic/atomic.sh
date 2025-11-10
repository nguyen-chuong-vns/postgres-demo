#!/usr/bin/env bash

# exit on error
set -e

function start_postgres () {
    echo "###### start postgres ######"
    docker run --name postgresql -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 arm64v8/postgres:12
    sleep 5
}

function setup_database () {
    start_postgres
    echo "###### Start Tx1: create table and insert 1Mil records ######"
    export PGPASSWORD=postgres
    sleep_time=$(/usr/bin/time -h -p psql -q -h localhost -p 5432 -U postgres -f data/insert.sql 2>&1 >/dev/null | grep real | awk '{print $2}' | awk -F '.' '{print $1}')
    echo "###### End Tx1 ######"

    echo "###### Start Tx2: truncate table and insert data in concurrent and break the insert process after $(($sleep_time / 2))s ######"
    psql -q -h localhost -p 5432 -U postgres -f data/insert.sql &
    sleep $(($sleep_time / 2))
    echo "###### Break the running Tx2 ######" 
    docker stop postgresql
    echo "###### End Tx2 ######"
}

function verify_atomic () {
    setup_database
    echo "###### Verify data after break the insert process ######"
    docker start postgresql
    sleep 5
    psql -h localhost -p 5432 -U postgres -c "SELECT * FROM users ORDER BY user_id DESC limit 10;"
    docker stop postgresql
    docker system prune -f
}
verify_atomic
