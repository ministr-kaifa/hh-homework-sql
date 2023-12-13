-- 4. Написать запрос для получения месяца с наибольшим количеством вакансий
--    и месяца с наибольшим количеством резюме

SELECT
  COALESCE(v.year, r.year) AS year,
  COALESCE(v.month_number, r.month_number) AS month_number,
  COALESCE(v.vacancy_amount, NULL) AS vac_amount,
  COALESCE(r.resume_amount, NULL) AS res_amount
FROM (
  SELECT
    extract(month FROM created_at)  AS month_number,
    extract(year  FROM created_at)  AS year,
    count(*)                        AS vacancy_amount
  FROM
    vacancy
  GROUP BY year, month_number
  ORDER BY vacancy_amount
  LIMIT 1
) AS v 
FULL JOIN (
  SELECT
    extract(month FROM created_at)  AS month_number,
    extract(year  FROM created_at)  AS year,
    count(*)                        AS resume_amount
  FROM
    resume
  GROUP BY year, month_number
  ORDER BY resume_amount
  LIMIT 1
) AS r ON r.month_number = v.month_number AND v.year = r.year
WHERE
  v.vacancy_amount IS NOT NULL OR r.resume_amount IS NOT NULL;
