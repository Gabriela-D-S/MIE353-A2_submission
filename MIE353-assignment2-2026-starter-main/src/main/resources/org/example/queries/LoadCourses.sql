CREATE TABLE IF NOT EXISTS course (
    courseId   VARCHAR(20) PRIMARY KEY,
    courseName VARCHAR(255) NOT NULL,
    gradCourse INT NOT NULL CHECK (gradCourse IN (0, 1, 2))
    --need to add the gradCourse column in the LoadCourses query
);
COPY course FROM 'src/main/resources/data/courses.csv';