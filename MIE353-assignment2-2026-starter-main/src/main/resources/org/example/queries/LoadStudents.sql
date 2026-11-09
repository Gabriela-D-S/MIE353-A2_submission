CREATE TABLE IF NOT EXISTS student (
    studentId  INT PRIMARY KEY,
    lastName   VARCHAR(100) NOT NULL,
    firstName  VARCHAR(100) NOT NULL,
    email      VARCHAR(255) NOT NULL
);
COPY student FROM 'src/main/resources/data/students.csv';