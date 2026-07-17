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
 -- ============================================================
-- Member E: Extra_Curricular_Activities + Junction Tables
-- Student: Elnathan
-- ============================================================

-- Extra_Curricular_Activities table
CREATE TABLE Extra_Curricular_Activities (
    activity_id    INT PRIMARY KEY AUTO_INCREMENT,
    activity_name  VARCHAR(100) NOT NULL,
    activity_type  VARCHAR(50),
    schedule_day   VARCHAR(20),
    location       VARCHAR(100),
    advisor_id     INT,
    FOREIGN KEY (advisor_id) REFERENCES Faculty(faculty_id)
);

-- Junction table: Students <-> Courses (many-to-many)
CREATE TABLE Student_Courses (
    student_id  INT NOT NULL,
    course_id   INT NOT NULL,
    enrolled_on DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id)  REFERENCES Courses(course_id)
);

-- Junction table: Students <-> Activities (many-to-many)
CREATE TABLE Student_Activities (
    student_id  INT NOT NULL,
    activity_id INT NOT NULL,
    joined_on   DATE,
    PRIMARY KEY (student_id, activity_id),
    FOREIGN KEY (student_id)  REFERENCES Students(student_id),
    FOREIGN KEY (activity_id) REFERENCES Extra_Curricular_Activities(activity_id)
);

INSERT INTO Extra_Curricular_Activities (activity_name, activity_type, schedule_day, location, advisor_id)
VALUES
    ('Chess Club',         'Academic',  'Monday',    'Room 101',    1),
    ('Basketball Team',    'Sport',     'Wednesday', 'Main Gym',    2),
    ('Drama Society',      'Arts',      'Friday',    'Auditorium',  3),
    ('Science Olympiad',   'Academic',  'Tuesday',   'Lab Block B', 1),
    ('Environmental Club', 'Community', 'Thursday',  'Room 204',    2);

INSERT INTO Student_Courses (student_id, course_id, enrolled_on) VALUES
    (1,  1, '2026-01-10'),
    (4,  2, '2026-01-11'),
    (7,  1, '2026-01-12'),
    (13, 3, '2026-01-13'),
    (1,  3, '2026-01-14');

INSERT INTO Student_Activities (student_id, activity_id, joined_on) VALUES
    (1,  1, '2026-02-01'),
    (4,  2, '2026-02-02'),
    (7,  3, '2026-02-03'),
    (13, 4, '2026-02-04'),
    (1,  5, '2026-02-05');

-- Member E: UPDATE
UPDATE Extra_Curricular_Activities
SET location = 'Room 110'
WHERE activity_name = 'Chess Club';

-- Member E: DELETE
DELETE FROM Extra_Curricular_Activities
WHERE activity_name = 'Environmental Club';

-- Member E: SELECT with WHERE
SELECT activity_id, activity_name, schedule_day, location
FROM Extra_Curricular_Activities
WHERE activity_type = 'Academic';
-- ========================================
-- ===== Courses table (Member D) =====
CREATE TABLE Courses(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT,
    faculty_id INT,
    classroom_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);
INSERT INTO Courses VALUES
(101, 'Introduction to Programming', 3, 1, 2),
(102, 'Calculus I', 4, 2, 3),
(103, 'Entrepreneurship 101', 3, 3, 7),
(104, 'Global Challenges Seminar', 2, 4, 5),
(105, 'Data Structures', 4, 5, 2);
-- updating a course's credit value
UPDATE Courses
SET credits = 3
WHERE course_id = 104;

-- deleting a course (e.g. cancelled course)
DELETE FROM Courses
WHERE course_id = 105;
-- query: find all courses taught in Main Block classrooms
SELECT course_id, course_name, faculty_id, classroom_id
FROM Courses
WHERE classroom_id IN (2, 3);
USE school_system;
SELECT * FROM Courses;

