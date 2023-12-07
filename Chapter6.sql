#6.2子查询
USE sql_inventory;
SELECT * FROM products
WHERE unit_price>(SELECT unit_price FROM products WHERE product_id=3);
#exercise
USE sql_hr;
SELECT * FROM employees
WHERE salary>(SELECT AVG(salary) FROM employees);

#6.3IN运算符
USE sql_store;
SELECT * FROM products
WHERE product_id NOT IN(SELECT DISTINCT product_id FROM order_items);
#exercise
USE sql_invoicing;
SELECT * FROM clients
WHERE client_id NOT IN (SELECT DISTINCT client_id FROM invoices);

#6.4 子查询vs连接
#exercise
USE sql_store;
#连接
SELECT DISTINCT customer_id,first_name,last_name FROM customers
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE oi.product_id=3;
#子查询
SELECT customer_id,first_name,last_name FROM customers
WHERE customer_id IN
(SELECT customer_id FROM orders
WHERE order_id IN
(SELECT order_id FROM order_items WHERE product_id=3));

#6.5ALL关键字
USE sql_invoicing;
SELECT * FROM invoices
WHERE invoice_total>(SELECT MAX(invoice_total) FROM invoices WHERE client_id=3);
SELECT * FROM invoices
WHERE invoice_total>ALL (SELECT invoice_total FROM invoices WHERE client_id=3);

#6.6ANY关键字
SELECT client_id,COUNT(*)
FROM invoices
GROUP BY client_id
HAVING COUNT(*)>=2;
SELECT * FROM clients
WHERE client_id IN (SELECT client_id FROM invoices GROUP BY client_id HAVING COUNT(*)>=2);
SELECT * FROM clients
WHERE client_id = ANY (SELECT client_id FROM invoices GROUP BY client_id HAVING COUNT(*)>=2);

#6.7相关子查询
USE sql_hr;
SELECT * FROM employees e
WHERE salary>(SELECT AVG(salary) FROM employees WHERE e.office_id=employees.office_id);
#exercise
USE sql_invoicing;
SELECT * FROM invoices i
WHERE invoice_total>(SELECT AVG(invoice_total) FROM invoices WHERE i.client_id=invoices.client_id);

#6.8EXISTS运算符
SELECT * FROM clients
WHERE client_id IN (SELECT DISTINCT client_id FROM invoices);
SELECT * FROM clients c
WHERE EXISTS(SELECT client_id FROM invoices WHERE c.client_id=invoices.client_id);
#exercise
USE sql_store;
SELECT * FROM products p
WHERE NOT EXISTS(SELECT product_id FROM order_items WHERE p.product_id=order_items.product_id);

#6.9SELECT子句中的子查询
USE sql_invoicing;
SELECT invoice_id,
       invoice_total,
       (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
       invoice_total - (SELECT invoice_average) AS difference
FROM invoices;
#exercise
SELECT  client_id,
        name,
       (SELECT SUM(invoice_total) FROM invoices WHERE c.client_id=invoices.client_id) AS total_sales,
       (SELECT AVG(invoice_total) FROM invoices WHERE c.client_id=invoices.client_id) AS average,
       (SELECT total_sales) - (SELECT average) AS difference
FROM clients c;

#6.10FROM子句中的子查询
SELECT * FROM
(
    SELECT  client_id,
            name,
            (SELECT SUM(invoice_total) FROM invoices WHERE c.client_id=invoices.client_id) AS total_sales,
            (SELECT AVG(invoice_total) FROM invoices WHERE c.client_id=invoices.client_id) AS average,
            (SELECT total_sales) - (SELECT average) AS difference
    FROM clients c
) AS sale_summary WHERE total_sales IS NOT NULL ;