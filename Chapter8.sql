#8.1创建视图
USE sql_invoicing;
CREATE VIEW sales_by_client AS
SELECT c.client_id,c.name,SUM(invoice_total) AS total_sales
FROM clients c JOIN invoices i USING (client_id) GROUP BY c.client_id, c.name;

SELECT * FROM sales_by_client ORDER BY total_sales DESC;
SELECT * FROM sales_by_client WHERE total_sales>500;
SELECT * FROM sales_by_client JOIN clients USING (client_id);
#exercise
CREATE VIEW clients_balance AS
SELECT c.client_id,c.name,SUM(invoice_total)-SUM(payment_total) AS balance FROM invoices i JOIN clients c ON i.client_id = c.client_id
GROUP BY c.client_id, c.name;
#8.2更改或删除视图
DROP VIEW clients_balance;
CREATE OR REPLACE VIEW clients_balance AS
SELECT c.client_id,c.name,SUM(invoice_total)-SUM(payment_total) AS balance FROM invoices i JOIN clients c ON i.client_id = c.client_id
GROUP BY c.client_id, c.name;
#8.3可更新视图
CREATE OR REPLACE VIEW invoices_with_balance AS
    SELECT invoice_id,
           number,
           client_id,
           invoice_total-payment_total AS balance,
           invoice_total,
           payment_total,
           invoice_date,
           due_date,
           payment_date
FROM invoices WHERE (invoice_total-payment_total>0);
DELETE FROM invoices_with_balance WHERE invoice_id=1;
UPDATE invoices_with_balance
SET due_date=DATE_ADD(due_date,INTERVAL 2 DAY) WHERE invoice_id=2;
#8.4WITH OPTION CHECK子句
UPDATE invoices_with_balance
SET payment_total=invoice_total WHERE invoice_id=2;
CREATE OR REPLACE VIEW invoices_with_balance AS
    SELECT invoice_id,
           number,
           client_id,
           invoice_total-payment_total AS balance,
           invoice_total,
           payment_total,
           invoice_date,
           due_date,
           payment_date
FROM invoices WHERE (invoice_total-payment_total>0) WITH CHECK OPTION;
UPDATE invoices_with_balance
SET payment_total=invoice_total WHERE invoice_id=3;
#8.5视图的其他优点
#1.简化查询2.降低改动影响3.限制数据访问