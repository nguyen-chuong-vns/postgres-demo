-- transaction 1
-- The initial name = 'first_name_1'
BEGIN TRANSACTION;
UPDATE users SET first_name = 'John' WHERE user_id = 1;
SELECT pg_sleep_for('5 minutes');
ROLLBACK;
