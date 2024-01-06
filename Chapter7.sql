#7.1数值函数
SELECT ROUND(5.73);
SELECT ROUND(5.73,1);
SELECT ROUND(5.7345,2);
SELECT TRUNCATE(5.998,2);
SELECT CEILING(4.67);
SELECT CEILING(4.1);
SELECT FLOOR(3.8);
SELECT ABS(-1.2);
SELECT RAND();
#7.2字符串函数
SELECT LENGTH('sky');
SELECT UPPER('sky');
SELECT LOWER('SKY');
SELECT LTRIM('   sky');
SELECT RTRIM('sky   ');
SELECT TRIM('  sky  ');
SELECT LEFT('kindergarten',4);
SELECT RIGHT('kindergarten',6);
SELECT SUBSTRING('kindergarten',3,5);
SELECT LOCATE('garten','kindergarten');#不区分大小写
SELECT REPLACE('kindergarten','garten','garden');
SELECT CONCAT('first','last');
USE sql_store;
SELECT * FROM customers;
SELECT CONCAT(first_name,' ',last_name) AS full_name FROM customers;
#7.3MYSQL中的日期函数
SELECT NOW(),CURDATE(),CURTIME();
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT DAY(NOW());
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());
SELECT DAYNAME(NOW());
SELECT MONTHNAME(NOW());
SELECT EXTRACT(YEAR FROM NOW());
#exercise
SELECT * FROM orders WHERE YEAR(order_date)= (YEAR(NOW()));
#7.4格式化日期和时间
SELECT DATE_FORMAT(NOW(),'%M %d %Y');
SELECT TIME_FORMAT(NOW(),'%H:%i %p');
#7.5计算日期和时间
SELECT DATE_ADD(NOW(),INTERVAL 1 DAY);
SELECT DATE_ADD(NOW(),INTERVAL 1 YEAR);
SELECT DATE_ADD(NOW(),INTERVAL -1 YEAR);
SELECT DATE_SUB(NOW(),INTERVAL 1 YEAR);
SELECT DATEDIFF('1999-10-15',NOW());
SELECT DATEDIFF('2000-04-23',NOW());
SELECT DATEDIFF('1970-10-19',NOW());
SELECT DATEDIFF('1971-4-14',NOW());
SELECT TIME_TO_SEC('9:02')-TIME_TO_SEC('9:00');
#7.6IFNULL和COALESCE函数
USE sql_store;
SELECT order_id,IFNULL(shipper_id,'Not assigned') AS shipper FROM orders;
SELECT order_id,COALESCE(shipper_id,comments,'Not assigned') AS shipper FROM orders;
#exercise
SELECT CONCAT(first_name,' ',last_name) AS customer,IFNULL(phone,'Unknown') AS phone FROM customers;
#7.7IF函数
SELECT order_id,order_date ,
       IF(YEAR(DATE_SUB(NOW(),INTERVAL 5 YEAR))=YEAR(order_date),'Active','Archived') AS category FROM orders;
#exercise
SELECT product_id,name,COUNT(*) AS orders ,IF(COUNT(*)>1,'Many times','Once') AS frequency FROM products
JOIN order_items USING (product_id) GROUP BY product_id, name;
#7.8CASE运算符
SELECT order_id,
 CASE
  WHEN YEAR(order_date)=YEAR(NOW()) THEN 'Active'
  WHEN YEAR(order_date)=YEAR(NOW())-1 THEN 'Last year'
  WHEN YEAR(order_date)<YEAR(NOW())-1 THEN 'Archived'
  ELSE 'Future'
 END AS category
FROM orders;
#exercise
SELECT CONCAT(first_name,' ',last_name) AS customer,
       points,
       CASE
           WHEN points>=3000 THEN 'Gold'
           WHEN points>=2000 AND points<3000 THEN 'Sliver'
           WHEN points<2000 THEN 'Bronze'
       END AS category
FROM customers ORDER BY points DESC;