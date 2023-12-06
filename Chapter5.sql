#5.1聚合函数
USE sql_invoicing;
SELECT MAX(invoice_total) AS highest,
       MIN(invoice_total) AS lowest,
       AVG(invoice_total) AS average,
       SUM(invoice_total) AS total,
       COUNT(invoice_total*1.1) AS 'number of invoices',
       COUNT(payment_date) AS 'number of payments',
       COUNT(*) AS 'total records',
       COUNT(DISTINCT client_id)
FROM invoices WHERE payment_date>'2019-07-01';
#exercise
SELECT 'First half of 2019' AS data_range,
       SUM(invoice_total) AS total_sales,
       SUM(payment_total) AS total_payments,
       SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices WHERE payment_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT 'Second half of 2019' AS data_range,
       SUM(invoice_total) AS total_sales,
       SUM(payment_total) AS total_payments,
       SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices WHERE payment_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT 'Total' AS data_range,
       SUM(invoice_total) AS total_sales,
       SUM(payment_total) AS total_payments,
       SUM(invoice_total-payment_total) AS what_we_expect
FROM invoices WHERE payment_date BETWEEN '2019-01-01' AND '2019-12-31';

#5.2GROUP BY 子句
SELECT client_id,
       SUM(invoice_total) AS total_sales
FROM invoices i
WHERE invoice_date>='2019-07-01'
GROUP BY client_id
ORDER BY total_sales DESC;

SELECT state,
       city,
       SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients USING (client_id)
GROUP BY state,city;
#exercise
SELECT date,pm.name AS payment_method,SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY date,payment_method
ORDER BY date;

#5.3Having子句
SELECT client_id,
       SUM(invoice_total) AS total_sales,
       COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales>500 AND number_of_invoices>5;#不能用WHERE因为还没分组
# WHERE:在GROUP之前分组 HAVING:在GROUP之后分组
#exercise
USE sql_store;
SELECT c.first_name,c.last_name,SUM(oi.quantity*oi.unit_price) AS total_sales FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE state = 'VA'
GROUP BY customer_id
HAVING total_sales>100;

#5.4ROLLUP运算符
USE sql_invoicing;
SELECT client_id,
       SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;

SELECT state,
       city,
       SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING (client_id)
GROUP BY state,city WITH ROLLUP;
#exercise
SELECT pm.name AS payment_method,
       SUM(amount) AS total
FROM payments p
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY name WITH ROLLUP;

