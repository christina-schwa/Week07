
/*
NOTES:
	- My pgAdmin is not working right now, so I cannot run any of these queries to make sure they work.
	- I realize that in some cases I did not need to specify the table for every column (e.g., "s" for "s.email"), but it helps me keep track of what I'm doing.
*/

/*1.	Create a new column called “status” in the rental table that uses a case statement to indicate if a film was returned late, early, or on time.*/
		SELECT rental_duration, 
				i.inventory_id, 
				rental_date, 
				return_date,
				CASE WHEN rental_duration > DATE_PART('day') THEN 'late'
				WHEN ental_duration < DATE_PART('day') THEN 'early'
				ELSE 'on time' END AS status
		FROM rental AS r
		JOIN inventory AS i
		ON r.inventory_id = i.inventory_id
		JOIN film AS f
		ON i.film_id = f.film_id;
	/**/

/*2.	Show the total payment amounts for people who live in Kansas City or Saint Louis.*/
		SELECT c1.city, SUM(p.amount) AS total_payment
		FROM city AS c1
		JOIN address AS a
		ON c1.city_id = a.city_id
		JOIN customer AS c2
		ON a.address_id = c2.address_id
		JOIN payment AS p
		ON p.customer_id = c2.customer_id
		WHERE city IN ('Kansas City', 'St. Louis')
		GROUP BY city;
	/**/

/*3.	How many film categories are in each category? Why do you think there is a table for category and a table for film category?*/
	
	/*Need to figure out what to group by...*/
		SELECT COUNT (f.film_id) AS number_of_film_categories, c.name
		FROM film_category AS f
		LEFT JOIN category AS c
		ON f.category_id = c.category_id
		GROUP BY c.name;

	/*The tables category and film category are like genre and subgenre. There are too many subgenres to look through. Also, some film categories (subgenres) may fit in multiple categories (genres).*/

/*4.	Show a roster for the staff that includes their email, address, city, and country (not ids).*/
		SELECT s.email, a.address, a.address2, c1.city, c2.country
		FROM staff AS s
		JOIN address AS a
		ON s.address_id = a.address_id
		JOIN city AS c1
		ON a.city_id = c1.city_id
		JOIN country AS c2
		ON c1.country_id = c2.country_id
		ORDER BY s.email;
	/**/

/*5.	Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005.*/
	/*Not completely sure which type of join to use... maybe inner?*/
		SELECT f.film_id, f.title, f.length
		FROM film AS f
		JOIN inventory AS i
		ON f.film_id = i.film_id
		JOIN rental AS r
		ON i.inventory_id = r.inventory_id
		WHERE r.return_date BETWEEN '2005-05-15' AND '2005-05-31';
	/**/

/*6.	Write a subquery to show which movies are rented below the average price for all movies.*/
		SELECT f.name, f.rental_rate AS price, 
		(SELECT AVG(rate) FROM f.rental_rate) AS avg_price
		FROM film AS f
		WHERE price < (SELECT AVG(rate) FROM f.rental_rate)
	/*I think everything I need for this is in the film table, so I don't know if a subquery is really necessary...*/

/*7.	Write a join statement to show which movies are rented below the average price for all movies.*/
		SELECT f.name, f.rental_rate AS price, AVG(f.rental_rate) AS avg_price
		FROM film AS f
		WHERE price < avg_price
	/*I'm not sure what tables to join. The price (rental_rate) is contained within the film table, nd I can take an average from that.*/

/*8.	Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.*/
	/*Still not 100% clear on explain plans or how to interpret them. I do know how to run one, but pgAdmin isn't working.*/

/*9.	With a window function, write a query that shows the film, its duration, and what percentile the duration fits into. This may help https://mode.com/sql-tutorial/sql-window-functions/#rank-and-dense_rank */
	/*Need to go back through Intermediate SQL Chapter 4 covers window functions.*/

/*10.	In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which sql and python are.*/
	/*
	Set-based programming is declarative. You tell the server what to do but not exactly how to do it internally.
	In procedural programming, you tell the server what to do and exactly how to do it (i.e., how to calculate results internally).
	SQL is a set-based language.
	Python is a procedural language.
	In procedural programming, you use loops, etc. to process data row by row. In set-based programming, you tell the system what columns of a data set to process and what actions to perform, but you don't have to loop over rows or specify how to calculate results internally. 
	*/
