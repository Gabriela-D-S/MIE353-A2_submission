CREATE TABLE IF NOT EXISTS course (
    courseId   VARCHAR(20) PRIMARY KEY,
    courseName VARCHAR(255) NOT NULL
);
COPY course FROM 'src/main/resources/data/courses.csv';