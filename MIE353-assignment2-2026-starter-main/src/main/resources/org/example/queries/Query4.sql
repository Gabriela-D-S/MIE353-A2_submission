COPY (
    SELECT DISTINCT p.firstName || ' ' || p.lastName AS fullName
    FROM professor p
    WHERE EXISTS (
        SELECT 1
        FROM teaches t
        JOIN transcript tr ON tr.courseId = t.courseId
        JOIN student s ON s.studentId = tr.studentId
        WHERE t.profId = p.profId
          AND s.firstName = 'Rebecca'
          AND s.lastName = 'Ward'
    )
    ORDER BY fullName
) TO 'src/main/resources/data/output/query4.csv' (HEADER, DELIMITER ',');
