COPY (
    SELECT p.firstName || ' ' || p.lastName AS fullName
    FROM professor p
    WHERE EXISTS (
        SELECT 1
        FROM teaches t
        WHERE t.profId = p.profId
    )
      AND NOT EXISTS (
        SELECT 1
        FROM teaches t
        JOIN transcript tr ON tr.courseId = t.courseId
        WHERE t.profId = p.profId
          AND tr.grade <= 49
    )
    ORDER BY fullName
) TO 'src/main/resources/data/output/query5.csv' (HEADER, DELIMITER ',');
