--IMPORTANT: Please create database Travel_Records before executing

--Use Database Travel_Records

USE Travel_Records;

--Create Vendor Table

CREATE TABLE Vendor
(
VendorID INT IDENTITY(101,1) PRIMARY KEY,
Name VARCHAR(50)
);

--Insert Records into the Vendor Table

INSERT INTO Vendor
VALUES('Sai Travels'),
('Meru Cabs'),
('Miracle Cabs');

--Create Cab Table

CREATE TABLE Cab
(
CabID INT IDENTITY(201,1) PRIMARY KEY,
VendorID INT,
Number INT,
Brand_Name VARCHAR(50),
FOREIGN KEY(VendorID) REFERENCES Vendor(VendorID)

);

--Insert Records Into Cab Table

INSERT INTO Cab
VALUES(101,8529,'Mercedes'),
(103,5764,'Jaguar'),
(101,1967,'Lamborghini'),
(102,7359,'Mercedes'),
(103,1992,'Audi'),
(103,0786,'BMW'),
(101,0007,'Audi'),
(102,8541,'Fiat');

--Create User Table

CREATE TABLE [User]
(
UserID INT IDENTITY(301,1) PRIMARY KEY,
Name VARCHAR(50),
Gender VARCHAR(1),

);

--Insert records into User table

INSERT INTO [User]
VALUES('Ravi','M'),
('Kavi','M'),
('Abhi','M'),
('Savita','F'),
('Gopal','M'),
('Bhopal','M'),
('Dolly','F'),
('Tanu','F'),
('Prince','M'),
('Raj Kishore','M');

--Create Table Bookings

CREATE TABLE Bookings
(
BookingID INT IDENTITY(401,1) PRIMARY KEY,
CabID INT,
UserID INT,
Fare INT,
Distance FLOAT,
Pickup_Time DATETIME,
Drop_Time DATETIME,
Rating INT,
FOREIGN KEY(CabID) REFERENCES Cab(CabID),
FOREIGN KEY(UserID) REFERENCES [User](UserID)
);

--Insert Records into Bookings Table

INSERT INTO Bookings 
VALUES(204,309,101,13,'2015-04-07 19:00:00','2015-04-07 19:30:00',5),
(205,301,105,15.2,'2015-05-11 09:15:00','2015-05-11 10:00:00',3),
(204,309,2000,190,'2015-03-19 20:45:00','2015-03-20 01:00:00',2),
(201,302,1995,150,'2015-07-07 11:00:00','2015-07-07 15:00:00',5),
(204,303,553,50,'2014-09-12 19:00:00','2014-09-12 22:15:00',2),
(202,302,465,45,'2015-01-07 09:00:00','2015-01-07 09:40:00',1),
(205,304,258,20,'2015-07-02 03:00:00','2015-07-02 03:15:00',4),
(202,309,125,15,'2015-06-23 09:00:00','2015-06-23 10:00:00',5),
(204,310,1462,30,'2015-02-05 06:00:00','2015-02-05 08:00:00',4),
(207,306,1876,60,'2015-01-29 15:00:00','2015-01-29 18:00:00',1),
(203,308,1145,100,'2015-06-04 20:00:00','2015-06-05 06:00:00',0),
(206,309,1358,90,'2015-01-19 02:00:00','2015-01-19 08:00:00',1),
(208,301,102,5,'2015-03-21 11:00:00','2015-03-21 11:15:00',5),
(206,309,503,50,'2015-02-28 08:00:00','2015-02-28 10:00:00',4),
(204,304,786,62,'2015-03-09 16:00:00','2015-03-09 19:00:00',3),
(208,306,143,3,'2015-04-09 11:30:00','2015-04-09 11:45:00',2),
(203,309,658,12,'2015-05-04 01:00:00','2015-05-04 01:45:00',0),
(206,308,852,17,'2015-02-18 15:00:00','2015-02-18 16:00:00',1),
(208,301,450,22,'2015-03-11 18:00:00','2015-03-12 10:00:00',4),
(204,309,420,29,'2015-02-17 11:00:00','2015-02-17 21:00:00',1);

--Question 1

SELECT [User].Name, Cab.Brand_Name,Cab.Number,Calc_Travel_Time.Travel_Time
FROM Cab
INNER JOIN
(SELECT UserID,CabID,CAST(DATEDIFF(MINUTE,Pickup_Time,Drop_Time) AS FLOAT) AS Travel_Time
FROM Bookings
WHERE Fare>=500 AND Fare<=1000) AS Calc_Travel_Time
ON Cab.CabID=Calc_Travel_Time.CabID
INNER JOIN 
[User]
ON
Calc_Travel_Time.UserID=[User].UserID;
 

--Question 2

SELECT Number, Brand_Name
FROM Cab
INNER JOIN(SELECT DENSE_RANK() OVER (ORDER BY Bookings_Per_Cab.No_Of_Bookings DESC) AS Cab_Rank, Bookings_Per_Cab.CabID
FROM (SELECT COUNT(*) AS No_Of_Bookings, CabID
FROM Bookings
GROUP BY CabID) AS Bookings_Per_Cab) AS Cab_By_Rank
ON Cab.CabID=Cab_By_Rank.CabID
WHERE Cab_By_Rank.Cab_Rank=1;

--Question 3

SELECT [User].Name 
FROM [User]
INNER JOIN
(SELECT Cab_Bookings.UserID, DENSE_RANK() OVER (ORDER BY Cab_Bookings.Bookings_Per_User DESC) AS Booking_Rank 
FROM
(SELECT UserId, COUNT(*) AS Bookings_Per_User
FROM Bookings
GROUP BY UserId) AS Cab_Bookings) AS Rank_Wise_Bookings
ON [User].UserID=Rank_Wise_Bookings.UserID
WHERE Rank_Wise_Bookings.Booking_Rank<=3;

--Question 4

SELECT [User].Name,Vendor.Name, Cab_Bookings.No_Of_Bookings
FROM [User]
INNER JOIN (SELECT UserID, VendorID,Count(*) AS No_Of_Bookings
FROM Bookings 
INNER JOIN 
Cab
ON Bookings.CabID=Cab.CabID
GROUP BY VendorId,UserID) AS Cab_Bookings
ON [User].UserID=Cab_Bookings.UserID
INNER JOIN
Vendor
ON Cab_Bookings.VendorId=Vendor.VendorID


--Question 5

SELECT Brand_Name, Number,Male_Users.Count_Male_Users,Female_Users.Count_Female_Users 
FROM Cab
FULL JOIN
(SELECT CabID, Count(*) AS Count_Male_Users
FROM Bookings 
INNER JOIN 
[User]
ON Bookings.UserID=[User].UserID
WHERE [User].Gender='M'
GROUP BY CabID) AS Male_Users
ON Cab.CabID=Male_Users.CabID
FULL JOIN
(SELECT CabID, Count(*) AS Count_Female_Users
FROM Bookings 
INNER JOIN 
[User]
ON Bookings.UserID=[User].UserID
WHERE [User].Gender='F'
GROUP BY CabID) AS Female_Users
ON Cab.CabID=Female_Users.CabID;


--Question 6

SELECT Vendor_Avg_Rating.VendorID, Name, Vendor_Avg_Rating.Avg_Rating 
FROM Vendor
INNER JOIN
(SELECT VendorID, AVG(Rating) AS Avg_Rating
FROM
Cab
INNER JOIN
Bookings
ON
Cab.CabID=Bookings.CabID
GROUP BY VendorID) AS Vendor_Avg_Rating
ON Vendor.VendorID=Vendor_Avg_Rating.VendorID;

--Question 7

SELECT Cab.Brand_Name, Vendor.Name, Calc_Total_Distance.Total_Distance, CAST(Calc_Total_Distance.Total_Distance/Calc_Total_Distance.Hours_Travelled AS FLOAT) AS Average_Speed 
FROM Cab
INNER JOIN
Vendor
ON Cab.VendorID=Vendor.VendorID
INNER JOIN
(SELECT CabID,SUM(Distance) AS Total_Distance,  CAST(SUM(DATEDIFF(MINUTE,Pickup_Time,Drop_Time))/60.0  AS FLOAT) AS Hours_Travelled
FROM Bookings
GROUP BY CabID) AS Calc_Total_Distance
ON Cab.CabID=Calc_Total_Distance.CabID;


--Question 8

SELECT Name, Count_Bookings.Pickup_Time, Count_Bookings.Booking
FROM Vendor
INNER JOIN
(SELECT VendorID,Pickup_Time, Count(*) AS Booking
FROM Cab
INNER JOIN
Bookings
ON Cab.CabID=Bookings.CabID
GROUP BY Pickup_Time,VendorID) AS Count_Bookings
ON Vendor.VendorID=Count_Bookings.VendorID;


--Question 9


SELECT Cal_Min_Avg_Fare.CabID, Brand_Name, Cal_Min_Avg_Fare.Avg_Fare
FROM Cab 
INNER JOIN (SELECT Cal_Avg_Fare.CabID,DENSE_RANK() OVER(ORDER BY Cal_Avg_Fare.Avg_Fare ASC) AS Avg_Fare_Rank,Cal_Avg_fare.Avg_Fare AS Avg_Fare FROM (SELECT CabID, AVG(CAST(Cab_Fare.Total_Fare/Cab_Fare.Total_Distance AS FLOAT)) AS Avg_Fare
FROM
(SELECT CabID, SUM(Fare) AS Total_Fare, SUM(Distance) AS Total_Distance
FROM Bookings
GROUP BY CabID) AS Cab_Fare
GROUP BY CabID) AS Cal_Avg_fare) AS Cal_Min_Avg_Fare
ON Cab.CabID=Cal_Min_Avg_Fare.CabID
WHERE Cal_Min_Avg_Fare.Avg_Fare_Rank=1;