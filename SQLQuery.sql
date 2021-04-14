
--Chapter 13

/*
b. *) Find the customer details (‘cust_name’ and ‘cust_contact’) who did not order items ‘TNT2’ or ‘SLING’. 
Be sure to implement subqueries.
*/


select * from Customers
select * from Orders
select * from Orderitems

select cust_name, cust_contact, cust_id
from Customers
where cust_id not in (select cust_id
					 from Orders
				     where order_num in ( select order_num 
										from Orderitems
										where prod_id  in ('TNT2','SLING')
										)
				  )

/*
d. *) Find all the customers that did not place any orders. Use a ‘not in’ clause.
*/

select * from Customers
select * from Orders
select * from Orderitems

select * 
from Customers
where cust_id not in ( select cust_id	
					   from Orders)
/*					   where order_num in ( select order_num 
											from Orderitems)
											)
											*/


/*
e. Find all the customers that did not place any orders. Use a ‘not exists’ clause.
*/

select * from Customers
select * from Orders

-- not exist
select cust_id , cust_name
from Customers
where not exists( select *
from Orders
where Customers.cust_id = Orders.cust_id)


/*
f. Find the customer name and ID for any customer who did not made orders in the month of September 2005.
Use an ‘exists’ clause in your query. Store your results in a temporary table. 
After that copy the result from the temporary table to a permanent table ((include your student number in the table name). 
List all records from the tables you have just created. After that drop the temporary table and the permanent table.
*/


select * from Customers
select * from Orders

SELECT cust_name, cust_id
into #temp
FROM customers
WHERE EXISTS (SELECT *
FROM orders
WHERE DateDiff(month, order_date,'2005-09-01') != 0
--DateName(month, order_date)  != 'September' and DatePart(year,order_date) != 2005
AND customers.cust_id = orders.cust_id)


select * from #temp

--copying temporary table to permanent 

SELECT * INTO dbo.customers_2046068 FROM #temp

select * from customers_2046068

drop table #temp
drop table customers_2046068

/*
g. *) In the table ‘patstat_golden_set’, publications are listed and assigned to clusters (1-100). 
Write a query that will find the cluster_id with the highest number of publications. 
List both the cluster_id and the total number of publications in your result
*/


select * from Patstat_golden_set


SELECT cust_name,
cust_state,
(SELECT Count(*)
FROM orders
WHERE orders.cust_id = customers.cust_id) AS orders
FROM customers
ORDER BY cust_name

select top 1 cluster_id, count(*) as Total_number_of_publications
from Patstat_golden_set
group by cluster_id
order by Total_number_of_publications desc



--Chapter 14
--a. Read Chap. 14 (& do the book’s practical lessons if needed). 

select * from vendors
select * from products
SELECT vend_name, prod_name, prod_price
FROM vendors, products
WHERE vendors.vend_id = products.vend_id
ORDER BY vend_name, prod_name;

--b. *) Find the Cartesian product of customers and order. Order the records by cust_id, and order_num. 
select * from customers
select * from orders

select * 
from customers, orders
order by customers.cust_id, order_num
/*
c. *) Recreate the query on page 126 by a query that uses an (inner) join clause instead of a where clause. 
Be sure to use alias names for the tables (e.g. labels ‘a’ and ‘b’). 
*/

SELECT vend_name, prod_name, prod_price
FROM vendors, products
WHERE vendors.vend_id = products.vend_id
ORDER BY vend_name, prod_name;

select vend_name, prod_name, prod_price
from vendors as a inner join products as b
on a.vend_id = b.vend_id
order by vend_name, prod_name;

--d. *) List all the prod_id’s that where ordered by the customer ‘Coyote Inc.’ Order the result by prod_id.


select prod_id
from orderitems inner join ( select order_num from orders inner join customers
on orders.cust_id = customers.cust_id and customers.cust_name = 'Coyote Inc.') as order_num_inner_join
on orderitems.order_num = order_num_inner_join.order_num
order by prod_id


--Chapter 15

--b. *) Find all the customers that did not place any orders. Use a specific type of join.

SELECT *
FROM customers LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id 
where orders.order_num is null

----------------------------------------------Eg:
--Using subquery
SELECT prod_id, prod_name, vend_id
FROM products
WHERE vend_id = (SELECT vend_id
FROM products
WHERE prod_id = 'DTNTR');
---using join

SELECT p1.prod_id, p1.prod_name,p1.vend_id
FROM products AS p1, products AS p2
WHERE p1.vend_id = p2.vend_id
AND p2.prod_id = 'DTNTR';

--Natural join
SELECT c.*, o.order_num, o.order_date,
oi.prod_id, oi.quantity, OI.item_price
FROM customers AS c, orders AS o, orderitems AS oi
WHERE c.cust_id = o.cust_id
AND oi.order_num = o.order_num
AND prod_id = 'FB';

--- Outer join

SELECT customers.cust_id, orders.order_num
FROM customers INNER JOIN orders
ON customers.cust_id = orders.cust_id;

SELECT customers.cust_id, orders.order_num
FROM customers LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id;

SELECT customers.cust_id, orders.order_num
FROM customers RIGHT OUTER JOIN orders
ON customers.cust_id = orders.cust_id;
--------------------------------------------------
/*
c. Create a full outer join between the tables customer, order, and orderitems.
Only show the fields for orders and orderitems. 
*/
select * from orderitems
select * from orders

select oi.*, oc.order_date, oc.cust_id
from orderitems as oi full outer join 
( select o.*
from orders  as o full outer join customers as c
on o.cust_id = c.cust_id ) as oc
on oi.order_num = oc.order_num


/*	
d. *) List all order items that that have the same ‘item_price’ (from the table orderitems). 
Exclude items which have the same ‘prod_id’ and ‘order_num’.
*/


select * from Orderitems

select *, count(prod_id) as count_pid from 
orderitems
where  count_pid > 2
group by prod_id


select o.* 
from orderitems as o
where o.item_price = o.item_price

-------------------------------------------------------------------------------------------------------------------------------
-- Chapter 3
-- 3b
sp_tables
-- 3c
sp_who;
sp_who 'active';


-- Chapter 4
-- 4c 
-- Write a query that lists all the unique order numbers from the orderitemstable
SELECT DISTINCT order_num 
FROM [dbo].[Orderitems]

-- 4d
-- Write a query that lists 2 records from the orderitems table
SELECT TOP(2)*
FROM [dbo].[Orderitems]


-- Chapter 5
-- 5b
-- Write  a  query  that  lists  the  three  products with  the  highest  item  prices  (with descending ordering).
SELECT TOP(3) [prod_id],[prod_price]
FROM [dbo].[Products]
Order by [prod_price] DESC;


-- Chapter 6
-- 6b
-- List the customers with a cust_id between 10002 and 10004
SELECT *
From [dbo].[Customers]
where cust_id BETWEEN 10002 and 10004

-- 6c
-- List the customers (cust_name and cust_id) that have an email address and are in zip code 44444
SELECT cust_name, cust_id
From [dbo].[Customers]
where cust_email is not NULL and cust_zip = '44444'


-- Chapter 7
-- 7b
-- List  the  order  items  with  order_num  20005  or  20009  and  with  an  item_price  >=  10, 
-- order by prod_id. Use an oroperator in your statement.
select *
from [dbo].[Orderitems]
where (order_num = 20005 or order_num = 20009) and item_price >= 10
order by prod_id

-- 7c
-- List  the  order  items  with  order_num  20005  or  20009  and  with  an  item_price  >=  10, 
-- order by prod_id. Use an inoperator in your statement.
select *
from Orderitems
where order_num in (20005,20009) and item_price >= 10
order by prod_id

-- 7d 
-- List all the records form the OrderItems table that do not match the properties listed in 7b).
-- List  the  order  items  with  order_num  20005  or  20009  and  with  an  item_price  >=  10
select *
from Orderitems
where not ((order_num=20005 and item_price >= 10) or (order_num=20009 and item_price >= 10))
order by prod_id

select *
from Orderitems


-- Chapter 8
-- 8b
-- list the order itemsthat have a prod_id that containa numeric value.Hint. This can be done with a regular expression 
select *
from Orderitems
where prod_id like '%[0-9]%'
-- 8c
-- List the order items that have a prod_id that does not contain a numeric value
select *
from Orderitems
where not prod_id like '%[0-9]%'

-- 8d
-- Store the result of the previous query (8c) in a temporary table. Include your unique student number in the table’s name (e.g. ‘#Q8d_1034561’). 
-- Write a query to show all the records of this table. After that remove (i.e. drop) the temporary table.
select *
into #Q8d_2058560
from orderitems
where not prod_id like '%[0-9]%'

drop table #Q8d_2058560

-- 8e
-- List 10 records from the table Patstat where the column ‘npl_biblio’ does not contain any numeric values,
-- but does contain the words ‘et al’.Store the results in a temporary table. 
-- Select in this temporary table the records that end with ‘abstract.’. After that drop the temporary table.
select top(10)*
into #Q8d_2058560
from patstat
where npl_biblio not like '%[0-9]%' and npl_biblio like '%et al%'

select *
from #Q8d_2058560
where [npl_biblio] like '%abstract.';

drop table #Q8d_2058560


-- Chapter 9

-- 9b
-- List all the fields from the Customer table, 
-- and include the additional fields ‘cust_address_city’, which is the concatenation of customer address and city (separated with  a  single  space)  
-- and  the  field  ‘initial’,  which  is  the  first  character  of  the  field ‘cust_contact’. 
select *,
Rtrim(cust_address) + ' ' + Rtrim(cust_city) as cust_address_city, 
left(Ltrim(cust_contact),1) as initial
FROM Customers

-- 9c
-- Limit the number of records of the query in 9b, 
-- by a query that only shows customers with an initial that starts with a ‘J’.
select *,
Rtrim(cust_address) + ' ' + Rtrim(cust_city) as cust_address_city, 
left(Ltrim(cust_contact),1) as initial
FROM Customers
where left(Ltrim(cust_contact),1) = 'J'

-- 9e
-- Write a query that list the current date and time with the column name ‘CurrentDate’
select *,
getdate() as CurrentDate
from customers


-- Chapter 10
-- 10b
-- Write a query that lists the column cust_email from the Customers table, 
-- together with a new column with the name ‘cust_email_domain’ that gives only the domain of an email, e.g. ‘coyote.com’
select cust_email,
       substring(cust_email,CharIndex('@',cust_email)+1,len(cust_email)) as cust_email_domain
from [dbo].[Customers]



-- Chapter 11
-- 11b
-- Delete all rows in #tmp2 (from the previous questions), where the ‘order_num’ is null or larger than or equal to ‘20010’.
DELETE FROM #tmp2
WHERE order_num is null or order_num >= 20010


-- 11c
-- Delete all rows from #tmp. After that drop both tables
DELETE FROM #tmp

drop #tmp

-- 11d
-- Make  a  copy  of  the  table  orderitems,  with  the  name  #orderitems.  
-- In  the  table #orderitems  update  item_prices  as  follows:  
-- item_prices  with  a  quantity  >  1  are multiplied by 10 and item_prices with quantity 1 are multiplied by 5. 
-- After that drop the table #orderitems.
SELECT *
INTO #orderitems
FROM orderitems

UPDATE #orderitems
SET item_price = item_price * 10
WHERE quantity > 1;UPDATE #orderitems
SET item_price = item_price * 5
WHERE quantity = 1;

-- 11e
-- Make    a    permanent    copy    of    the    table    customers,    with    the    name customers_[studentnumber]. 
-- In  this  new  table,  update  the  field  ‘cust_email’  for customers with a replacement of ‘com’ with  ‘org’. 
-- Only update customers that are associated  with  ‘order_num’  20005  and  20009. 
-- After   that   drop   the   table customers_[studentnumber]. Please do not update or drop the original Customers table.
SELECT *
INTO customers_976100
FROM customers

UPDATE customers_976100
SET cust_email = replace(substring(cust_email,CharIndex('@',cust_email)+1,len(cust_email)),'com', 'org')
where cust_id in (select cust_id
				 from orders
				 where order_num =20005 or order_num =20009)

select *
from customers


-- 12c
-- Write a new query based on the query in 10a), where the ‘com’ inthe new column is replaced by ‘org’.
select cust_email,
	   replace(substring(cust_email,CharIndex('@',cust_email)+1,len(cust_email)),'com', 'org')  as cust_email_domain
from [dbo].[Customers]

-- 12d
-- Write a query that lists the columns order_num, order_date, 
-- and the calculated (numeric) columns: year, quarter, and month. 
-- Order the result by year, quarter, and month.
select order_num,
       order_date,
	   year(order_date) as year_col
	   quarter(order_data) as quarter_col,
	   month(order_date) as month_col
order by year, quarter, month


-------------------------------------------------------------------------------------------------------------------------------


