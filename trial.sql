use sakila;
select * from actor;

select* from customer;

-- Total number of films
select count(*) as total_films
from film;

-- Customers and their rental details(joins)
select c.customer_id,last_name,rental_date,return_date,rental_id
from rental as r 
inner join customer as c
on r.customer_id = c.customer_id;

-- films rented customer and the customers name
select r.customer_id,c.last_name,f.title,f.description,r.rental_date
from film as f
inner join inventory as i 
on f.film_id=i.inventory_id
inner join rental as r
on i.inventory_id =r.inventory_id
inner join customer as c
on c.customer_id = r.customer_id;

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
limit 5;

-- Finding a customer that has not rented anything 
select last_name,r.customer_id
from customer as c
left join rental as r on c.customer_id = r.customer_id
where r.customer_id is null;

-- customers and times they rented a film
select c.first_name,count(r.customer_id) as rental_count
from rental as r
inner join customer as c
on r.customer_id=c.customer_id
group by first_name
order by rental_count desc;

-- Retrieve the films that are available for rental.
select fc.category_id,i.film_id,c.name as category_name,f.title,i.inventory_id
from inventory as i
inner join film_category as fc
on i.film_id=fc.film_id
inner join category as c
on c.category_id=fc.category_id
inner join film as f
on i.film_id=f.film_id
where i.inventory_id not in(select inventory_id from rental);

-- film and how many they are in the inventorty
SELECT f.film_id, f.title,COUNT(*) AS occurrence_count
FROM film AS f
INNER JOIN inventory AS i 
ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

-- select all values from the rental table with null return dates
select * from rental
where return_date is null;

-- replacing the return date with 'statement' if null for specific id
select customer_id,rental_date,coalesce(return_date,'Not yet returned') as return_date
from rental
where customer_id=155;


-- city that has more than one customer coming from it
select city.city_id,city.city,count(city.city_id) as no_of_customers
 -- c.customer_id,a.address_id, 
from customer as c
inner join address as a
on c.address_id=a.address_id
inner join city 
on a.city_id = city.city_id
group by city_id
having count(city.city_id)>1;

-- city and number of customers
select city.city,city.city_id,count(city.city_id) as count
 -- c.customer_id,a.address_id, 
from customer as c
inner join address as a
on c.address_id=a.address_id
inner join city
on city.city_id = a.city_id
group by city.city_id
having count>1;

-- customer per store
select count(customer_id),store_id
from customer
group by store_id;

-- duplicating files
create table actor_duplicate 
as
select * from actor;

select * from actor_duplicate;

drop table if exists actor_duplicate;








