-- =====================================================================
-- SQL Foundations & Database Operations  |  Mini Project 1
-- Skills: DDL, DML, INSERT, UPDATE, DELETE, ALTER TABLE, RENAME, CASE
-- Scenario: Student & Course management for a training institute
-- Engine : MySQL 8+ (also runs on MariaDB 10.5+). Run top to bottom.
-- =====================================================================

-- [STEP 1] CREATE DATABASE ---------------------------------------------
DROP DATABASE IF EXISTS bleep_training;
CREATE DATABASE bleep_training;
USE bleep_training;
SHOW DATABASES LIKE 'bleep_training';

-- [STEP 2] CREATE TABLES (DDL) ------------------------------------------
CREATE TABLE courses (
    course_id   INT          PRIMARY KEY,
    course_name VARCHAR(60)  NOT NULL,
    duration_wk INT          NOT NULL,
    fee         INT          NOT NULL
);

CREATE TABLE students (
    student_id  INT          PRIMARY KEY,
    full_name   VARCHAR(60)  NOT NULL,
    city        VARCHAR(40),
    course_id   INT,
    score       INT,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

DESCRIBE courses;
DESCRIBE students;

-- [STEP 3] INSERT RECORDS (DML) -----------------------------------------
INSERT INTO courses (course_id, course_name, duration_wk, fee) VALUES
(1, 'SQL Foundations',    4,  5000),
(2, 'Python Basics',      6,  7000),
(3, 'Data Analytics',     8, 12000),
(4, 'Web Development',   10, 15000);

INSERT INTO students (student_id, full_name, city, course_id, score) VALUES
(101, 'Aarav Sharma',  'Lucknow', 1, 92),
(102, 'Diya Verma',    'Kanpur',  2, 78),
(103, 'Rohan Gupta',   'Lucknow', 3, 65),
(104, 'Isha Singh',    'Delhi',   1, 55),
(105, 'Kabir Khan',    'Noida',   4, 88),
(106, 'Meera Joshi',   'Kanpur',  3, 41),
(107, 'Nikhil Yadav',  'Lucknow', 2, 73);

SELECT * FROM courses;
SELECT * FROM students;

-- [STEP 4] MODIFY TABLE STRUCTURE (ALTER TABLE) -------------------------
ALTER TABLE students ADD COLUMN email VARCHAR(80);
ALTER TABLE students ADD COLUMN phone VARCHAR(15);
ALTER TABLE students DROP COLUMN phone;
DESCRIBE students;

-- [STEP 5] RENAME COLUMNS ------------------------------------------------
ALTER TABLE students RENAME COLUMN full_name TO student_name;
ALTER TABLE courses  RENAME COLUMN duration_wk TO duration_weeks;
DESCRIBE students;
DESCRIBE courses;

-- [STEP 6] UPDATE EXISTING RECORDS --------------------------------------
UPDATE students SET email = 'aarav.sharma@example.com' WHERE student_id = 101;
UPDATE students SET email = 'diya.verma@example.com'   WHERE student_id = 102;
UPDATE students SET city = 'Lucknow'                   WHERE student_id = 106;
UPDATE students SET score = score + 5                  WHERE course_id = 3;
UPDATE courses  SET fee = fee + 1000                   WHERE course_id = 1;

SELECT student_id, student_name, city, score, email FROM students;
SELECT * FROM courses;

-- [STEP 7] DELETE RECORDS ------------------------------------------------
DELETE FROM students WHERE student_id = 107;
DELETE FROM students WHERE score < 50;

SELECT * FROM students;

-- [STEP 8] CONDITIONAL LOGIC (CASE) - Fee level per course --------------
SELECT course_name,
       fee,
       CASE
           WHEN fee >= 12000 THEN 'Premium'
           WHEN fee >= 6000  THEN 'Standard'
           ELSE 'Basic'
       END AS fee_level
FROM courses;

-- [STEP 9] CREATE CATEGORIES USING CASE - Student performance grade -----
SELECT student_id,
       student_name,
       score,
       CASE
           WHEN score >= 90 THEN 'A - Excellent'
           WHEN score >= 75 THEN 'B - Good'
           WHEN score >= 60 THEN 'C - Average'
           ELSE 'D - Needs Improvement'
       END AS performance_category
FROM students
ORDER BY score DESC;

-- Bonus: count of students per category
SELECT CASE
           WHEN score >= 90 THEN 'A - Excellent'
           WHEN score >= 75 THEN 'B - Good'
           WHEN score >= 60 THEN 'C - Average'
           ELSE 'D - Needs Improvement'
       END AS performance_category,
       COUNT(*) AS total_students
FROM students
GROUP BY performance_category
ORDER BY total_students DESC;
-- ======================== END OF SCRIPT ==============================
