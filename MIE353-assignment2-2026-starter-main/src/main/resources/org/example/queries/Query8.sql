COPY (
    WITH studentCourses AS (
        SELECT
            tr.studentId,
            c.courseId,
            tr.grade,
            c.gradCourse,
            regexp_extract(lower(c.courseId), '^([a-z]+)', 1) AS departmentCode,
            CAST(regexp_extract(lower(c.courseId), '^[a-z]+([0-9]+)', 1) AS INTEGER) AS courseNumber
        FROM transcript tr
        JOIN course c ON c.courseId = tr.courseId
    ),
    eligible AS (
        SELECT studentId, departmentCode
        FROM studentCourses
        GROUP BY studentId, departmentCode
        HAVING COUNT(DISTINCT courseNumber) >= 2
    ),
    ranked AS (
        SELECT
            sc.*,
            ROW_NUMBER() OVER (
                PARTITION BY studentId, departmentCode
                ORDER BY CASE WHEN gradCourse = 1 THEN 1 ELSE 0 END,
                         courseNumber,
                         grade DESC,
                         courseId
            ) AS lowestRank,
            ROW_NUMBER() OVER (
                PARTITION BY studentId, departmentCode
                ORDER BY CASE WHEN gradCourse = 1 THEN 1 ELSE 0 END DESC,
                         courseNumber DESC,
                         grade DESC,
                         courseId
            ) AS highestRank
        FROM studentCourses sc
    )
    SELECT
        s.firstName || ' ' || s.lastName AS fullName,
        low.departmentCode,
        '(' || low.courseId || ', ' || high.courseId || ')' AS coursePair,
        '(' || CAST(low.grade AS VARCHAR) || ', ' || CAST(high.grade AS VARCHAR) || ')' AS gradePair
    FROM eligible e
    JOIN ranked low
      ON low.studentId = e.studentId
     AND low.departmentCode = e.departmentCode
     AND low.lowestRank = 1
    JOIN ranked high
      ON high.studentId = e.studentId
     AND high.departmentCode = e.departmentCode
     AND high.highestRank = 1
    JOIN student s ON s.studentId = e.studentId
    ORDER BY fullName, low.departmentCode
) TO 'src/main/resources/data/output/query8.csv' (HEADER, DELIMITER ',');
