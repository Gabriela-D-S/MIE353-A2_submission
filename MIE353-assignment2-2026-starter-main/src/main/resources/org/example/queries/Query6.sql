COPY (
    SELECT s.firstName || ' ' || s.lastName AS fullName
    FROM student s
    WHERE EXISTS (
        SELECT 1
        FROM transcript tr
        JOIN course c ON c.courseId = tr.courseId
        WHERE tr.studentId = s.studentId
          AND c.courseName = 'Data Modelling'
    )
    -- This also requires a grade of 90 or above in a course other than Data Modelling.
    -- In SQL, <> means "not equal to".
      AND EXISTS (
        SELECT 1
        FROM transcript tr
        JOIN course c ON c.courseId = tr.courseId
        WHERE tr.studentId = s.studentId
          AND c.courseName <> 'Data Modelling'
          AND tr.grade >= 90
    )
    ORDER BY fullName
) TO 'src/main/resources/data/output/query6.csv' (HEADER, DELIMITER ',');
