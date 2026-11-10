COPY (
    SELECT
        s1.firstName || ' ' || s1.lastName AS student1,
        s2.firstName || ' ' || s2.lastName AS student2,
        COUNT(*) AS commonCourseCount,
        AVG(tr1.grade) AS student1Average,
        AVG(tr2.grade) AS student2Average
    FROM transcript tr1
    JOIN transcript tr2
      ON tr2.courseId = tr1.courseId
     AND tr1.studentId < tr2.studentId
    JOIN student s1 ON s1.studentId = tr1.studentId
    JOIN student s2 ON s2.studentId = tr2.studentId
    GROUP BY s1.studentId, s1.firstName, s1.lastName,
             s2.studentId, s2.firstName, s2.lastName
    HAVING COUNT(*) >= 3
    ORDER BY student1, student2
) TO 'src/main/resources/data/output/query7.csv' (HEADER, DELIMITER ',');
