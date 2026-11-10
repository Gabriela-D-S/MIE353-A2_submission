COPY (
    SELECT p.firstName || ' ' || p.lastName AS fullName
    FROM professor p
    JOIN teaches t ON t.profId = p.profId
    GROUP BY p.profId, p.firstName, p.lastName
    HAVING COUNT(DISTINCT t.courseId) = 1
    ORDER BY fullName
) TO 'src/main/resources/data/output/query3.csv' (HEADER, DELIMITER ',');
