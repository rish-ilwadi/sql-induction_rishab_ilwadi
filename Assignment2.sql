--Create Database for questions 1 & 2
CREATE DATABASE e_store;

--Using Database e_store
USE e_store;

--Question 1 Starts

--Create Table t_product_master (PRODUCT TABLE)

CREATE TABLE t_product_master
(
Product_ID VARCHAR(50) PRIMARY KEY,
Product_Name VARCHAR(50),
Cost_Per_Item INT
);

--Insert Values To t_product_master (PRODUCT TABLE)

INSERT INTO t_product_master
VALUES('P1','PEN',10),
('P2','SCALE',15),
('P3','NOTEBOOK',25);

--Create Table t_user_master (USER TABLE)

CREATE TABLE t_user_master
(
User_ID VARCHAR(50) PRIMARY KEY,
User_Name VARCHAR(50)
);

--Insert Values in t_user_master (USER TABLE)

INSERT INTO t_user_master
VALUES('U1','Alfred Lawrence'),
('U2','William Paul'),
('U3','Edward Filip');

--Create Table t_transaction (TRANSACTION TABLE)

CREATE TABLE t_transaction
(
User_ID VARCHAR(50),
Product_ID VARCHAR(50),
Transaction_Date DATE,
Transaction_Type VARCHAR(50),
Transaction_Amount INT
);

--Insert Values in t_transaction (TRANSACTION TABLE)

INSERT INTO t_transaction
VALUES('U1','P1','2010-10-25','Order',150),
('U1','P1','2010-11-20','Payment',750),
('U1','P1','2010-11-20','Order',200),
('U1','P3','2010-11-25','Order',50),
('U3','P2','2010-11-26','Order',100),
('U2','P1','2010-12-15','Order',75),
('U1','P1','2011-01-15','Payment',150);

--Question 1 Ends

--Question 2

SELECT  u.User_Name, p.Product_Name,
SUM(CASE 
     WHEN t.Transaction_Type='Payment' 
	 THEN  
	     t.Transaction_Amount
	 ELSE 0 
  END) AS Amount_Paid, 
  SUM(CASE 
     WHEN t.Transaction_Type='Order' 
	 THEN t.Transaction_Amount
     ELSE 0 
    END) AS Ordered_Quantity,
	MAX(t.Transaction_Date) AS Last_Transaction_Date,
	SUM(CASE 
     WHEN t.Transaction_Type='Order' 
	 THEN t.Transaction_Amount*p.Cost_Per_Item 
	 ELSE 0 
	 END)-SUM(CASE WHEN t.Transaction_Type='Payment' THEN t.Transaction_Amount ELSE 0 END)
	 AS BALANCE
FROM t_product_master AS p
Inner join
t_transaction AS t
ON p1.Product_ID=t1.Product_ID
Inner join t_user_master AS u1
ON u1.User_ID=t1.User_ID
GROUP BY u1.User_Name,p1.Product_Name;

--Question 2 ends

--Create Database for Question 3 & 4

CREATE DATABASE EMP_MGMT;

--Use Database EMP_MGMT

USE EMP_MGMT;

--QUESTION 3 BEGINS

--Create Table t_emp (EMPLOYEE MASTER) 

CREATE TABLE t_emp
(
Emp_id INT IDENTITY(1001,2) PRIMARY KEY,
Emp_Code VARCHAR(50),
Emp_f_name VARCHAR(50) NOT NULL,
Emp_m_name VARCHAR(50),
Emp_l_name VARCHAR(50),
Emp_DOB DATE,
Emp_DOJ DATE NOT NULL
);

--Insert Values into t_emp (EMPLOYEE MASTER TABLE) 


INSERT INTO t_emp(Emp_Code,Emp_f_name,Emp_m_name,Emp_l_name,Emp_DOB,Emp_DOJ)
VALUES('OPT20110105','Manmohan',NULL,'Singh','1983-02-10','2010-05-25'),
('OPT20100915','Alfred','Joseph','Lawrence','1988-02-28','2010-07-24');

--Create Table t_activity (ACTIVITY TABLE)

CREATE TABLE t_activity
(
Activity_id int PRIMARY KEY,
Activity_description varchar(50)
);

--Insert Values into t_activity(ACTIVITY TABLE)

INSERT INTO t_activity
VALUES(1,'Code Analysis'),
(2,'Lunch'),
(3,'Coding'),
(4,'Knowledge Transaction'),
(5,'Database');

--Create Table t_atten_det (ATTENDANCE TABLE)

CREATE TABLE t_atten_det
(
Atten_id int PRIMARY KEY,
Emp_id int,
Activity_id int,
Atten_start_datetime datetime,
Atten_end_hrs int,
FOREIGN KEY(Emp_id) REFERENCES t_emp(Emp_id),
FOREIGN KEY(Activity_id) REFERENCES t_activity(Activity_id)
);

--Insert Values to t_atten_det(ATTENDANCE TABLE)

INSERT INTO t_atten_det
VALUES(1001,1001,5,'2/13/2011 10:00:00',2),
(1002,1001,1,'1/14/2011 10:00:00',3),
(1003,1001,3,'1/14/2011 13:00:00',5),
(1004,1003,5,'2/16/2011 10:00:00',8),
(1005,1003,5,'2/17/2011 10:00:00',8),
(1006,1003,5,'2/19/2011 10:00:00',7);

--Create Table t_salary (SALARY TABLE)

CREATE TABLE t_salary
(
Salary_id int PRIMARY KEY,
Emp_id INT,
Changed_Date DATE,
New_Salary  FLOAT
);


--Insert Values in t_salary (SALARY TABLE)

INSERT INTO t_salary
VALUES(1001,1003,'2011/02/16',20000.0),
(1002,1003,'2011/01/05',25000.0),
(1003,1001,'2011/02/16',26000.0);

--Question 3 ends

--Question 4 Begins

--Question 4.1 

Select   (CASE WHEN Emp_m_name IS NULL THEN Emp_f_name+' '+Emp_l_name
			   ELSE Emp_f_name+' '+Emp_m_name+' '+Emp_l_name 
		  END) AS NAME ,
		 Emp_DOB 
FROM t_emp
WHERE DATEPART(m,Emp_DOB)=2 AND DATEPART(dd,Emp_DOB)=28 OR DATEPART(m,Emp_DOB) IN (1,3,5,7,8,10,12) AND DATEPART(dd,Emp_DOB)=31 OR DATEPART(m,Emp_DOB) IN (4,6,9,11) AND DATEPART(dd,Emp_DOB)=30;


--Question 4.1 Ends

--Question 4.3

SELECT  t_emp.Emp_f_name,
  t_atten_det.Emp_id,
  (CASE WHEN (max(t_salary.New_Salary)-min(t_salary.New_Salary))>0 
   THEN 'YES' ELSE 'NO' END) AS got_increment_in_salary,
  min(t_salary.New_Salary) AS previous_salary,
  max(t_salary.New_Salary) AS current_salary ,
  s.ss AS total_worked_hours,
  f.ff AS last_worked_activity
  
FROM t_salary 
LEFT JOIN t_emp ON t_salary.Emp_Id=t_emp.EMP_id 
LEFT JOIN t_atten_det ON t_salary.Emp_Id=t_atten_det.Emp_id  
LEFT JOIN (SELECT Emp_id, sum(atten_end_hrs) ss FROM t_atten_det group by Emp_id) s on s.Emp_id=t_emp.EMP_id 
LEFT JOIN (SELECT ACTivity_id ff,z.Emp_id FROM  t_atten_det z LEFT OUTER JOIN
(select Emp_id, MAX(Atten_Start_Datetime) g FROM t_atten_det GROUP BY Emp_id)  w ON z.Emp_id=w.Emp_id WHERE z.Atten_Start_Datetime=w.g) f ON f.Emp_id=t_emp.EMP_id
group by t_emp.Emp_f_name,t_atten_det.Emp_Id,s.ss,f.ff;

