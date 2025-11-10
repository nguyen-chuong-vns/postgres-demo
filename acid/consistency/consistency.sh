#!/usr/bin/env bash

# exit on error
set -e

function start_postgres () {
    echo "###### start postgres ######"
    docker run --rm --name postgresql -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 arm64v8/postgres:12
	sleep 5
}

function setup_consistency() {
    start_postgres
    echo "###### create table and insert CONSISTENCY data ######"
	export PGPASSWORD=postgres
	psql -q -h localhost -p 5432 -U postgres -f data/setup_consistency.sql
}

function setup_un_consistency() {
    start_postgres
    echo "###### Create table and insert UN CONSISTENCY data ######"
	export PGPASSWORD=postgres
	psql -q -h localhost -p 5432 -U postgres -f data/setup_un_consistency.sql
}

function delete() {
    sleep 2
    echo "###### Delete a record: DELETE FROM users WHERE user_id = 1 ######"
	psql -q -h localhost -p 5432 -U postgres -f data/delete.sql
}

function verify() {
    echo ""###### Verify data after deleted "######"
    psql -h localhost -p 5432 -U postgres -c "SELECT * FROM users WHERE user_id=1;"
}

function cleanup() {
    sleep 10
    echo "###### clean up ######"
	docker stop postgresql
    echo "finish demo"
}

function consistency() {
    echo "###### DEMO consistency ######"
    setup_consistency
    delete
    verify
    cleanup
}

function un_consistency() {
    echo "###### DEMO UN consistency ######"
    setup_un_consistency
    delete
    verify
    cleanup
}
consistency
un_consistency
