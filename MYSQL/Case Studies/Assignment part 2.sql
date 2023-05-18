use assignment ; 

# 1. select all employees in department 10 whose salary is greater than 3000. [table: employee]
Select * from employee
where salary > 3000 ;

# 2. The grading of students based on the marks they have obtained is done as follows:
alter table students 
add (grade_class varchar(20)) ;

set SQL_SAFE_UPDATES=0;
update students set grade_class = "Distinctions" where marks between 80 and 100 ;
update students set grade_class = "First Class" where marks between 60 and 80 ;
update students set grade_class = "Second Class" where marks between 50 and 60 ;
update students set grade_class = "Third Class" where marks between 40 and 50 ;
update students set grade_class = "No Class" where marks between 0 and 40 ;
set SQL_SAFE_UPDATES=1;

select count(grade_class) 
from students
where grade_class = "First Class" ;  

select count(grade_class) 
from students
where grade_class = "Distinctions" ;


# 3. Get a list of city names from station with even ID numbers only. Exclude duplicates from your answer.[table: station]
Select distinct city 
from station 
where id%2 = 0 ;

# 4. Find the difference between the total number of city entries in the table and the number of distinct city entries in the table. In other words, if N is the number of city entries in station, and N1 is the number of distinct city names in station, write a query to find the value of N-N1 from station.
select (count(city)-count(distinct city)) from station ;

# 5. Answer the following
select distinct city
from station
where left(city,1) in('a','e','i','o','u') ;

select distinct city 
from station 
where (left (city,1) in ('a','e','i','o','u')) and (right(city,1) in ('a','e','i','o','u')) ;

select distinct city
from station 
where left(city,1) not in ('a','e','i','o','u') ;

select distinct city 
from station 
where (left (city,1) not in ('a','e','i','o','u')) or (right(city,1) not in ('a','e','i','o','u')) ;

# 6. Write a query that prints a list of employee names having a salary greater than $2000 per month
# who have been employed for less than 36 months. Sort your result by descending order of salary. [table: emp]
select concat_ws(" ",first_name,last_name) as "Full Name", salary
from emp
where salary > 2000 and hire_date >= date_sub(current_date(), interval 36 month)
order by salary desc; 

# 7. How much money does the company spend every month on salaries for each department? [table: employee]
select deptno, sum(salary)
from employee 
group by deptno ;

# 8. How many cities in the CITY table have a Population larger than 100000. [table: city]
select count(name) as "No. of city"
from city
where population > 100000 ;
# Name of those cities which has population greater than 100000
select name, population
from city
where population > 100000 
order by population ;

# 9. What is the total population of California? [table: city]
select district, sum(population)
from city
where district = "California" ;

# 10. What is the average population of the districts in each country? [table: city]
select countrycode as Country, district, avg(population)
from city
group by district 
order by countrycode, district ;

# 11. Find the ordernumber, status, customernumber, customername and comments for all
#     orders that are ‘Disputed=  [table: orders, customers]
select o.orderNumber, o.customerNumber, c.customerName, o.status, o.comments
From customers c inner join orders o
on c.customerNumber = o.customerNumber
where status = "Disputed" ;
 