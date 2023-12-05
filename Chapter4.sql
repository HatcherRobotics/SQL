USE sql_store;
#4.2插入单行
INSERT INTO customers
    (first_name, last_name, birth_date, address, city, state)
        VALUES ('John','Smith','1990-01-01','address','city','CA');
#4.3插入多行
INSERT INTO shippers (name)
VALUES ('shipper1'),
       ('shipper2'),
       ('shipper3');
#exercise
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('test1',4,7.48),
       ('test2',7,4.32),
       ('test3',9,1.45);
#4.4插入分层行
INSERT INTO orders (customer_id,order_date,status)
VALUES (1,'1990-01-01',1);
INSERT INTO order_items
VALUES (LAST_INSERT_ID(),1,1,2.95),
       (LAST_INSERT_ID(),2,1,3.95);
-- SELECT LAST_INSERT_ID();
#4.5创建表复制
CREATE TABLE order_archived
SELECT * FROM orders;
INSERT INTO order_archived
SELECT * FROM orders WHERE order_date<'2019-01-01';
#exercise
USE sql_invoicing;
CREATE TABLE invoices_archived
SELECT invoice_id,number,c.name AS name,invoice_total,payment_total,invoice_date,due_date,payment_date
    FROM invoices
        JOIN sql_invoicing.clients c ON c.client_id = invoices.client_id
            WHERE payment_date IS NOT NULL;
#4.6更新单行
UPDATE invoices
SET payment_total=DEFAULT,payment_date=NULL
WHERE invoice_id=1;
UPDATE invoices
SET payment_total=invoice_total*0.5,payment_date=due_date
WHERE invoice_id=3;
#4.7更新多行
UPDATE invoices
SET payment_total=invoice_total*0.5,payment_date=due_date
WHERE client_id=3;
UPDATE invoices
SET payment_total=invoice_total*0.5,payment_date=due_date
WHERE client_id IN (3,4);
#exercise
USE sql_store;
UPDATE customers
SET points=points+50
WHERE birth_date<'1990-01-01';
#4.8在更新中用子查询
USE sql_invoicing;
UPDATE invoices
SET payment_total=invoice_total*0.5,payment_date=due_date
WHERE client_id= (SELECT client_id FROM clients WHERE name='Myworks');
UPDATE invoices
SET payment_total=invoice_total*0.5,payment_date=due_date
WHERE client_id IN (SELECT client_id FROM clients WHERE state in ('CA','NY'));
UPDATE invoices
SET payment_total=invoice_total*0.5,payment_date=due_date
WHERE payment_date is NULL;
#exercise
USE sql_store;
UPDATE orders
SET comments='Golden Customer'
WHERE customer_id IN (SELECT customer_id FROM customers WHERE points>3000);
#4.9删除行
USE sql_invoicing;
DELETE FROM invoices WHERE invoice_id=1;
DELETE FROM invoices WHERE invoice_id= (SELECT invoice_id FROM clients WHERE name='Myworks');
#4.10恢复数据库

