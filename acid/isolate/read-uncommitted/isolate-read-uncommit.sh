#!/usr/bin/env bash

# exit on error
set -ex

# run docker
docker run --rm --name postgresql -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 arm64v8/postgres
sleep 5

# create table and insert data
export PGPASSWORD=postgres
psql -h localhost -p 5432 -U postgres -f data/insert.sql

# update data
psql -h localhost -p 5432 -U postgres -f data/update.sql &
sleep 2
# select data to read uncommitted data
psql -h localhost -p 5432 -U postgres -f data/select.sql

sleep 100

# stop container
docker stop postgresql
