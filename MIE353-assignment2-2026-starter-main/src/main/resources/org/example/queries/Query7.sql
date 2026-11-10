COPY (
    SELECT
        s1.firstName || ' ' || s1.lastName AS student1,
        s2.firstName || ' ' || s2.lastName AS student2,
        COUNT(*) AS commonCourseCount,
        AVG(tr1.grade) AS student1Average,
        AVG(tr2.grade) AS student2Average
        --compute the averages across the grades in the transcript tables 
    FROM transcript tr1
    JOIN transcript tr2
    -- tr1 and tr2 are copies of the transcript table
    -- join 2 copies of the transcript table to find PAIRS of students who have taken at least 3 courses together
      ON tr2.courseId = tr1.courseId
     AND tr1.studentId < tr2.studentId
     -- avoid matching a student with themselves as this wouldn't be a valid pair
    JOIN student s1 ON s1.studentId = tr1.studentId
    JOIN student s2 ON s2.studentId = tr2.studentId
    -- look up the student names for each student in the pair and join with their grades from the transcript tables so that the average can be computed 
    GROUP BY s1.studentId, s1.firstName, s1.lastName,
             s2.studentId, s2.firstName, s2.lastName
             --group by will place the student pairs 
    HAVING COUNT(*) >= 3
    -- count the rows in each group, keep the pairs only with 3 or more courses taken together
    ORDER BY student1, student2
    -- sort the rows by the first student in the pair, then by the second student in the pair
    -- order by sorts by ascending order by default, so names A-Z 
) TO 'src/main/resources/data/output/query7.csv' (HEADER, DELIMITER ',');
