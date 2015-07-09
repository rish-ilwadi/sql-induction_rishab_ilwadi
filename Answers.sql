--Queries are written for execution on Microsoft SQL Server.

create database sql;
use sql;

--28. To Create a table 'employee'

create table employee
(
emp_id int NOT NULL,
fname varchar(50),
l_name varchAr(50),
age int,
designation varchar(50),
salary int,
grade int
);


--Insert Values in table employee

Insert into employee(emp_id,fname,l_name,age,designation,salary,grade)
Values(123,'Rishab','Ilwadi',22,'Techlead',39000,3), 
(124,'Shivansh','Srivastava',24,'Trainee',20000,2),
(125,'Aditya','Trivedi',23,'Manager',52000,2),
(118,'Raunak','Singh',27,'Techlead',57000,2),
(119,'Aman','Trivedi',43,'Manager',62000,3);



--5. Select Operation

select fname, l_name, designation
from employee;

--6.Select Distinct Operation

select DISTINCT designation
from employee;

--7. Select Distict operation

select * 
from employee
where salary<20000


--8.Select AND/OR Operation

--AND Operation

select *
from employee
where salary>50000 AND age<35;

--Select AND OR Operation

select *
from employee
where salary>50000 AND (designation LIKE 'Manager' OR designation LIKE 'techlead');

--9. Use of ORDER BY clause

select TOP 5 *
from employee
order by salary desc;

--10. Insert Operation to insert two rows in employee Table


Insert into employee(emp_id,fname,l_name,age,designation,salary,grade)
Values(126,'Rohan','Ilwadi',36,'Techlead',39000,3), 
(127,'Siddharth','Gupta',24,'Trainee',20000,1);

--11.Update operation


Update employee
set designation='Manager', salary=50000
where salary>40000 AND age>35;

--12. Delete operation


delete from employee
where designation='Trainee' AND grade=1;

--14. Select TOP clause

--Display Top 3 values from employee table by salary


select TOP 5 *
from employee
order by salary desc;


--Display 2nd Highest salary 

select Min(salary) as Second_High
from employee
where salary IN (select Top 2 salary from employee order by salary desc);


--Display 3rd Highest Salary


select Min(salary) AS Third_High
from employee
where salary in (select Top 3 salary from employee order by salary desc);


--15. Use of LIKE operator

select *
from employee
where fname LIKE 'Rishab';

--16 Use of Wildcards

--Use of % Wildcard

select *
from employee
where fname LIKE 'R%';

--Use of - Wildcard

select *
from employee
where fname LIKE '_ishab';

--17. Use of IN operator

select *
from employee
where salary IN (40000,60000);

--18. Use of BETWEEN operator

select *
from employee
where salary BETWEEN 40000 AND 60000;

--19. Use of ALIAS to display column name with ALIAS name

select fname AS First_Name
from employee;


--20. 21. SQL Inner Join

select *
from employee
inner join employee_slabs
on employee.emp_id=employee_slabs.emp_id;

--22. SQL Left Join
--Creating Department Table
create table department
(
dept_id int,
emp_id int PRIMARY KEY,
dept_name varchar(50)
);
--Insert values in  Department table
Insert into department
values(1256,123,'Developer'),
(1257,124,'Tester'),
(1258,NULL,'Management');

--SQL Left Join
 
select *
from employee
left join department
on employee.emp_id=department.emp_id;


--23. SQL Right Join

 
select *
from employee
right join department
on employee.emp_id=department.emp_id;

--24. SQL Full Join

select *
from employee
full join department
on employee.emp_id=department.emp_id;

--25 SQL Union

--Create employee table for ABC
create table emp_ABC
(
emp_id int NOT NULL,
fname varchar(50),
l_name varchAr(50),
age int,
designation varchar(50),
salary int,
grade int
);
--create employee table for LMN 
create table emp_LMN
(
emp_id int NOT NULL,
fname varchar(50),
l_name varchAr(50),
age int,
designation varchar(50),
salary int,
grade int
);
--create employee table for XYZ
create table emp_XYZ
(
emp_id int NOT NULL,
fname varchar(50),
l_name varchAr(50),
age int,
designation varchar(50),
salary int,
grade int
);

--insert records into emp_ABC
Insert into emp_ABC(emp_id,fname,l_name,age,designation,salary,grade)
Values(123,'Rishab','Singh',22,'Techlead',39000,3), 
(124,'Shivansh','Gupta',24,'Trainee',20000,2),
(125,'Aditya','Agarwal',23,'Manager',52000,2),
(118,'Raunak','Nanda',27,'Techlead',57000,2),
(119,'Aman','Singh',43,'Manager',62000,3);


--insert records into emp_LMN
Insert into emp_LMN(emp_id,fname,l_name,age,designation,salary,grade)
Values(123,'Rishab','Ilwadi',22,'Techlead',39000,3), 
(124,'Shivansh','Srivastava',24,'Trainee',20000,2),
(125,'Aditya','Trivedi',23,'Manager',52000,2),
(118,'Raunak','Singh',27,'Techlead',57000,2),
(119,'Aman','Trivedi',43,'Manager',62000,3);

--insert records in emp_XYZ
Insert into emp_XYZ(emp_id,fname,l_name,age,designation,salary,grade)
Values(123,'Rishab','Gupta',22,'Techlead',39000,3), 
(124,'Shivansh','Singh',24,'Trainee',20000,2),
(125,'Aditya','Agarwal',23,'Manager',52000,2),
(129,'Raunak','Singh',27,'Techlead',57000,2),
(119,'Aman','Gupta',43,'Manager',62000,3);

--SQL UNION
select *
from emp_ABC
UNION
select *
from emp_LMN
UNION
select *
from emp_XYZ;

--27. Create Database

create database MIS;




--29., 30., 31. 32., 34. 35. Use of Constraints DEFAULT,UNIQUE, NOT NULL, PRIMARY KEY, CHECK on Employee Table in MIS Database


--Using MIS Database

use MIS;

--Create table Employee with above mentioned Constraints
create table Employee
(
emp_id int NOT NULL UNIQUE,
fname varchar(50),
l_name varchAr(50),
age int,
designation varchar(50) DEFAULT 'Trainee',
salary int,
grade int,
cHECK (grade>=1),
PRIMARY KEY(emp_id)
);

--33 Use of Foreign Key
Alter table employee
add Foreign Key(emp_id) 
REFERENCES department(emp_id);
--36. use of Drop Table

--Creating a table Designation
use sql;
create table Designation
(
Deseg_id int PRIMARY KEY,
Deseg_name varchar(50)
);

--Drop Designation Table

drop table Designation;

--37. Creating UNIQUE SQL Indexes

--Creating Index on First name
create UNIQUE index firstname
on employee(fname);

--Creating Index on Last name
create UNIQUE index lastname
on employee(l_name);

--38 SQL ALTER to ALTER the column datatype

ALTER table employee
ALTER COLUMN designation int;



--39 SQL Increment (To increment salary of employees by 5000)

update employee
set salary=salary+5000;

--40 SQL Create Views

--Add Column Date_of_Joining to employee table

ALTER table employee
ADD COLUMN Date_of_joining date();

--Create View of the employee table

GO

create view employee_view1 AS
select *
from employee
where salary>60000 AND designation LIKE 'Managers';

--41. SQL Dates
--Return Date in Given Format
DECLARE @d DATETIME
SET @d=getdate()
 
SELECT FORMAT(@d, 'U')

--Add 2 days to current date and dispaly in the given format

DECLARE @d DATETIME
SET @d=DATEADD(day,2,getdate())
 
SELECT FORMAT(@d, 'U')

--46. SQL avg() function

select * 
from employee
where salary > (select avg(salary) from employee)

--47 SQL count() function

select dept_name ,count(emp_id) AS No_of_employees
from department
group by dept_name;
   
--48. SQL max() function

select *
from employee
where salary < (select max(salary) from employee);

--49. SQL min() function

select *
from employee
where salary> (select min(salary) from employee);


--50 SQL sum() function

select sum(salary)
from employee


--51 SQL Group By

select dept_name ,count(emp_id) AS No_of_employees
from department
group by dept_name;

--52. SQL Having Clause

create table order
(
order_id int PRIMARY KEY,
order_date date default getdate(),
order_price int,
customer_name varchar(50)
);

Insert into order(order_id,order_price,customer_name)
values(1234,1980,'Rishab'),
(1235,2346,'Aditya');

select *
from order
Having order_price<2000;

 
--53. SQL upper() function

select upper(l_name), fname
from employee;

--54 SQL lower() function

select lower(l_name), fname
from employee;

--55 SQL len() function

select len(fname) AS Length_Of_First_Name
from employee;

--56 Use of ROUND() function

ALTER table employee
ALTER COLUMN salary float;

select ROUND(salary,2) 
from employee;

--57 Use of getdate() function

ALTER table employee
add join_date date default getdate();

--58 sql convert()

select salary, Convert(varchar,getdate(),4)
from employee;



