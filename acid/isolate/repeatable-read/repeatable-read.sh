#!/usr/bin/env bash

# exit on error
set -e

function start_postgres () {
    echo "###### start postgres ######"
    docker run --rm --name postgresql -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 arm64v8/postgres:12
	sleep 5
}

function setup() {
    start_postgres
	sleep 5
    echo "###### create table and insert sample data ######"
	export PGPASSWORD=postgres
	psql -q -h localhost -p 5432 -U postgres -f data/insert.sql 
}

function update() {
    sleep 2
    echo "###### Begin Tx2 running concurrent with Tx1: UPDATE users SET first_name = 'John' WHERE user_id = 1; ######"
	psql -q -h localhost -p 5432 -U postgres -f data/update.sql
}

function cleanup() {
    sleep 10
    echo "###### clean up demo ######"
	docker stop postgresql
    echo "finish demo"
}

function isolate() {
    echo "###### DEMO ISOLATION LEVEL: REPEATABLE READ ######"
    setup
	psql -q -h localhost -p 5432 -U postgres -f data/select.sql &
    update
    cleanup
}

function no_isolate() {
    echo "###### DEMO NO ISOLATION ######"
	setup
	psql -q -h localhost -p 5432 -U postgres -f data/select-no-isolate.sql &
    update
    cleanup
}
no_isolate
echo "    "
echo "    "
echo "    "
isolate
