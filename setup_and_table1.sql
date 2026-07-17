-- creating the general database
CREATE DATABASE IF NOT EXISTS school_system
    DEFAULT CHARACTER SET = 'utf8mb4';

USE school_system;

-- ===== Classroom table (Kabi J Paul) =====
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

UPDATE Classroom SET capacity = 45 WHERE classroom_id = 5;
DELETE FROM Classroom WHERE classroom_id = 9;

SELECT room_number, building, capacity
FROM Classroom
WHERE building = 'Main Block' AND capacity >= 35;

-- ===== Students table (Esther) =====
CREATE TABLE Students(
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    classroom_id INT,
    enrollment_date DATE,
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);\

INSERT INTO Students VALUES
    (1,  'jane',   'jane@example.com',   5, '2026-01-05'),
    (4,  'john',   'jon@example.com',    2, '2023-05-10'),
    (13, 'furaha', 'furaha@example.com', 7, '2024-05-09'),
    (7,  'manzi',  'manzi@example.com',  5, '2026-01-05'),
    (25, 'chloe',  'chloe@example.com',  3, '2025-09-13');

UPDATE Students SET email = 'john@example.com' WHERE student_id = 4;
DELETE FROM Students WHERE student_id = 25;

SELECT classroom_id, name, student_id
FROM Students
WHERE classroom_id IN(
    SELECT classroom_id FROM Students
    GROUP BY classroom_id HAVING COUNT(student_id) >= 2
);

-- ===== Faculty table (Mathiang Mathew) =====
CREATE TABLE Faculty(
    faculty_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    department VARCHAR(50)
);

INSERT INTO Faculty VALUES
    (1, 'Amina Hassan',     'amina@example.com',  'Computer Science'),
    (2, 'John Mwangi',      'mwangi@example.com', 'Mathematics'),
    (3, 'Sarah Uwimana',    'sarah@example.com',  'Entrepreneurship'),
    (4, 'Peter Nkurunziza', 'peter@example.com',  'Global Challenges'),
    (5, 'Grace Kamau',      'grace@example.com',  'Software Engineering'),
    (6, 'David Lomude',     'david@example.com',  'Data Science');

UPDATE Faculty SET department = 'Computer Science' WHERE faculty_id = 4;
DELETE FROM Faculty WHERE faculty_id = 6;

SELECT faculty_id, name, email, department
FROM Faculty
WHERE department = 'Computer Science';

-- ===== Courses table (Benigne - Member D) =====
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
    (102, 'Calculus I',                  4, 2, 3),
    (103, 'Entrepreneurship 101',        3, 3, 7),
    (104, 'Global Challenges Seminar',   2, 4, 5),
    (105, 'Data Structures',             4, 5, 2);

UPDATE Courses SET credits = 3 WHERE course_id = 104;
DELETE FROM Courses WHERE course_id = 105;

SELECT course_id, course_name, faculty_id, classroom_id
FROM Courses
WHERE classroom_id IN (2, 3);

-- ============================================================
-- Member E: Extra_Curricular_Activities + Junction Tables
-- Student: Elnathan
-- ============================================================

CREATE TABLE Extra_Curricular_Activities (
    activity_id   INT PRIMARY KEY AUTO_INCREMENT,
    activity_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    schedule_day  VARCHAR(20),
    location      VARCHAR(100),
    faculty_advisor_id    INT,
    FOREIGN KEY (faculty_advisor_id) REFERENCES Faculty(faculty_id)
);

CREATE TABLE Student_Courses (
    student_id  INT NOT NULL,
    course_id   INT NOT NULL,
    enrolled_on DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id)  REFERENCES Courses(course_id)
);

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
    (1,  101, '2026-01-10'),
    (4,  102, '2026-01-11'),
    (7,  101, '2026-01-12'),
    (13, 103, '2026-01-13'),
    (1,  103, '2026-01-14');

INSERT INTO Student_Activities (student_id, activity_id, joined_on) VALUES
    (1,  1, '2026-02-01'),
    (4,  2, '2026-02-02'),
    (7,  3, '2026-02-03'),
    (13, 4, '2026-02-04'),
    (1,  4, '2026-02-05');

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

-- ============================================================
-- GROUP TASKS: Join queries, aggregate query, normalization
-- ==========================================================

-- Join 1: "Student X is enrolled in Course Y, taught by Faculty Z, in Classroom W."
SELECT s.name AS student, c.course_name AS course,
       f.name AS taught_by, cl.room_number AS classroom
FROM Students s
JOIN Student_Courses sc ON s.student_id = sc.student_id
JOIN Courses c ON sc.course_id = c.course_id
JOIN Faculty f ON c.faculty_id = f.faculty_id
JOIN Classroom cl ON c.classroom_id = cl.classroom_id;

-- Join 2: "Student X participates in Activity Y, advised by Faculty Z."
SELECT s.name AS student, a.activity_name AS activity,
       f.name AS advisor
FROM Students s
JOIN Student_Activities sa ON s.student_id = sa.student_id
JOIN Extra_Curricular_Activities a ON sa.activity_id = a.activity_id
JOIN Faculty f ON a.faculty_advisor_id = f.faculty_id;

-- Join 3 (our choice): "Course X is taught in Room Y of Building Z."
SELECT c.course_name AS course, cl.room_number AS room,
       cl.building AS building
FROM Courses c
JOIN Classroom cl ON c.classroom_id = cl.classroom_id;

-- Aggregate: number of students enrolled in each course
SELECT c.course_name, COUNT(sc.student_id) AS student_count
FROM Courses c
JOIN Student_Courses sc ON c.course_id = sc.course_id
GROUP BY c.course_name;

-- =============================================
-- NORMALIZATION CHECK (group discussion summary):
-- Each table stores facts about one entity only, so no data is
-- duplicated across tables. Many-to-many relationships (students
-- to courses, students to activities) are handled by the junction
-- tables Student_Courses and Student_Activities instead of repeating
-- columns; their composite primary keys (student_id, activity/course_id)
-- prevent duplicate enrollments. Repeated values like building names
-- in Classroom or a classroom_id shared by several students are
-- intentional one-to-many references, not duplication. We verified
-- every foreign key points to an existing primary key, and fixed one
-- case where a delete would have orphaned a junction row.
-- ==========================================================