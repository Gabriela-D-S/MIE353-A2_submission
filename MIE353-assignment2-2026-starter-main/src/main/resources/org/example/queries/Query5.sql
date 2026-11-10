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
        -- if not exists condition is fulfilled = 1 
        FROM teaches t
        JOIN transcript tr ON tr.courseId = t.courseId
        WHERE t.profId = p.profId
          AND tr.grade <= 49
          -- A grade of 49 or below is failing; exclude professors with any such grade.
    )
    ORDER BY fullName
) TO 'src/main/resources/data/output/query5.csv' (HEADER, DELIMITER ',');
