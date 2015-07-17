--Important: Create Database Social_Networking before executing the script

--Using Database Social_Networking

USE Social_Networking;

--Creating T_User Table

--UserID Auto Incremented

CREATE TABLE T_User
(
UserID  INT IDENTITY(101,1) PRIMARY KEY,  
Name VARCHAR(50),
Country	VARCHAR(50),
Gender VARCHAR,
);

--Inserting records into T_User Table

INSERT INTO T_User(Name,Country,Gender)
VALUES('Harsh','India','M'),
('Richa','Sri Lanka','F'),
('Richard','US','M'),
('Gopal','India','M'),
('Jennifer','US','F'),
('Karishma','India','F'),
('Clinton','US','M'),
('Sadhna','India','F');

--Creating Post Table

--PostID Auto Incremented

CREATE TABLE T_Post
(
PostID INT IDENTITY(201,1) PRIMARY KEY,
UserID INT,
Post VARCHAR(100),
FOREIGN KEY(UserId) REFERENCES T_User(UserID)
);

--Insert Values into T_Post Table

INSERT INTO T_Post(UserID,Post)
VALUES(104,'My name is Gopal'),
(101,'Hello Friends'),
(105,'Bon Voyage'),
(104,'Cherishing Life'),
(108,'Switching Lanes'),
(105,'Feeling Nostalgic'),
(102,'Sangakkara Rocks'),
(104,'Bleeding Blue');

-- Creating Table T_Friend_Request

--RequestID Auto Incremented

CREATE TABLE T_Friend_Request
(
RequestID INT IDENTITY(301,1) PRIMARY KEY,
SenderID INT,
ReceiverID INT,
Status VARCHAR(20)
);

--Insert Records Into T_Friend_Request Table

INSERT INTO T_Friend_Request(SenderID,ReceiverID,Status)
VALUES(101,102,'Approved'),
(107,105,'Rejected'),
(101,106,'Approved'),
(108,101,'Approved'),
(106,103,'Approved'),
(104,108,'Pending'),
(104,101,'Approved'),
(105,102,'Pending'),
(107,103,'Approved'),
(106,102,'Rejected');

--Creating Table T_Post_Likes

--LikeID Auto Incremented

CREATE TABLE T_Post_Likes
(
LikeID INT IDENTITY(401,1) PRIMARY KEY,
PostID INT,
UserID INT,
FOREIGN KEY(UserID) REFERENCES T_User(UserID),
FOREIGN KEY(PostID) REFERENCES T_Post(PostID)
);

--Insert Records in T_Post_Likes Table

INSERT INTO T_Post_Likes(PostID,UserID)
VALUES(203,102),
(208,108),
(204,106),
(203,108),
(207,102),
(202,102),
(203,106),
(205,102),
(204,107),
(203,101);

--Question 1 

SELECT TOP 1 PostCount.Country 
FROM
(SELECT DISTINCT Count(Country) AS Country_Count, Country
FROM T_User
INNER JOIN 
T_Post
ON T_User.UserID=T_Post.UserID
GROUP BY Country) AS PostCount;

--Question 2

SELECT Name, Post.Country FROM
T_User INNER JOIN (SELECT DISTINCT COUNT(*) AS Post_Count,T_User.UserID, Country
FROM T_User
INNER JOIN 
T_Post
ON T_User.UserID=T_Post.UserID
GROUP BY Country,T_User.UserID) AS Post
ON T_User.UserID=Post.UserID
INNER JOIN (SELECT MAX(MaxPost.Post_Count) AS Maxm_Post, MaxPost.Country AS Country 
FROM (SELECT DISTINCT COUNT(*) AS Post_Count,T_User.UserID, Country
FROM T_User
INNER JOIN 
T_Post
ON T_User.UserID=T_Post.UserID
GROUP BY Country,T_User.UserID) AS MaxPost GROUP BY MaxPost.Country) AS Maximum
ON T_User.Country=Maximum.Country
WHERE Post.Post_Count=Maximum.Maxm_Post;


--Question 4

Select Name
from T_User
inner join
(SELECT DISTINCT Count(*) AS Post_Count,UserID
FROM T_Post_Likes
GROUP BY T_Post_Likes.UserID) AS MaxLike
ON T_User.UserID=MaxLike.UserID
WHERE MaxLike.Post_Count=(SELECT MAX(MaxLike.Post_Count) FROM (SELECT DISTINCT Count(*) AS Post_Count,T_Post_Likes.UserID
FROM T_Post_Likes
GROUP BY T_Post_Likes.UserID) AS MaxLike);

--Question 5

SELECT DISTINCT T_Friend_Request.SenderID, Name
FROM
T_User
inner join T_Friend_Request
ON T_User.UserID=T_Friend_Request.SenderID
left join(SELECT DISTINCT SenderID,Status FROM T_Friend_Request WHERE Status='Approved' GROUP BY SenderID,Status) AS Counter
ON T_Friend_Request.SenderID=Counter.SenderID
WHERE  Counter.SenderID IS NULL;

--Question 6

Select DISTINCT MaxLike.UserID, Post
From
T_Post
inner join(SELECT Count(T_Post_Likes.PostID) AS Post_Count,T_Post.UserID AS UserID,T_Post_Likes.PostID AS PostID
FROM T_Post_Likes
left join  T_Post
ON 
T_Post_Likes.PostID=T_Post.PostID
GROUP BY T_Post.UserID,T_Post_Likes.PostID) AS MaxLike
ON T_Post.UserID=MaxLike.UserID;


--Question 7

SELECT DISTINCT Country, Count(*) AS No_Of_Posts
FROM T_User
INNER JOIN 
T_Post
ON T_User.UserID=T_Post.UserID
GROUP BY Country;

--Question 8

SELECT DISTINCT Country,Gender, Count(*) AS No_Of_Posts
FROM T_User
INNER JOIN 
T_Post
ON T_User.UserID=T_Post.UserID
GROUP BY Country,Gender
ORDER BY Country;



