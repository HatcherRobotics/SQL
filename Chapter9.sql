#9.1什么是存储过程
#9.2创建一个存储过程
USE sql_invoicing;
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
    SELECT * FROM clients;
end $$
DELIMITER ;
CALL get_clients();
#exercise
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
    SELECT * FROM invoices_with_balance WHERE balance>0;
END $$
DELIMITER ;
#9.3使用MySQL工作台创建存储过程
#9.4删除存储过程
DROP PROCEDURE IF EXISTS get_clients;
#9.5参数
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN
    SELECT * FROM clients c WHERE c.state=state;
end $$
DELIMITER ;
CALL get_clients_by_state('CA');
#exercise
DELIMITER $$
CREATE PROCEDURE get_invoices_by_clients(client_id INT)
BEGIN
   SELECT * FROM invoices i WHERE i.client_id = client_id;
END $$
DELIMITER ;
CALL get_invoices_by_clients(1);
#9.6带默认值的参数
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN
    IF state IS NULL THEN
        SET state='CA';
    END IF;
    SELECT * FROM clients c WHERE c.state=state;
END $$
DELIMITER ;
CALL get_clients_by_state(NULL);
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN
    IF state IS NULL THEN
        SELECT * FROM clients;
    ELSE
        SELECT * FROM clients c WHERE c.state=state;
    END IF;
END $$
DELIMITER ;
CALL get_clients_by_state(NULL);
DELIMITER $$
CREATE PROCEDURE get_clients_by_state(state CHAR(2))
BEGIN
        SELECT * FROM clients c WHERE c.state=IFNULL(state,c.state);
END $$
DELIMITER ;
#exercise
DELIMITER $$
CREATE PROCEDURE get_payments(client_id INT,payment_method_id TINYINT)
BEGIN
    SELECT * FROM payments p JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
    WHERE p.client_id=IFNULL(client_id,p.client_id) AND p.payment_method=IFNULL(payment_method_id,p.payment_method);
END $$
DELIMITER ;
CALL get_payments(NULL,NULL);
#9.7参数验证
