CREATE DATABASE food;

USE food;

CREATE TABLE  Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);
#Insert data into Customers 
INSERT INTO Customers (customer_id, name, city) VALUES 
(1, 'Arjun', 'Bengaluru'), 
(2, 'Sneha', 'Hyderabad'), 
(3, 'Rahul', 'Chennai'), 
(4, 'Priya', 'Bengaluru'), 
(5, 'Kiran', 'Mumbai'), 
(6, 'Divya', 'Bengaluru'), 
(7, 'Vikram', 'Hyderabad'), 
(8, 'Asha', 'Chennai'), 
(9, 'Manoj', 'Pune'), 
(10, 'Swathi', 'Bengaluru'); 
select* from customers;
#Create Orders table 
CREATE TABLE Orders ( 
    order_id INT PRIMARY KEY, 
    customer_id INT, 
    restaurant VARCHAR(50), 
    amount DECIMAL(10,2), 
    order_date DATE, 
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
); 
#Insert data into Orders 
INSERT INTO Orders (order_id, customer_id, restaurant, amount, order_date) VALUES 
(101, 1, 'Meghana Foods', 550.00, '2025-01-01'), 
(102, 2, 'Paradise Biryani', 780.00, '2025-01-03'), 
(103, 3, 'KFC', 420.00, '2025-01-05'), 
(104, 1, 'Empire Restaurant', 300.00, '2025-01-08'), 
(105, 4, 'Meghana Foods', 950.00, '2025-01-10'), 
(106, 6, 'Truffles', 1100.00, '2025-01-11'), 
(107, 7, 'Kritunga', 650.00, '2025-01-12'), 
(108, 4, 'KFC', 350.00, '2025-01-14'), 
(109, 9, 'Burger King', 270.00, '2025-01-15'), 
(110, 10, 'Meghana Foods', 1250.00, '2025-01-16'); 
select *from orders;

#1. List all customers who have placed at least one order.
#customers as c # orders as o
SELECT DISTINCT c.customer_id,c.name,c.city
FROM Customers c 
INNER JOIN Orders o
    ON c.customer_id = o.customer_id;
    
#2. Find the total amount spent by each customer. 

SELECT c.customer_id,c.name,
sum(o.amount) as Total_amount_spent_by_each_customer
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,c.name;

#3. Display the top 3 customers based on total spending. 

SELECT c.customer_id,c.name,
sum(o.amount) as Total_amount_spent_by_each_customer
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name
ORDER BY Total_amount_spent_by_each_customer DESC
LIMIT 3;

#SUM(o.amount) → calculates total spending
#GROUP BY → calculates it separately for each customer
#ORDER BY ... DESC → sorts from highest to lowest
#LIMIT 3 → shows only the top 3 customers


#4. Retrieve all orders placed in the last 7 days (from latest order date). 
SELECT MAX(order_date)
FROM Orders;

SELECT *FROM Orders
WHERE order_date >= (SELECT date_sub(max(order_date), INTERVAL 7 DAY) FROM Orders);



#5. Show customers who have never placed an order.
SELECT c.customer_id,c.name,c.city FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
 
#6. Find the restaurant that received the highest number of orders. 
SELECT restaurant,
COUNT(order_id) AS highest_Orders FROM Orders
GROUP BY restaurant
ORDER BY highest_Orders DESC
LIMIT 1;

#7. List customers from “Bengaluru” who spent more than ₹1000. 

SELECT c.customer_id,c.name,c.city,
SUM(o.amount) AS Total_Spent FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.city = 'Bengaluru'
GROUP BY c.customer_id,c.name,c.city
HAVING SUM(o.amount) > 1000;

#8. Show the total number of orders placed per city. 
SELECT c.city,
COUNT(o.order_id) AS Total_Orders
FROM Customers c
INNER JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city;

#9. Find the average order amount for each restaurant. 
SELECT restaurant,
AVG(amount) AS Average_Order_Amount FROM Orders
GROUP BY restaurant;
#10. Identify customers who placed more than 5 orders.

SELECT c.customer_id,c.name,
COUNT(o.order_id) AS Total_Orders FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
HAVING COUNT(o.order_id) >5
