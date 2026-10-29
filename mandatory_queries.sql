-- =====================================================================
-- Məcburi tapşırıqlar: 3.11 (a-d), 3.15 (a-c), 3.24, 3.25
-- =====================================================================


-- ---------------------------------------------------------------------
-- Exercise 3.11 (Universitet sxemi)
-- ---------------------------------------------------------------------

-- Exercise 3.11(a)
-- Ən azı bir "Comp. Sci." kursu almış tələbələrin ID və adı (təkrarsız)
SELECT DISTINCT s.ID, s.name
FROM student s
JOIN takes  t ON t.ID = s.ID
JOIN course c ON c.course_id = t.course_id
WHERE c.dept_name = 'Comp. Sci.';

-- Exercise 3.11(b)
-- 2017-ci ildən əvvəl təklif olunan heç bir kursu almamış tələbələrin ID və adı
SELECT ID, name
FROM student
WHERE ID NOT IN (SELECT ID
                 FROM takes
                 WHERE year < 2017);

-- Exercise 3.11(c)
-- Hər departament üzrə müəllimlərin maksimum maaşı
SELECT dept_name, MAX(salary) AS max_salary
FROM instructor
GROUP BY dept_name;

-- Exercise 3.11(d)
-- (c)-də hesablanmış departament maksimumları arasında ən aşağısı
SELECT MIN(max_salary) AS lowest_dept_max_salary
FROM (SELECT dept_name, MAX(salary) AS max_salary
      FROM instructor
      GROUP BY dept_name) AS dept_max;


-- ---------------------------------------------------------------------
-- Exercise 3.15 (Bank sxemi)
-- ---------------------------------------------------------------------

-- Exercise 3.15(a)
-- "Brooklyn"-də yerləşən HƏR BİR filialda hesabı olan müştərilər.
-- ("Hər bir" -> bölmə / division: Brooklyn filialları çoxluğundan müştərinin
--  hesabı olan filialları çıxırıq; fərq boşdursa, müştəri hamısında hesaba malikdir.)
SELECT c.ID, c.customer_name
FROM customer c
WHERE NOT EXISTS (
        SELECT b.branch_name
        FROM branch b
        WHERE b.branch_city = 'Brooklyn'
      EXCEPT
        SELECT a.branch_name
        FROM depositor d
        JOIN account a ON a.account_number = d.account_number
        WHERE d.ID = c.ID
);

-- Exercise 3.15(b)
-- Bankdakı bütün kredit məbləğlərinin ümumi cəmi
SELECT SUM(amount) AS total_loan_amount
FROM loan;

-- Exercise 3.15(c)
-- "Brooklyn"-də yerləşən ən azı bir filialdan daha çox aktivi olan filialların adları
SELECT DISTINCT t.branch_name
FROM branch t
JOIN branch s ON t.assets > s.assets
WHERE s.branch_city = 'Brooklyn';


-- ---------------------------------------------------------------------
-- Exercise 3.24 (Universitet sxemi)
-- ---------------------------------------------------------------------

-- Exercise 3.24
-- Fizika departamentindəki müəllimin məsləhət verdiyi Mühasibatlıq tələbələrinin adı və ID-si
SELECT DISTINCT s.name, s.ID
FROM student s
JOIN advisor    a ON a.s_ID = s.ID
JOIN instructor i ON i.ID   = a.i_ID
WHERE s.dept_name = 'Accounting'
  AND i.dept_name = 'Physics';


-- ---------------------------------------------------------------------
-- Exercise 3.25 (Universitet sxemi)
-- ---------------------------------------------------------------------

-- Exercise 3.25
-- Büdcəsi Philosophy departamentinin büdcəsindən yüksək olan departamentlər (əlifba sırası ilə)
SELECT dept_name
FROM department
WHERE budget > (SELECT budget
                FROM department
                WHERE dept_name = 'Philosophy')
ORDER BY dept_name;
