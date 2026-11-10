COPY (
    SELECT DISTINCT courseName
    FROM course
    WHERE regexp_extract(lower(courseId), '^[a-z]+([0-9]+)', 1) LIKE '4%'
    ORDER BY courseName
) TO 'src/main/resources/data/output/query2.csv' (HEADER, DELIMITER ',');
