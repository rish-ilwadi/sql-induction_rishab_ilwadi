--Important: Create Databases Train & Optimus before executing the script

--Tables for Section A

USE Train;

--Create Table Train_Details

CREATE TABLE Train_Details
(
Train_ID INT PRIMARY KEY,
Train_Name VARCHAR(50)
);

--Insert Values into Train_Details

INSERT INTO Train_Details
VALUES(11404,'Shatabdi'),
(22505,'Rajdhani'),
(33606,'Passenger');

--Create Table Station_Details

CREATE TABLE Station_Details
(
Station_ID INT PRIMARY KEY,
Station_Name VARCHAR(50)
);

--Insert Values into Station_Details

INSERT INTO Station_Details
VALUES(101,'Delhi'),
(102,'Aligarh'),
(103,'Lucknow'),
(104,'Kanpur');

--Create Table Journey_Details

CREATE TABLE Journey_Details
(
Train_ID INT,
Station_ID INT,
Distance INT,
Arrival_GMT DATETIME,
Departure_GMT DATETIME,
FOREIGN KEY(Train_ID) REFERENCES Train_Details(Train_ID),
FOREIGN KEY(Station_ID) REFERENCES Station_Details(Station_ID)
);

--Insert Values into Journey_Details

INSERT INTO Journey_Details
VALUES(11404,101,0,NULL,'01-25-2012 03:00:00'),
(11404,103,750,'01-25-2012 09:30:00',NULL),
(22505,101,0,NULL,'01-25-2012 15:04:00'),
(22505,102,225,'01-25-2012 5:30:00','01-25-2012 06:00:00'),
(22505,104,150,'01-25-2012 07:10:00','01-25-2012 07:50:00'),
(22505,103,100,'01-25-2012 08:30:00',NULL),
(33606,102,0,NULL,'01-25-2012 10:45:00'),
(33606,104,150,'01-25-2012 13:20:00','01-25-2012 13:45:00'),
(33606,103,100,'01-25-2012 17:20:00',NULL);


--Section A Begins

--Question 1

SELECT DISTINCT Train_Name, Station_Name,d.c AS Distance, d.c/g.e AS Average_Speed 
FROM Train_Details
INNER JOIN
Journey_Details
ON Train_Details.Train_ID=Journey_Details.Train_ID
INNER JOIN
Station_Details
ON Journey_Details.Station_ID=Station_Details.Station_ID
INNER JOIN(SELECT CAST(SUM(Distance) AS FLOAT) AS c,h.Train_ID 
FROM Journey_Details h
GROUP BY h.Train_ID) AS d
ON Journey_Details.Train_ID=d.Train_ID
INNER JOIN
(SELECT (CAST(DATEDIFF(SS,f.b,f.a) AS FLOAT)/3600.0) AS e, i.Train_ID
FROM Journey_Details i
INNER JOIN
(SELECT MAX(Arrival_GMT) AS a,MIN(Departure_GMT) AS b, j.Train_ID
FROM Journey_Details j
GROUP BY j.Train_ID) AS f
ON i.Train_ID=f.Train_ID) AS g
ON Journey_Details.Train_ID=g.Train_ID;

Train_Name	Station_Name	Distance	Average_Speed
Passenger	Aligarh	        250	        37.9746835443038
Passenger	Kanpur	        250	        37.9746835443038
Passenger	Lucknow	        250	        37.9746835443038
Rajdhani	Aligarh	        475         190
Rajdhani	Delhi	        475	        190
Rajdhani	Kanpur	        475	        190
Rajdhani	Lucknow	        475	        190
Shatabdi	Delhi	        750	        115.384615384615
Shatabdi	Lucknow	        750	        115.384615384615

--Question 1 Ends

--Question 2 Begins

--Question 2.a

SELECT TOP 1 Train_Name
FROM Train_Details
INNER JOIN (SELECT Train_ID,SUM(Distance) AS b
FROM Journey_Details
GROUP BY Train_ID) AS a
ON Train_Details.Train_ID=a.Train_ID
ORDER BY a.b DESC;

--Output
Train_Name
Shatabdi

--Question 2.b

SELECT  TOP 1 k.Train_Name AS Train_Name
FROM(SELECT DISTINCT Train_Name, Station_Name,d.c, d.c/g.e AS Average_Speed 
FROM Train_Details
INNER JOIN
Journey_Details
ON Train_Details.Train_ID=Journey_Details.Train_ID
INNER JOIN
Station_Details
ON Journey_Details.Station_ID=Station_Details.Station_ID
INNER JOIN (SELECT CAST(SUM(Distance) AS FLOAT) AS c,h.Train_ID 
FROM Journey_Details h
GROUP BY h.Train_ID) AS d
ON Journey_Details.Train_ID=d.Train_ID
INNER JOIN
(SELECT (CAST(DATEDIFF(SS,f.b,f.a) AS FLOAT)/3600.0) AS e, i.Train_ID
FROM Journey_Details i
INNER JOIN
(SELECT MAX(Arrival_GMT) AS a,MIN(Departure_GMT) AS b, j.Train_ID
FROM Journey_Details j
GROUP BY j.Train_ID) AS f
ON i.Train_ID=f.Train_ID) AS g
ON Journey_Details.Train_ID=g.Train_ID) AS k
ORDER BY k.Average_Speed DESC;

--Output

Train_Name
Rajdhani


--Question 2.c

SELECT Train_Name
FROM Train_Details 
INNER JOIN
(SELECT Train_ID,COUNT(*) AS a
FROM Journey_Details
GROUP BY Train_ID) AS b
ON Train_Details.Train_ID=b.Train_ID
WHERE b.a>=3;

--Output

Train_Name
Rajdhani
Passenger
--Question 2.d

SELECT DISTINCT Train_Name
FROM Train_Details
WHERE Train_ID NOT IN (SELECT Train_ID
FROM Journey_Details
WHERE Station_ID IN (102)
GROUP BY Train_ID) AND  Train_ID NOT IN (SELECT Train_ID
FROM Journey_Details
WHERE Station_ID IN (104)
GROUP BY Train_ID);

--Output
Train_Name
Shatabdi

--Question 2 Ends

--Question 4 Begins
 
SELECT DISTINCT b.Train_ID,Train_Name,b.a AS Boarding,d.c AS Destination
FROM Train_Details
INNER JOIN
Journey_Details
ON Train_Details.Train_ID=Journey_Details.Train_ID
INNER JOIN(SELECT  DISTINCT Train_ID,Station_Name AS a
FROM Journey_Details INNER JOIN Station_Details
ON Journey_Details.Station_ID=Station_Details.Station_ID
WHERE DISTANCE=0 AND Arrival_GMT IS NULL) AS b
ON Journey_Details.Train_ID=b.Train_ID
INNER JOIN(SELECT  DISTINCT Train_ID,Station_Name AS c
FROM Journey_Details INNER JOIN Station_Details
ON Journey_Details.Station_ID=Station_Details.Station_ID
WHERE DISTANCE>0 AND Departure_GMT IS NULL) AS d
ON Journey_Details.Train_ID=d.Train_ID;

--Output

Train_ID	Train_Name	Boarding	Destination
11404	    Shatabdi	Delhi	    Lucknow
22505		Rajdhani	Delhi	Lucknow
33606		Passenger	Aligarh	Lucknow

--Question 4 Ends

--Section B

--Create Tables
USE Optimus;
CREATE TABLE t_Dept 
(DeptId INT Primary key,
DeptName VARCHAR(50)
);

 CREATE TABLE t_Proj
(Proj_Id INT PRIMARY KEY,
Proj_Name VARCHAR(50),
DeptId INT 
);

CREATE TABLE t_Engineer
(Id INT PRIMARY KEY,
DeptId INT,
Eng_Name VARCHAR(50)
);

CREATE TABLE t_Attendance
(
Att_Id INT PRIMARY KEY,
Id INT ,
Proj_Id INT ,
Atten_Date DATE,
Hrs INT
);
INSERT INTO t_Dept
VALUES (1,'HR'),
(2,'Development'),
(3,'Testing');

INSERT INTO t_Proj
VALUES (1,'Samsung','3'),
(2,'Android','5'),
(3,'IOS','2'),
(4,'Java','3'),
(5,'.Net','2'),
(6,'AWS','4');

INSERT INTO t_Engineer
VALUES (1,2,'Siddharth'),
(2,2,'Rishab'),
(3,3,'Aditya'),
(4,3,'Shivansh'),
(5,2,'Naveen'),
(6,1,'Sharad');

INSERT INTO t_Attendance
VALUES(1,1,1,'2013-1-1',1),
(2,2,2,'2013-1-1',9),
(3,2,2,'2013-1-1',4),
(4,3,3,'2013-1-1',5),
(5,3,3,'2013-1-1',3);

--Question 1

SELECT e.Eng_Name,sum(a.Hrs) as TOTAL_HOURS
from
t_Engineer e INNER JOIN t_Attendance a
ON e.Id=a.Id
GROUP BY e.Eng_Name;

--Output

Eng_Name	TOTAL_HOURS
Aditya	     8
Rishab	     13
Siddharth	 1

--Question 2

SELECT p.Proj_Name,sum(a.Hrs) as TOTAL_HRS_PROJECT
from
t_Proj p INNER JOIN t_Attendance a
ON p.Proj_Id=a.Proj_Id
GROUP BY p.Proj_Name;

--Output

Proj_Name	TOTAL_HRS_PROJECT
Android		13
IOS			8
Samsung		1

--Section B Ends