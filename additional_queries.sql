-- Exercise 3.26
SELECT course_id, ID
FROM takes
GROUP BY course_id, ID
HAVING COUNT(*) >= 3
ORDER BY course_id;

-- Exercise 3.27
SELECT ID
FROM (SELECT ID, course_id
      FROM takes
      GROUP BY ID, course_id
      HAVING COUNT(*) >= 2) AS retaken
GROUP BY ID
HAVING COUNT(*) >= 3;

-- Exercise 3.28
SELECT i.ID, i.name
FROM instructor i
WHERE NOT EXISTS (
        SELECT c.course_id
        FROM course c
        WHERE c.dept_name = i.dept_name
      EXCEPT
        SELECT t.course_id
        FROM teaches t
        WHERE t.ID = i.ID
)
ORDER BY i.name;

-- Exercise 3.31
SELECT i.ID, i.name
FROM instructor i
WHERE NOT EXISTS (
        SELECT 1
        FROM teaches t
        JOIN takes k ON k.course_id = t.course_id
                    AND k.sec_id    = t.sec_id
                    AND k.semester  = t.semester
                    AND k.year      = t.year
        WHERE t.ID = i.ID
          AND k.grade = 'A'
);

-- Exercise 3.32
SELECT i.ID, i.name
FROM instructor i
WHERE NOT EXISTS (
        SELECT 1
        FROM teaches t
        JOIN takes k ON k.course_id = t.course_id
                    AND k.sec_id    = t.sec_id
                    AND k.semester  = t.semester
                    AND k.year      = t.year
        WHERE t.ID = i.ID
          AND k.grade = 'A'
)
AND EXISTS (
        SELECT 1
        FROM teaches t
        JOIN takes k ON k.course_id = t.course_id
                    AND k.sec_id    = t.sec_id
                    AND k.semester  = t.semester
                    AND k.year      = t.year
        WHERE t.ID = i.ID
          AND k.grade IS NOT NULL
);

-- Exercise 3.33
SELECT DISTINCT c.course_id, c.title
FROM course c
JOIN section   s  ON s.course_id    = c.course_id
JOIN time_slot ts ON ts.time_slot_id = s.time_slot_id
WHERE c.dept_name = 'Comp. Sci.'
  AND ts.end_hr >= 12;

-- Exercise 3.34
SELECT course_id, sec_id, year, semester, COUNT(ID) AS num
FROM takes
GROUP BY course_id, sec_id, year, semester
ORDER BY course_id, sec_id, year, semester;

-- Exercise 3.35
WITH sec_enrollment AS (
    SELECT course_id, sec_id, year, semester, COUNT(ID) AS num
    FROM takes
    GROUP BY course_id, sec_id, year, semester
)
SELECT course_id, sec_id, year, semester, num
FROM sec_enrollment
WHERE num = (SELECT MAX(num) FROM sec_enrollment);
