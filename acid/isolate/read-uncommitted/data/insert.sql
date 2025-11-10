BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS users (
	user_id serial PRIMARY KEY,
	first_name VARCHAR ( 50 ) UNIQUE NOT NULL,
    last_name VARCHAR ( 50 ) UNIQUE NOT NULL,
    age INT NOT NULL
);
truncate table users;
do $$
DECLARE
first_name varchar;
last_name varchar;

begin
for r in 1..10000 loop
first_name := 'first_name_' || r;
last_name := 'last_name_' || r;
insert into users(user_id, first_name, last_name, age) VALUES (r, first_name, last_name, 40);
end loop;
end;
$$;
COMMIT;
