COPY (
    SELECT COUNT(DISTINCT studentId) AS studentCount
    FROM transcript
    WHERE courseId = 'mie301h1f'
      AND grade >= 80
) TO 'src/main/resources/data/output/query1.csv' (HEADER, DELIMITER ',');
