USE sakila;
SELECT * FROM actor;

SELECT* FROM customer;

-- Total number of films
SELECT COUNT(*) AS total_films
FROM film;

-- Customers and their rental details(joins)
SELECT c.customer_id,last_name,rental_date,return_date,rental_id
FROM rental AS r 
INNER JOIN customer AS c
ON r.customer_id = c.customer_id;

-- films rented customer and the customers name
SELECT r.customer_id,c.last_name,f.title,f.description,r.rental_date
FROM film AS f
INNER JOIN inventory AS i 
ON f.film_id=i.inventory_id
INNER JOIN rental AS r
ON i.inventory_id =r.inventory_id
INNER JOIN customer AS c
ON c.customer_id = r.customer_id;

-- Top 5 films with the highest rental duration

SELECT
    f.title,
    SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(r.return_date, r.rental_date)))) AS period
FROM
    film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY period ASC
LIMIT 5;

-- Finding a customer that has not rented anything 
SELECT last_name,r.customer_id
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
WHERE r.customer_id IS NULL;

-- customers and times they rented a film
SELECT c.first_name,COUNT(r.customer_id) AS rental_count
FROM rental AS r
INNER JOIN customer AS c
ON r.customer_id=c.customer_id
GROUP BY first_name
ORDER BY rental_count DESC;

-- Retrieve the films that are available for rental.
SELECT fc.category_id,i.film_id,c.name AS category_name,f.title,i.inventory_id
FROM inventory AS i
INNER JOIN film_category AS fc
ON i.film_id=fc.film_id
INNER JOIN category AS c
ON c.category_id=fc.category_id
INNER JOIN film AS f
ON i.film_id=f.film_id
WHERE i.inventory_id NOT IN(SELECT inventory_id FROM rental);

-- film and how many they are in the inventorty
SELECT f.film_id, f.title,COUNT(*) AS occurrence_count
FROM film AS f
INNER JOIN inventory AS i 
ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

-- select all values from the rental table with null return dates
SELECT * FROM rental
WHERE return_date IS NULL;

-- replacing the return date with 'statement' if null for specific id
SELECT customer_id,rental_date,COALESCE(return_date,'Not yet returned') AS return_date
FROM rental
WHERE customer_id=155;


-- city that has more than one customer coming from it
SELECT city.city_id,city.city,COUNT(city.city_id) AS no_of_customers
 -- c.customer_id,a.address_id, 
FROM customer AS c
INNER JOIN address AS a
ON c.address_id=a.address_id
INNER JOIN city 
ON a.city_id = city.city_id
GROUP BY city_id
HAVING COUNT(city.city_id)>1;

-- city and number of customers
SELECT city.city,city.city_id,COUNT(city.city_id) AS count
 -- c.customer_id,a.address_id, 
FROM customer AS c
INNER JOIN address AS a
ON c.address_id=a.address_id
INNER JOIN city
ON city.city_id = a.city_id
GROUP BY city.city_id
HAVING count>1;

-- customer per store
SELECT COUNT(customer_id),store_id
FROM customer
GROUP BY store_id;

-- duplicating files
CREATE TABLE actor_duplicate 
AS
SELECT * FROM actor;

SELECT * FROM actor_duplicate;

-- dropping tables and procedures using if exists
DROP TABLE IF EXISTS actor_duplicate;

DROP PROCEDURE IF EXISTS DEL;

-- creating stored procedure that takes in parameters

DELIMITER //
CREATE PROCEDURE CALL_BY_NAME(IN P_FIRST_NAME VARCHAR(45))

BEGIN
SELECT FIRST_NAME,LAST_NAME 
FROM ACTOR 
WHERE FIRST_NAME = P_FIRST_NAME;
END //

DELIMITER ;

CALL CALL_BY_NAME("PENELOPE");
-- counting results using found_rows() function
SELECT FOUND_ROWS();



























