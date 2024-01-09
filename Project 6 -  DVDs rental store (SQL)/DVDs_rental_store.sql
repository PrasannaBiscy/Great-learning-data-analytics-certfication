
use film_rental;
show tables;



-- 1) What is the total revenue generated from all rentals in the database? 

SELECT SUM(AMOUNT) FROM PAYMENT;

-- 2) How many rentals were made in each month_name?

SELECT  DATE_FORMAT(RENTAL_DATE, "%M") AS month_name, 
count(DATE_FORMAT(RENTAL_DATE, "%M")) AS total_rentals
FROM RENTAL
GROUP BY month_name;

-- 3) What is the rental rate of the film with the longest title in the database? 

select title,length(title), rental_rate from film 
where length(title) = (select max(length(title)) from film);

-- 4) What is the average rental rate for films that were taken from the last 30 days from the date("2005-05-05 22:04:30")? 

SELECT AVG(FILM.RENTAL_RATE) FROM FILM
JOIN INVENTORY ON FILM.FILM_ID = INVENTORY.FILM_ID
JOIN RENTAL ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
WHERE RENTAL.RENTAL_DATE IN
(SELECT RENTAL_DATE FROM RENTAL 
WHERE RENTAL_DATE BETWEEN "2005-05-05 22:04:30" AND DATE_ADD("2005-05-05 22:04:30",INTERVAL 30 DAY)
ORDER BY RENTAL.RENTAL_DATE);

-- 5) What is the most popular category of films in terms of the number of rentals? 

select category.name , count(rental.rental_id) from category 
join film_category using (category_id) 
join film  using (film_id) 
join inventory using (film_id) 
join rental using (inventory_id)
group by category.name
order by count(rental.rental_id) desc
limit 1;
 
-- 6) Find the longest movie duration from the list of films that have not been rented by any customer.

select length, rental_duration from film where rental_duration = 0; 

select film.title, film.length, film.rental_duration from film 
left join inventory using (film_id)
where  inventory.inventory_id is null
order by film.length desc
limit 1; 

-- 7) What is the average rental rate for films, broken down by category? 

select category.name,avg(film.rental_rate) from film 
join film_category on film.film_id =  film_category.film_id
join category on film_category.category_id = category.category_id 
group by category.name ;

-- 8) What is the total revenue generated from rentals for each actor in the database? 

select actor.actor_id,concat(actor.first_name,' ',actor.last_name),sum(payment.amount) from actor
join film_actor on actor.actor_id = film_actor.actor_id
join film on film_actor.film_id = film.film_id
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by actor.actor_id,concat(actor.first_name,' ',actor.last_name)
order by actor.actor_id;


-- 9) Show all the actresses who worked in a film having a "Wrestler" in the description. 

select distinct concat(actor.first_name,' ',actor.last_name) as NAME from film 
join film_actor using (film_id) 
join actor  using (actor_id)
where film.description like "%Wrestler%";


-- 10) Which customers have rented the same film more than once? 

SELECT CUSTOMER.FIRST_NAME,CUSTOMER.CUSTOMER_ID, FILM.FILM_ID, COUNT(FILM.FILM_ID) FROM CUSTOMER 
JOIN RENTAL ON CUSTOMER.CUSTOMER_ID = RENTAL.CUSTOMER_ID
JOIN INVENTORY ON RENTAL.INVENTORY_ID = INVENTORY.INVENTORY_ID
JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
GROUP BY CUSTOMER.FIRST_NAME, FILM.FILM_ID,CUSTOMER.CUSTOMER_ID
HAVING COUNT(FILM.FILM_ID)>1
ORDER BY CUSTOMER.CUSTOMER_ID;

-- 11) How many films in the comedy category have a rental rate higher than the average rental rate? 

SELECT COUNT(FILM.FILM_ID) AS "NO. OF COMEDY FILMS HAVING ABOVE AVERAGE RENTAL_RATE" FROM FILM 
JOIN FILM_CATEGORY ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID
WHERE RENTAL_RATE > (SELECT AVG(RENTAL_RATE) FROM FILM)
AND FILM_CATEGORY.CATEGORY_ID = (SELECT CATEGORY_ID FROM CATEGORY WHERE NAME = "COMEDY");

-- 12) Which films have been rented the most by customers living in each city? 

SELECT CUSTOMER.CUSTOMER_ID, CITY.CITY, FILM.TITLE, MAX(FILM.RENTAL_DURATION) FROM CITY
JOIN ADDRESS ON CITY.CITY_ID = ADDRESS.CITY_ID
JOIN CUSTOMER ON ADDRESS.ADDRESS_ID = CUSTOMER.ADDRESS_ID
JOIN RENTAL ON CUSTOMER.CUSTOMER_ID = RENTAL.CUSTOMER_ID
JOIN INVENTORY ON RENTAL.INVENTORY_ID = INVENTORY.INVENTORY_ID
JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
WHERE FILM.RENTAL_DURATION = (SELECT MAX(RENTAL_DURATION) FROM FILM)
GROUP BY CUSTOMER.CUSTOMER_ID, CITY.CITY, FILM.TITLE
ORDER BY CITY.CITY;

-- 13) What is the total amount spent by customers whose rental payments exceed $200? 

CREATE VIEW CUS_200_vw as
SELECT CUSTOMER_ID,SUM(AMOUNT) as AMT FROM PAYMENT 
GROUP BY CUSTOMER_ID
HAVING SUM(AMOUNT) > 200;

SELECT SUM(AMT) FROM CUS_200_vw;


-- 14) Display the fields which are having foreign key constraints related to the "rental" table. [Hint: using Information_schema] 

SELECT COLUMN_NAME, 'Rental' AS column_source
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'film_rental' -- Replace with your database name
AND TABLE_NAME = 'Rental'   -- Replace with your table name
AND COLUMN_NAME IS NOT NULL;


-- 15) Create a View for the total revenue generated by each staff member, broken down by store city with the country name. 

CREATE VIEW staffwise_total_revenue_vw as
select staff.first_name,city.city,country.country,sum(payment.amount) from payment
join staff on payment.staff_id = staff.staff_id
join address on staff.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
group by staff.first_name,city.city,country.country;

SELECT * FROM staffwise_total_revenue_vw ;


-- 16) Create a view based on rental information consisting of visiting_day, customer_name, the title of the film,  no_of_rental_days, the amount paid by the customer along with the percentage of customer spending. 


CREATE VIEW RENTAL_INFO_view as
SELECT PAYMENT.PAYMENT_DATE as 'DATE & TIME',DAYNAME(PAYMENT.PAYMENT_DATE) as DAY , CUSTOMER.FIRST_NAME as CUSTOMER_NAME, 
FILM.TITLE as FILM_TITLE, DATEDIFF(RENTAL.RETURN_DATE,RENTAL.RENTAL_DATE) as RENTAL_DURATION, PAYMENT.AMOUNT as AMOUNT_PAID, (PAYMENT.AMOUNT/(SELECT SUM(AMOUNT) FROM PAYMENT))*100 as PERCENTAGE_OUT_OF_100
FROM PAYMENT
JOIN RENTAL ON PAYMENT.RENTAL_ID = RENTAL.RENTAL_ID
JOIN CUSTOMER ON RENTAL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
JOIN INVENTORY ON RENTAL.INVENTORY_ID = INVENTORY.INVENTORY_ID
JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID;


-- 17) Display the customers who paid 50% of their total rental costs within one day. 

SELECT CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME AS CUSTOMER_NAME,SUM(PAYMENT.AMOUNT),PAYMENT.AMOUNT
FROM PAYMENT
JOIN RENTAL ON PAYMENT.RENTAL_ID = RENTAL.RENTAL_ID
JOIN CUSTOMER ON RENTAL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
GROUP BY CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME,PAYMENT.AMOUNT
HAVING PAYMENT.AMOUNT = 0.5*(SUM(PAYMENT.AMOUNT));

-- ------------------------------------------------------------------------------------------------------------------------------