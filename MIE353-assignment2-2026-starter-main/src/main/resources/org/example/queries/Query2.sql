COPY (
    SELECT DISTINCT courseName
    FROM course
    WHERE regexp_extract(lower(courseId), '^[a-z]+([0-9]+)', 1) LIKE '4%'
    -- use regex to extract the numeric code beginning with 4 right after the department code
    ORDER BY courseName
) TO 'src/main/resources/data/output/query2.csv' (HEADER, DELIMITER ',');
