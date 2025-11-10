CREATE OR REPLACE FUNCTION print_message(message TEXT)
RETURNS VOID AS $$
BEGIN
    RAISE NOTICE '%', message;
END;
$$ LANGUAGE plpgsql;

-- Tx 1
BEGIN;
SELECT print_message('Begin Tx1');
SELECT print_message('First select: SELECT first_name FROM users WHERE user_id = 1 -> first_name = first_name_1');
SELECT first_name FROM users WHERE user_id = 1;
SELECT pg_sleep(5);
SELECT print_message('Second select: SELECT first_name FROM users WHERE user_id = 1 -> Data is changed because of the update from Tx2: first_name = John');
SELECT first_name FROM users WHERE user_id = 1;
SELECT print_message('End Tx1');
COMMIT;
