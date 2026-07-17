-- creating the general database
CREATE DATABASE school_system
    DEFAULT CHARACTER SET = 'utf8mb4';

USE school_system;

-- ===== Classroom table (Pogba / Kabi J Paul) =====
-- Must come before Students: Students.classroom_id references this table
CREATE TABLE Classroom(
    classroom_id INT PRIMARY KEY,
    room_number VARCHAR(10),
    building VARCHAR(50),
    capacity INT
);


INSERT INTO Classroom VALUES
    (2, 'A101', 'Main Block', 40),
    (3, 'A205', 'Main Block', 35),
    (5, 'B12', 'Science Wing', 30),
    (7, 'C03', 'Library', 25),
    (9, 'B14', 'Science Wing', 50);


UPDATE Classroom
SET capacity = 45
WHERE classroom_id = 5;

-- delete: room 9 decommissioned 
DELETE FROM Classroom
WHERE classroom_id = 9;

-- query: find large classrooms in the Main Block
SELECT room_number, building, capacity
FROM Classroom
WHERE building = 'Main Block' AND capacity >= 35;


-- 1 creates student table
CREATE TABLE Students(  
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    classroom_id INT, -- REFERENCES Classroom(classroom_id),
    enrollment_date DATE
);
-- inserting values into our students' table
INSERT INTO Students VALUES 
    (1, 'jane', 'jane@example.com', 5, '2026-01-05'), 
    (4, 'john', 'jon@example.com', 2, '2023-05-10'), 
    (13, 'furaha', 'furaha@example.com', 7, '2024-05-09'), 
    (7, 'manzi', 'manzi@example.com', 5, '2026-01-05'), 
    (25, 'chloe', 'chloe@example.com', 3, '2025-09-13');

-- updating and deleting values in the students' table
-- updating
UPDATE Students
SET
    email = 'john@example.com'
WHERE student_id = 4;

-- deleting
DELETE FROM Students
WHERE student_id = 25;

-- querrying the students table for students in same class

SELECT classroom_id, name, student_id
FROM Students
WHERE classroom_id IN(
    SELECT classroom_id
    FROM Students
    GROUP BY classroom_id
    HAVING COUNT(student_id) >= 2
);

-- ===== Faculty table (Mathiang Mathew) =====

CREATE TABLE Faculty(
    faculty_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    department VARCHAR(50)
);
INSERT INTO Faculty VALUES
(1, 'Amina Hassan', 'amina@example.com', 'Computer Science'),
(2, 'John Mwangi', 'mwangi@example.com', 'Mathematics'),
(3, 'Sarah Uwimana', 'sarah@example.com', 'Entrepreneurship'),
(4, 'Peter Nkurunziza', 'peter@example.com', 'Global Challenges'),
(5, 'Grace Kamau', 'grace@example.com', 'Software Engineering'),
(6, 'David Lomude', 'david@example.com', 'Data Science');
-- updating and deleting values in the faculty table
UPDATE Faculty
SET department = 'Computer Science'
WHERE faculty_id = 4;
-- delete: row 6 is a spare, kept clear of any reference from
-- Courses or Extra_Curricular_Activities
DELETE FROM Faculty
WHERE faculty_id = 6;
-- query: faculty in the Computer Science department
SELECT faculty_id, name, email, department
FROM Faculty
WHERE department = 'Computer Science';
-- 3 creates table
-- 4 creates table
-- 5 creates table

