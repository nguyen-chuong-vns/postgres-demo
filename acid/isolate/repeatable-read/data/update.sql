-- transaction 2
-- The initial name = 'first_name_1'
BEGIN TRANSACTION;
UPDATE users SET first_name = 'John' WHERE user_id = 1;
COMMIT;
