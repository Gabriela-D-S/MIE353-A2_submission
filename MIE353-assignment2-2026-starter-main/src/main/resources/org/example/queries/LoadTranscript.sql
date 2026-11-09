CREATE TABLE IF NOT EXISTS transcript (
    studentId INT NOT NULL,
    courseId  VARCHAR(20) NOT NULL,
    grade     INT CHECK (grade >= 0 AND grade <= 100),
    PRIMARY KEY (studentId, courseId),
    FOREIGN KEY (studentId) REFERENCES student(studentId),
    FOREIGN KEY (courseId) REFERENCES course(courseId)
);
COPY transcript FROM 'src/main/resources/data/transcript.csv';
