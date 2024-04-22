Select * from employee

Select * from employee
order by levels Desc
limit 1

Select * from invoice

Select count(total) as c, billing_country from invoice
Group by billing_country
Order By c Desc;

Select total from invoice
order by total desc
Limit 3;


SELECT billing_city,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

Select customer.customer_id, first_name, last_name, sum(total) As 
total_spending from customer
Join  invoice ON customer.customer_id = invoice.customer_id
Group By Customer.customer_id
Order By total_spending Desc
Limit 1;

/* Q1: Write query to return the email, first name, last name, & 
Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */


Select * from customer
Select * from genre


Select distinct first_name, last_name, email from customer
Join invoice on customer.customer_id = invoice.customer_id
Join invoice_line on invoice.invoice_id = invoice_line.invoice_id
Join track On invoice_line.track_id = track.track_id
Join Genre on track.genre_id = genre.genre_id
Where genre.name like 'Rock'
Order By email;

/* Q2: Let's invite the artists who have written the most rock music 
in our dataset. 
Write a query that returns the Artist name 
and total track count of the top 10 rock bands. */

Select * from genre

Select Name from artist

Select artist.artist_id, artist.name, count(artist.artist_id) As no_of_songs
from track
Join Album on album.album_id = track.album_id
Join Artist on artist.artist_id = album.artist_id
Join genre on genre.genre_id = track.genre_id
Where genre.name Like 'Rock'
Group BY artist.artist_id
Order BY no_of_songs
Limit 10

/* Q3: Return all the track names that have a song 
length longer than the average song length. 
Return the Name and Milliseconds for each track. 
Order by the song length with the longest songs listed first. */

Select * from track 

Select name, milliseconds from track
where milliseconds >
(Select avg(milliseconds) AS avg_track_length from track)
Order By Milliseconds Desc;

/* Question Set 3 - Advance */
/* Q1: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */

WITH best_selling_artist AS (
Select artist.artist_id AS artist_id, artist.name AS artist_name, 
SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
FROM invoice_line
Join track ON track.track_id = invoice_line.track_id
Join album ON album.album_id = track.album_id
Join artist ON artist.artist_id = album.artist_id
Group By 1
Order By 3 Desc
Limit 1
)

Select c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM (il.unit_price*il.quantity)AS amount_spent
FROM invoice i
Join customer c ON c.customer_id = i.customer_id
Join invoice_line il ON il.invoice_id = i.invoice_id
Join track t ON t.track_id = il.track_id
Join album alb ON alb.album_id = t.album_id
Join best_selling_artist bsa ON bsa.artist_id = alb.artist_id
Group By 1,2,3,4
Order BY 5 Desc;

/* Q2: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns 
each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- 
first most popular music genre and second need data at country level. */

/* Method 1: Using CTE */

WITH popular_genre AS
(
 SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
 ROW_NUMBER () OVER (PARTITION BY customer.country ORDER BY COUNT (invoice_line.quantity)DESC)
AS RowNo

FROM invoice_line
Join invoice ON invoice.invoice_id = invoice_line.invoice_id
Join customer ON customer.customer_id = invoice.customer_id
Join track ON track.track_id = invoice_line.track_id
Join genre ON genre.genre_id = track.genre_id
GROUP BY 2,3,4
ORDER BY 2 ASC, 1 DESC
)

SELECT * FROM popular_genre WHERE RowNo <=1


/* Q3: Write a query that determines the customer that has spent the most on music 
for each country. 
Write a query that returns the country along with the top customer and 
how much they spent. 
For countries where the top amount spent is shared, provide all customers 
who spent this amount. */

/* Steps to Solve:  Similar to the above question. 
There are two parts in question- 
first find the most spent on music for each country and second 
filter the data for respective customers. */

/* Method 1: using CTE */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1
















