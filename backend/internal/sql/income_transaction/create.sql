INSERT INTO income_transaction (date, description, source, amount)
VALUES ($1, $2, $3, $4)
RETURNING ID;