-- transaction 2 (starts immediately after the start of transaction 1)

BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT first_name FROM users WHERE user_id = 1; --The value 'John' is read
COMMIT;
