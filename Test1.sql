--Important : Create Database Emp before executing the script

USE Emp1;

--Create Table Department

CREATE TABLE Department(DeptID INT PRIMARY KEY,DeptName VARCHAR(50),DeptHeadID INT);

--Insert Values into Department Table

INSERT INTO Department 
VALUES(1,'HR',1),
(2,'Admin',2),
(3,'Sales',9),
(4,'Engineering',5);

--Create Table Employee

CREATE TABLE Employee(Id INT PRIMARY KEY, Name VARCHAR(50),Gender VARCHAR(50), 
Basic INT,HR INT,DA INT,TAX INT,DeptID INT,
FOREIGN KEY (DeptID) REFERENCES Department(DeptID));

--Insert Values into Employee Table

INSERT INTO Employee(Id,Name,Gender,Basic,HR,DA,TAX,DeptID)
VALUES
(1,'Anil','Male',10000,5000,1000,400,1),
(2,'Sanjana','Female',12000,6000,1000,500,2),
(3,'Johnny','Male',5000,2500,500,200,3),
(4,'Suresh','Male',6000,3000,500,250,1),
(5,'Anglia','Female',11000,5500,1000,500,4),
(6,'Saurabh','Male',12000,6000,1000,600,1),
(7,'Manish','Male',4000,2000,500,150,2),
(8,'Neeraj','Male',5000,2500,500,200,3),
(9,'Suman','Female',5000,2500,500,200,4),
(10,'Tina','Female',6000,3000,500,220,1);

--Create Table EmployeeAttendance

CREATE TABLE EmployeeAttendance
(
EmpID INT,
Atten_Date DATE,
WorkingDays INT,
PresentDays INT,
FOREIGN KEY(EmpID) REFERENCES Employee(Id)
);

--Insert Values Into EmployeeAttendance

INSERT INTO EmployeeAttendance
VALUES(1,'2010-01-01',22,21),
(1,'2010-02-01',20,20),
(1,'2010-03-01',22,20),
(2,'2010-01-01',22,22),
(2,'2010-02-01',20,20),
(2,'2010-03-01',22,22),
(3,'2010-01-01',22,21),
(3,'2010-02-01',20,20),
(3,'2010-03-01',22,21),
(4,'2010-01-01',22,21),
(4,'2010-02-01',20,19),
(4,'2010-03-01',22,22),
(5,'2010-01-01',22,22),
(5,'2010-02-01',20,20),
(5,'2010-03-01',22,22),
(6,'2010-01-01',22,21),
(6,'2010-02-01',20,20),
(6,'2010-03-01',22,20),
(7,'2010-01-01',22,21),
(7,'2010-02-01',20,20),
(7,'2010-03-01',22,21),
(8,'2010-01-01',22,21),
(8,'2010-02-01',20,20),
(8,'2010-03-01',22,21),
(9,'2010-01-01',22,22),
(9,'2010-02-01',20,20),
(9,'2010-03-01',22,21),
(10,'2010-01-01',22,22),
(10,'2010-02-01',20,20),
(10,'2010-03-01',22,22);

--Question 1:


SELECT DeptName,Gender,Count(*) AS No_of_Employees
FROM Employee 
INNER JOIN
Department
ON Employee.DeptId=Department.DeptID
GROUP BY Gender,DeptName;

--Question 2:

SELECT DeptName,Count(*) AS No_of_Employees, MAX(Basic+HR+DA) AS Highest_Gross_Salary,SUM(Basic+HR+DA-TAX) AS Total_Salary
FROM Employee 
INNER JOIN
Department
ON Employee.DeptId=Department.DeptID
GROUP BY DeptName;

--Question 3:

SELECT DeptName,Name,b.c AS Highest_Gross_Salary
FROM Employee 
INNER JOIN
Department
ON Employee.DeptId=Department.DeptID
INNER JOIN(SELECT DeptID,Max(Basic+HR+DA) AS c
FROM Employee
GROUP BY DeptID) AS b
ON Employee.DeptID=b.DeptID
WHERE (Basic+HR+DA)=b.c;

--Question 4

SELECT Id,Name
FROM EMPLOYEE
WHERE (Basic+HR+DA)>15000;

--Question 5

SELECT Id,Name
From Employee
WHERE Basic IN(SELECT Min(Basic) 
FROM Employee
WHERE Basic IN (SELECT DISTINCT TOP 2 Basic FROM Employee ORDER BY Basic DESC));

--Question 6

SELECT DeptName, a.b AS No_Of_Employees
From Department
INNER JOIN(SELECT COUNT(*) AS b,DeptID
FROM EMPLOYEE
GROUP BY DeptID) AS a
ON Department.DeptID=a.DeptID
WHERE a.b>3;

--Question 7

SELECT DeptName, Name AS Dept_Head_Name
FROM Employee
INNER JOIN
Department
ON Employee.Id=Department.DeptHeadID;

--Question 8

SELECT  DISTINCT Name
FROM Employee
INNER JOIN
EmployeeAttendance
ON Employee.Id=EmployeeAttendance.EmpID
INNER JOIN
(SELECT SUM(WorkingDays) AS a,SUM(PresentDays) AS b,EmpID
FROM EmployeeAttendance
GROUP BY EmpID) AS c
ON Employee.Id=c.EmpID
WHERE c.a=c.b;

--Question 9

SELECT  DISTINCT Name
FROM Employee
INNER JOIN
EmployeeAttendance
ON Employee.Id=EmployeeAttendance.EmpID
INNER JOIN
(SELECT SUM(PresentDays) AS b,EmpID
FROM EmployeeAttendance
GROUP BY EmpID) AS c
ON Employee.Id=c.EmpID
Where  c.b=(SELECT MIN(e.f)
From Employee inner join(SELECT SUM(PresentDays) AS f,EmpID
FROM EmployeeAttendance
GROUP BY EmpID) AS e
ON Employee.Id=e.EmpID);

--Question 10


SELECT  DISTINCT Name
FROM Employee
INNER JOIN
EmployeeAttendance
ON Employee.Id=EmployeeAttendance.EmpID
INNER JOIN
(SELECT SUM(WorkingDays) AS a,SUM(PresentDays) AS b,EmpID
FROM EmployeeAttendance
GROUP BY EmpID) AS c
ON Employee.Id=c.EmpID
WHERE c.a-c.b>3;
