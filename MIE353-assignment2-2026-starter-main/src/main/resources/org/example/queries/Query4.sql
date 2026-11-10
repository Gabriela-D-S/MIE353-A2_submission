COPY (
    SELECT DISTINCT p.firstName || ' ' || p.lastName AS fullName
    -- || ' '|| adds a space between the first and last name as per the assignment request
    FROM professor p
    WHERE EXISTS (
        SELECT 1
        -- select 1 checks if a professor has taught a course to a student named Rebecca Ward, if the exists condition is fulfilled (1)
        FROM teaches t
        JOIN transcript tr ON tr.courseId = t.courseId
        JOIN student s ON s.studentId = tr.studentId
        WHERE t.profId = p.profId
          AND s.firstName = 'Rebecca'
          AND s.lastName = 'Ward'
    )
    ORDER BY fullName
) TO 'src/main/resources/data/output/query4.csv' (HEADER, DELIMITER ',');
