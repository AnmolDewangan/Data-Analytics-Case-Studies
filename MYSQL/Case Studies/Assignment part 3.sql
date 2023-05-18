# 1. Write a stored procedure that accepts the month and year as inputs and prints the
# ordernumber, orderdate and status of the orders placed in that month. 
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `order_status`(IN ordersyear integer, IN ordersmonth integer)
BEGIN
    
    select ordernumber, orderdate, status 
    from orders 
    where year(orderdate) = ordersyear
    and month(orderdate) = ordersmonth ;
    
END; //

# 2. Write a stored procedure to insert a record into the cancellations table for all cancelled orders.
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancellations`()
BEGIN
create table if not exists cancellations(id int PRIMARY KEY auto_increment,
customernumber int,
FOREIGN KEY(customerNumber)REFERENCES customers(customerNumber) ,
orderNumber int, FOREIGN KEY(orderNumber)REFERENCES orders(orderNumber));
insert into cancellations(customernumber,orderNumber)
select customerNumber,orderNumber from orders where status='Cancelled' ;
END; //

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_cancel`()
BEGIN
	declare cnum, ordnum, finished integer default 0;
    
    -- Declare Cursor
	declare ord_cur cursor for
    select customernumber, ordernumber 
    from orders
    where status='cancelled';

    -- Declare exception handler
    declare exit handler for NOT FOUND set finished = 1;
    
    -- Open Cursor
    open ord_cur;    
    
    -- Fetch order records
    ordloop:REPEAT
		fetch ord_cur into cnum, ordnum;
        insert into cancellations (customernumber, ordernumber) values(cnum, ordnum);
        
	until finished = 1
	end repeat ordloop;
            	
END;

# 3. a. Write function that takes the customernumber as input and returns the purchase_status 
# based on the following criteria . [table:Payments]

CREATE DEFINER=`root`@`localhost` FUNCTION `purhase_status`(cid int) RETURNS varchar(20) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE status VARCHAR(20);
    DECLARE credit numeric;
    SET credit = (select sum(Amount) from Payment where Cust_number = cid);
    
    IF credit > 50000 THEN
        SET status = 'platinum';
    ELSEIF (credit >= 25000 AND 
            credit <= 50000) THEN
        SET status = 'gold';
    ELSEIF credit < 25000 THEN
        SET status = 'silver';
    END IF;
    RETURN (purhase_status);
END;

select customerNumber, customerName, purchase_status(customerNumber) from customers;

# 4. Replicate the functionality of 'on delete cascade' and 'on update cascade' using triggers
# on movies and rentals tables. Note: Both tables - movies and rentals - don't have primary or foreign keys.
# Use only triggers to implement the above.
-- On update cascade
delimiter //
CREATE TRIGGER upd_cascade 
AFTER UPDATE ON `movies` 
FOR EACH ROW
BEGIN
    update rentals set movieid = new.id
    where movieid = old.id;
END; //

-- On delete cascade
delimiter //
CREATE TRIGGER del_cascade 
AFTER DELETE ON `movies` 
FOR EACH ROW
BEGIN
   delete from rentals 
   where movieid = old.id;
END;//

# 5. . Select the first name of the employee who gets the third highest salary. [table: employee]
SELECT fname, lname, salary, 
NTH_VALUE(fname, 3) OVER  ( ORDER BY salary DESC) third_highest_salary 
FROM employee;

# 6. Assign a rank to each employee  based on their salary. The person having the highest salary
# has rank 1. [table: employee]
SELECT fname, lname, salary, 
NTH_VALUE(fname, 3) OVER  ( ORDER BY salary DESC) third_highest_salary 
FROM employee;
