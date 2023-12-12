-- 4. Написать запрос для получения месяца с наибольшим количеством вакансий
--    и месяца с наибольшим количеством резюме

SELECT
  month_number,
  vacancy_amount,
  resume_amount
FROM
  generate_series(1, 12) AS month_number
LEFT JOIN (
  SELECT
    extract(month FROM created_at) AS vacancy_month_number,
    count(*) AS vacancy_amount
  FROM
    vacancy
  GROUP BY vacancy_month_number
  ORDER BY vacancy_amount 
  LIMIT 1
) AS v ON vacancy_month_number = month_number
LEFT JOIN (
  SELECT
    extract(month FROM created_at) AS resume_month_number,
    count(*) AS resume_amount
  FROM
    resume
  GROUP BY resume_month_number
  ORDER BY resume_amount 
  LIMIT 1
) AS r ON resume_month_number = month_number
WHERE
  v.vacancy_amount IS NOT NULL OR r.resume_amount IS NOT NULL;
