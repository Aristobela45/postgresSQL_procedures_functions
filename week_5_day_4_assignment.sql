-- Tonight create two procedures that do the following:

-- 1. Create a procedure that adds a late fee to any customer who returned their rental after 7 days.
-- Use the payment and rental tables.
CREATE PROCEDURE late_fee()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE payment
	SET amount = amount + 2
	WHERE rental_id IN (
		SELECT rental_id
		FROM rental
		WHERE rental_duration > INTERVAL '7 days'
	);
END;
$$;

CALL late_fee();

SELECT *
FROM rental
ORDER BY rental_id DESC;


-- 2. Add a new column in the customer table for Platinum Member. This can be a boolean.
-- Platinum Members are any customers who have spent over $200. 
-- Create a procedure that updates the Platinum Member column to True for any customer who has spent over $200 and False for any customer who has spent less than $200.
-- Use the payment and customer table.
ALTER TABLE customer
ADD COLUMN platinum_member

SELECT *
FROM customer;

CREATE PROCEDURE update_platinum_member()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET platinum_member = true
	WHERE customer_id IN (
		SELECT customer_id
		FROM (
			SELECT customer_id
			GROUP BY customer_id
		) AS customer_totals
		WHERE total_amount > 200
);
END;
$$:

CALL update_platinum_member();
SELECT *
FROM customer
WHERE platinum_member
	
