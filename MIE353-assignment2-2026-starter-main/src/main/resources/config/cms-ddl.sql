-- Schema for courses.csv (entity type Course)
CREATE TABLE course (
    courseId   VARCHAR(20) PRIMARY KEY,
    courseName VARCHAR(255) NOT NULL,
    gradCourse 
);

-- Schema for professors.csv
CREATE TABLE professor (
    profId     INT PRIMARY KEY,
    lastName   VARCHAR(100) NOT NULL,
    firstName  VARCHAR(100) NOT NULL,
    email      VARCHAR(255) UNIQUE NOT NULL,
    office     VARCHAR(50)
);

-- Schema for students.csv
CREATE TABLE student (
    studentId  INT PRIMARY KEY,
    lastName   VARCHAR(100) NOT NULL,
    firstName  VARCHAR(100) NOT NULL,
    email      VARCHAR(255) NOT NULL
);

-- Schema for teaches.csv
CREATE TABLE teaches (
    profId   INT NOT NULL,
    courseId VARCHAR(20) NOT NULL,
    PRIMARY KEY (profId, courseId),
    FOREIGN KEY (profId) REFERENCES professor(profId),
    FOREIGN KEY (courseId) REFERENCES course(courseId)
);

-- Schema for transcript.csv
CREATE TABLE transcript (
    studentId INT NOT NULL,
    courseId  VARCHAR(20) NOT NULL,
    grade     INT CHECK (grade >= 0 AND grade <= 100),
    PRIMARY KEY (studentId, courseId),
    FOREIGN KEY (studentId) REFERENCES student(studentId),
    FOREIGN KEY (courseId) REFERENCES course(courseId)
);