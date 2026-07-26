First formative exercise learning databases, tables and operations
# School System Database

This is a group activity where we designed and built a relational database for a school system with five entities: Students, Classroom, Faculty, Courses, and Extra_Curricular_Activities.  We used MySQL to build a small database for a school. It has 5 main tables and 2 extra tables that connect students to their courses and activities.

# The database name is alu_db( the filename is alu_db.sql).
# Tables
- Classroom:contains rooms in the school (room number, building, capacity).
- Students:contains student info, each student belongs to a classroom.
- Faculty:contains teacher info (name, email, department).
- Courses:each course has a teacher and a classroom.
- Extra_Curricular_Activities: clubs/activities, each one has a teacher advisor.
- Student_Courses:connects students to the courses they take.
- Student_Activities:connects students to the activities they join.

We needed the last two "connector" tables because one student can take many courses, and one course can have many students. The same goes for activities. A normal column can't hold that many-to-many relationship, so we made separate tables just for the connections.

# Who did what
- Kabi J Paul: Classroom table
- Esther(lightsetstring): Students table
- Mathiang Mathew: Faculty table
- Benigne:Courses table
- Elnathan:Extra_Curricular_Activities table + the two connector tables

#Order that we used to build tables/things in:
 We had to build the tables in a certain order (as required) because some tables use foreign keys that point to other tables, and those tables needed to exist first:
1. Classroom and Students
2. Faculty
3. Courses (needs Faculty and Classroom to exist first)
4. Extra_Curricular_Activities (needs Faculty)
5. Student_Courses and Student_Activities (need everything else first)

# Some relationships in this activity are:
- One classroom can have many students, and one teacher can teach many courses. This is called one-to-many.
- One student can take many courses, and one course can have many students. This is many-to-many, so we used the connector tables to handle it.
- As a group we double-checked that every foreign key actually points to a real row in the other table.

# Normalization (keeping data from repeating)
We made sure each table only stores information about one thing, so we're not repeating the same data in different places. For example, a student's classroom is stored once in the Students table, not copied into every course. The connector tables handle the many-to-many parts instead of us repeating columns. 
Here's the block for point 3 — paste it near the bottom of the README, after the normalization section. Each of us fills in our own slot later.

# Group queries
Each query below was written by the group together. The explanation under each one is written by the member named, in their own words.

## Join 1 — student, course, teacher, room
Answers: "Student X is enrolled in Course Y, taught by Faculty Z, in Classroom W."

Explanation (by Esther):
_Esther: 3–5 sentences — what question does this answer, which tables does it use, and why joined in this order?_

## Join 2 — student, activity, advisor
Answers: "Student X participates in Activity Y, advised by Faculty Z."

Explanation (by Mathiang):
_Mathiang: 3–5 sentences — what question does this answer, which tables does it use, and why joined in this order?_

## Join 3 — course, room, building
Answers: "Course X is taught in Room Y of Building Z."

Explanation (by Benigne):
_Benigne: 3–5 sentences — what question does this answer, and why only two tables are needed (no connector table)?_

## Aggregate — students per course
Answers: "How many students are enrolled in each course?"

Explanation (by Elnathan):
_Elnathan: 3–5 sentences — what does it count, what does GROUP BY do, and why does the join leave out courses with no students?_

( each person pulls, replaces their own italic line with their real paragraph, commits, and pushes, one at a time, in order: Esther → Mathiang → Benigne → Elnathan.)

# What's in the SQL file
The file `alu_db.sql` has, in this order:
1. The command to create the database
2. All 5 CREATE TABLE statements, in the order they need to be built
3. Sample data (INSERT statements) for every table
4. Each person's UPDATE, DELETE, and SELECT statement, with a comment showing whose it is
5. The group's 3 JOIN queries, 1 query using COUNT/GROUP BY, and a short paragraph about normalization

# How to run it
1. Open MySQL Workbench (or any MySQL tool).
2. Run the `school_system.sql` file from top to bottom.
3. You can also run parts of it separately if you just want to test one section.
