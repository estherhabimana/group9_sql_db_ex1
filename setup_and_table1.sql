-- creating the general database
CREATE DATABASE school_system
    DEFAULT CHARACTER SET = 'utf8mb4';

USE school_system;

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

---------------------------------------------------------------


-- 2 creates table
-- 3 creates table
-- 4 creates table
-- 5 creates table

