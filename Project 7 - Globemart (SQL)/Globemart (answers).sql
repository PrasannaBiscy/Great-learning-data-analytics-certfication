USE ecommerce;


-- 1) Extract the month and year from SignupDate and concatenate them to form a string like 'Jan-2020'.

SELECT CONCAT((SUBSTR(DATE_FORMAT(Signupdate,"%M"),1,3)),"-",EXTRACT(YEAR FROM SignupDate)) as Month_year FROM USERS;

-- 2) How many unique product categories are there in the Products table?

SELECT DISTINCT CATEGORY FROM PRODUCTS
ORDER BY CATEGORY;

-- 3) On which day did the maximum number of users sign up?

SELECT DATE(SignupDate),COUNT(UserID) FROM USERS 
GROUP BY DATE(SignupDate)
ORDER BY COUNT(UserID) DESC
LIMIT 1;

-- 4) How many products have never been ordered?

SELECT Count(ProductID) FROM products
WHERE ProductID NOT IN (SELECT ProductID FROM orderdetails);

-- 5) Find the number of users who have an email domain of "example.com".

SELECT COUNT(UserID) FROM users
WHERE Email like "%example.com";

-- 6) Which product has the third highest price in the Products table?

SELECT Name,Price FROM products
ORDER BY Price desc
LIMIT 1 OFFSET 2;

-- 7) How many users have never placed an order?

SELECT COUNT(UserID) FROM users
WHERE UserID NOT IN (SELECT UserID FROM orders);

-- 8) What is the average price of products in the 'Electronics' category?

SELECT Category,AVG(Price) from products
WHERE Category = "Electronics";

-- 9) How many orders contain more than 3 items?

SELECT OrderID, COUNT(ProductID) from orderdetails
GROUP BY OrderID
HAVING COUNT(ProductID) > 3;

-- 10) Calculate the average price for each product category and label them as 'Expensive', 'Moderate', or 'Cheap' based on the following criteria:

-- ● Average price > $300: 'Expensive'
-- ● Average price between $100 and $300: 'Moderate'
-- ● Average price < $100: 'Cheap'

SELECT Category, AVG(Price),
CASE
	WHEN AVG(Price) > 300 THEN 'Expensive'
	WHEN AVG(Price) BETWEEN 100 AND 300 THEN 'Moderate'
	ELSE 'Cheap'
END AS price_category
FROM products
GROUP BY Category;

-- 11) For each user, retrieve the date of their first order and their most recent order. Which table would you use and how would you construct the query?

SELECT distinct Users.UserID, MIN(orders.OrderDate),MAX(orders.OrderDate) FROM USERS
JOIN ORDERS USING (UserID)
GROUP BY Users.UserID
ORDER BY Users.UserID;

-- 12) For each order, identify the product with the highest quantity. Which tables would you use and how would you construct the query?

SELECT ProductID, Name FROM products
WHERE ProductID in (SELECT ProductID FROM orderdetails
WHERE Quantity IN (SELECT MAX(Quantity) FROM orderdetails));


-- 13) For each product category, retrieve the 3rd most expensive product's ID. Which tables would you use and how would you construct the query?

SELECT Category, ProductID AS third_most_expensive_product_id, Name
FROM ( SELECT Category, ProductID, Name, Price, ROW_NUMBER() OVER(PARTITION BY Category
ORDER BY price DESC) AS row_num
FROM products) ranked_products
WHERE row_num = 3;

