SELECT *
FROM payment;

--example of a storeed procedure

CREATE PROCEDURE lateFee(
	cust_id INTEGER, -- cusotmer_id
	pay_id INTEGER, --payment_id
	late_fee_amount DECIMAL(5,2) -- amount to the payment amount
	
)
LANGUAGE plpgsql --gets stored and lets other users know what language you're running your queries anf procedures in
AS $$ --literal string quoting, storing the below query in a string literal to be run when we call the procedure
BEGIN
		--add late fee to customer payment amount
		UPDATE payment
		SET amount = amount + late_fee_amount
		WHERE customer_id = cust_id AND payment_id = pay_id;
		
		--commit the above statement inside of our procedure transaction
		COMMIT;

END;
$$;

--procedure are stored in left column with tables
SELECT *
FROM payment
WHERE payment_id = 17503;
--calling a stored procedure
CALL lateFee(341, 17503, 2.00);

--DELETE/DROP procedure
DROP PROCEDURE lateFee;

SELECT district, postal_code, city.city
FROM address
INNER JOIN city
ON address.city_id = city.city_id
WHERE district = 'Texas';
--create a procedure to update an addresses postalcode based on the city

CREATE OR REPLACE PROCEDURE update_postal(
	city_name VARCHAR, --city to be updated
	zipcode VARCHAR -- zipcode argument
		
)
LANGUAGE plpgsql -- gets strored and lets other users know what language you're running your queries and procedures in
AS $$ -- literal string quoting, storing the below query in a string literal to be run when we call the procedure
BEGIN
		--Add a late fee to customer payment amount
		UPDATE address
		SET postal_code = zipcode
		WHERE city_id IN(
			SELECT city_id
			FROM city
			WHERE city = city_name
		);

		
		--Commit the above statement inside of our procedure transaction
		COMMIT;
END;
$$;

CALL update.postal2('Arlington', '11111');


CREATE OR REPLACE FUNCTION add_actor(_actor_id INTEGER, _first_name VARCHAR,_last_name VARCHAR, _last_update TIMESTAMP WITHOUT TIME ZONE)
RETURNS void
LANGUAGE plpgsql;
AS $MAIN$
BEGIN
	INSERT INTO actor
	VALUES(_actor_id, _first_name, _last_name, _last_update);
END;
$MAIN$;

--DO NOT 'CALL' a FUNCTION -- select it
--icky bad for poo poo function call
CALL add_actor(500, 'name', 'last_name', CURRENT_TIMESTAMP)

--really cool neat and correctr fucntion call
SELECT add_actor(500, 'Orlando', 'Bloom', NOW()::timestamp);
			

SELECT *
FROM actor
WHERE actor_id = 500;

CREATE OR REPLACE FUNCTION zip_code_calc()
RETURNS INTEGER
AS $$
BEGIN
	RETURN FLOOR(RANDOM() * (8000 + 73301)) + 73301;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_texas_zipcode()
LANGUAGE plpgsql
AS $$
BEGIN

	UPDATE address
	SET postal_code = zip_code_calc()
	WHERE district = 'Texas';
	
	COMMIT;
END;
$$;

CALL update_texas_zipcode();



SELECT district, postal_code, city.city, address
FROM address
INNER JOIN city
ON address.city_id = city.city_id
WHERE district = 'Texas';













