-- DBMS JOIN PRACTICE
-- Learning Purpose
-- Topic: SQL JOINs

CREATE DATABASE IF NOT EXISTS dbms_practice;

USE dbms_practice;

-- 1. CREATE TABLES


create table Students (
    StudentID int PRIMARY KEY,
    StudentName varchar(100),
    Age int
);


create table Courses (
    CourseID int PRIMARY KEY,
    CourseName varchar(100),
    Credits int
);


create table Enrollments (
    StudentID int,
    CourseID int,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


-- 2. INSERT DATA


insert into Students (StudentID, StudentName, Age) values
(1, 'Raj', 20),
(2, 'Aman', 22),
(3, 'Amit', 21),
(4, 'Rohan', 23);


insert into Courses (CourseID, CourseName, Credits) values
(1, 'Mathematics', 3),
(2, 'Physics', 4),
(3, 'Chemistry', 3),
(4, 'Biology', 2);


insert into Enrollments (StudentID, CourseID) values
(1, 1),
(1, 2),
(2, 1),
(3, 3);


-- 3. INNER JOIN
-- Only matching records


select Student.StudentID, Student.StudentName, Courses.CourseName
from Students as Student
inner join Enrollments as Enrollment
on Student.StudentID = Enrollment.StudentID
inner join Courses as Courses
on Enrollment.CourseID = Courses.CourseID;


-- 4. LEFT JOIN
-- All records from left table


select Student.StudentID, Student.StudentName, Courses.CourseName
from Students as Student
left join Enrollments as Enrollment
on Student.StudentID = Enrollment.StudentID
left join Courses as Courses
on Enrollment.CourseID = Courses.CourseID;


-- 5. RIGHT JOIN
-- All records from right table


select Student.StudentID, Student.StudentName, Courses.CourseName
from Students as Student
right join Enrollments as Enrollment
on Student.StudentID = Enrollment.StudentID
right join Courses as Courses
on Enrollment.CourseID = Courses.CourseID;


-- 6. FULL OUTER JOIN
-- All records from both tables


select Student.StudentID, Student.StudentName, Courses.CourseName
from Students as Student
full outer join Enrollments as Enrollment
on Student.StudentID = Enrollment.StudentID
full outer join Courses as Courses
on Enrollment.CourseID = Courses.CourseID;


-- 7. CROSS JOIN
-- Every possible combination


select Student.StudentID, Student.StudentName, Courses.CourseName
from Students as Student
cross join Courses as Courses;


-- 8. SELF JOIN
-- Joining a table with itself


create table Employees (
    EmployeeID int PRIMARY KEY,
    EmployeeName varchar(100),
    ManagerID int
);


insert into Employees (EmployeeID, EmployeeName, ManagerID) values
(1, 'Aman', NULL),
(2, 'Raj', 1),
(3, 'Amit', 1),
(4, 'Rohan', 2);


select 
    E1.EmployeeID,
    E1.EmployeeName as Employee,
    E2.EmployeeName as Manager
from Employees as E1
inner join Employees as E2
on E1.ManagerID = E2.EmployeeID;


-- 9. NATURAL JOIN


create table Departments (
    DepartmentID int PRIMARY KEY,
    DepartmentName varchar(100)
);


alter table Students
add DepartmentID int;


insert into Departments (DepartmentID, DepartmentName) values
(1, 'Computer Science'),
(2, 'Information Technology');


update Students
set DepartmentID = 1
where StudentID in (1, 3);


update Students
set DepartmentID = 2
where StudentID in (2, 4);


select *
from Students
natural join Departments;