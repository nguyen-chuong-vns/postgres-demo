CREATE TABLE IF NOT EXISTS users (
	user_id SERIAL PRIMARY KEY,
   first_name VARCHAR ( 50 ) UNIQUE NOT NULL,
   last_name VARCHAR ( 50 ) UNIQUE NOT NULL,
   age INT NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
   order_id varchar PRIMARY KEY,
   user_id INT NOT NULL,
   order_date varchar NOT NULL,
   order_amount INT NOT NULL,
   CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
     REFERENCES users(user_id)
);

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



do $$
DECLARE
order_id varchar;
user_id INT;

begin
for r in 1..10000 loop
order_id := 'order_id_' || r;
insert into orders(order_id, user_id, order_date, order_amount) VALUES (order_id, r, '2023-24-12', 40);
end loop;
end;
$$;
