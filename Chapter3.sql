USE sql_store;
#3.1内连接
SELECT * FROM orders JOIN customers ON orders.customer_id = customers.customer_id;
SELECT order_id,first_name,last_name FROM orders JOIN customers ON orders.customer_id = customers.customer_id;
SELECT order_id,c.customer_id,first_name,last_name FROM orders o JOIN customers c ON o.customer_id = c.customer_id;
#exercise
SELECT o.order_id, p.product_id, name,quantity,o.unit_price FROM order_items o JOIN products p ON o.product_id = p.product_id;

#3.2跨数据库连接
SELECT * FROM order_items oi JOIN sql_inventory.products p ON oi.product_id=p.product_id;
USE sql_inventory;
SELECT * FROM sql_store.order_items oi JOIN products p ON oi.product_id=p.product_id;

#3.3自连接
USE sql_hr;
SELECT * FROM employees e JOIN employees m ON e.reports_to=m.employee_id;
SELECT e.employee_id,e.first_name,m.first_name AS manager FROM employees e JOIN employees m ON e.reports_to=m.employee_id;

#3.4多表连接
USE sql_store;
SELECT * FROM orders o JOIN customers ON o.customer_id=customers.customer_id
    JOIN order_statuses os ON o.status = os.order_status_id;
SELECT o.order_id,o.order_date,c.first_name,c.last_name,os.name AS status FROM orders o JOIN customers c ON o.customer_id=c.customer_id
    JOIN order_statuses os ON o.status = os.order_status_id;
#exercise
USE sql_invoicing;
SELECT p.date,p.invoice_id,p.amount,c.name,pm.name FROM payments p JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
    JOIN clients c ON p.client_id = c.client_id;

#3.5复合连接条件
USE sql_store;
SELECT * FROM order_items oi JOIN order_item_notes oin ON oi.order_id=oin.order_Id AND oi.product_id=oin.product_id;

#3.6隐式连接语法
SELECT * FROM orders o, customers c WHERE o.customer_id=c.customer_id;#(不建议)

#3.7外连接
SELECT c.customer_id,c.first_name,o.order_id FROM customers c JOIN orders o ON c.customer_id = o.customer_id
    ORDER BY customer_id;
SELECT c.customer_id,c.first_name,o.order_id FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
    ORDER BY customer_id;
SELECT c.customer_id,c.first_name,o.order_id FROM customers c RIGHT JOIN orders o ON c.customer_id = o.customer_id
    ORDER BY customer_id;
SELECT c.customer_id,c.first_name,o.order_id FROM orders o RIGHT JOIN customers c ON c.customer_id = o.customer_id
    ORDER BY customer_id;
#exercise
SELECT p.product_id,p.name,o.quantity FROM products p LEFT JOIN order_items o ON p.product_id = o.product_id ORDER BY product_id;

#3.8多表外连接
SELECT c.customer_id,c.first_name,o.order_id,sh.name AS shipper FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
            LEFT JOIN shippers sh ON o.shipper_id=sh.shipper_id
                ORDER BY customer_id;#(尽量使用左连接)
#exercise
SELECT o.order_date,o.order_id,c.first_name AS customer,sh.name AS shipper,os.name AS status FROM orders o JOIN customers c ON c.customer_id = o.customer_id
    LEFT JOIN shippers sh ON o.shipper_id=sh.shipper_id
        LEFT JOIN order_statuses os ON o.status = os.order_status_id
            ORDER BY status,order_id;

#3.9自外连接
USE sql_hr;
SELECT e.employee_id,e.first_name,m.first_name AS manager FROM employees e
    LEFT JOIN employees m ON e.reports_to=m.employee_id;

#3.10USING子句
USE sql_store;
SELECT o.order_id,c.first_name,sh.name AS shipper FROM customers c JOIN orders o
    -- ON c.customer_id=o.customer_id;
    USING (customer_id)
        LEFT JOIN shippers sh USING (shipper_id);
SELECT * FROM order_items oi JOIN order_item_notes oni ON oi.order_id=oni.order_Id AND oi.product_id=oni.product_id;
SELECT * FROM order_items oi JOIN order_item_notes oni USING (order_id,product_id);
#exercise
USE sql_invoicing;
SELECT p.date,c.name AS client,p.amount,pm.name FROM payments p JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
    JOIN clients c USING (client_id);

#3.11自然连接
USE sql_store;
SELECT o.order_id,c.first_name FROM orders o NATURAL JOIN customers c;

#3.12交叉连接
SELECT p.name AS product,c.first_name AS customer FROM customers c CROSS JOIN products p
    ORDER BY c.first_name;#显式写法
SELECT p.name AS product,c.first_name AS customer FROM customers c,products p
    ORDER BY c.first_name;#隐式写法
#exercise
SELECT p.name AS product,sh.name AS shipper FROM products p CROSS JOIN shippers sh ORDER BY sh.name;
SELECT p.name AS product,sh.name AS shipper FROM products p,shippers sh ORDER BY sh.name;

#3.13联合
SELECT order_id,order_date,'Active' AS status FROM orders WHERE order_date>'2019-01-01';
SELECT order_id,order_date,'Archived' AS status FROM orders WHERE order_date<'2019-01-01';
SELECT order_id,order_date,'Active' AS status FROM orders WHERE order_date>'2019-01-01'
    UNION
        SELECT order_id,order_date,'Archived' AS status FROM orders WHERE order_date<'2019-01-01';
#exercise
SELECT customer_id,first_name,points,'Gold' AS type FROM customers WHERE points>=3000
    UNION SELECT customer_id,first_name,points,'Silver' AS type FROM customers WHERE points>=2000 AND points<3000
        UNION SELECT customer_id,first_name,points,'Bronze' AS type FROM customers WHERE points<2000
            ORDER BY first_name;