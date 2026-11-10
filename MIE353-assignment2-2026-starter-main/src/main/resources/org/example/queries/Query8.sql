COPY (
    -- Join transcript rows to course metadata and split each course ID
    -- into a department code and a numeric course number (MIE250H1 -> mie, 250).
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
    -- Keep student-department groups with at least two distinct course numbers
    -- Multiple rows with the same course number count once for eligibility.
    eligible AS (
        SELECT studentId, departmentCode
        FROM studentCourses
        GROUP BY studentId, departmentCode
        HAVING COUNT(DISTINCT courseNumber) >= 2
    ),
    -- Rank courses separately for each student and department
    -- gradCourse = 0 and gradCourse = 2 are the same category
    -- Within a category, break course-number ties by higher grade, then by course ID
    ranked AS (
        SELECT
            sc.*,
            -- Lowest course: prefer gradCourse 0 or 2, then the smallest course number
            ROW_NUMBER() OVER (
                PARTITION BY studentId, departmentCode
                ORDER BY CASE WHEN gradCourse = 1 THEN 1 ELSE 0 END,
                         courseNumber,
                         grade DESC,
                         courseId
            ) AS lowestRank,
            -- Highest course: prefer gradCourse 1, then the largest course number
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
    -- Join ranked twice to put the lowest and highest course pairs side by side
    -- for the same student and department, using rank 1 from each ordering
    FROM eligible e
     -- Pick the lowest-ranked course for this student and department
    -- Match both fields because every student-department group has its own rank 1
    JOIN ranked low
      ON low.studentId = e.studentId
     AND low.departmentCode = e.departmentCode
     AND low.lowestRank = 1
     -- Join ranked again to attach the highest course to the same output row
    JOIN ranked high
      ON high.studentId = e.studentId
     AND high.departmentCode = e.departmentCode
     AND high.highestRank = 1
    JOIN student s ON s.studentId = e.studentId
    ORDER BY fullName, low.departmentCode
) TO 'src/main/resources/data/output/query8.csv' (HEADER, DELIMITER ',');
