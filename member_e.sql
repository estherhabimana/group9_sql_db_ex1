-- ============================================================
-- Member E: Extra_Curricular_Activities and Junction Tables
-- Student name : 
-- ============================================================

USE school_system;

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

-- ============================================================
-- Member E: INSERT 5 rows into Extra_Curricular_Activities
-- ============================================================
INSERT INTO Extra_Curricular_Activities (activity_name, activity_type, schedule_day, location, advisor_id)
VALUES
    ('Chess Club',         'Academic',  'Monday',    'Room 101',    1),
    ('Basketball Team',    'Sport',     'Wednesday', 'Main Gym',    2),
    ('Drama Society',      'Arts',      'Friday',    'Auditorium',  3),
    ('Science Olympiad',   'Academic',  'Tuesday',   'Lab Block B', 1),
    ('Environmental Club', 'Community', 'Thursday',  'Room 204',    2);

-- Junction inserts (uses existing student IDs: 1, 4, 7, 13 from Students table)
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

-- ============================================================
-- Member E: UPDATE
-- ============================================================
UPDATE Extra_Curricular_Activities
SET location = 'Room 110'
WHERE activity_name = 'Chess Club';

-- ============================================================
-- Member E: DELETE
-- ============================================================
DELETE FROM Extra_Curricular_Activities
WHERE activity_name = 'Environmental Club';

-- ============================================================
-- Member E: SELECT with WHERE
-- ============================================================
SELECT activity_id, activity_name, schedule_day, location
FROM Extra_Curricular_Activities
WHERE activity_type = 'Academic';
