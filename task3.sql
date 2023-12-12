-- 3. Написать запрос для получения средних значений по регионам (area_id) следующих величин:
--    compensation_from, compensation_to, среднее_арифметическое_from_и_to

SELECT
  e.area_name,
  avg(v.compensation_from)                                AS avg_compensation_from,
  avg(v.compensation_to)                                  AS avg_compensation_to,
  avg(v.compensation_from) + avg(v.compensation_to) / 2.0 AS avg_compensation
FROM
  vacancy v
LEFT JOIN (
  SELECT
    e.id      AS employer_id,
    e.area_id AS area_id,
    area.name AS area_name
  FROM
    employer e
  LEFT JOIN
    area
  ON
    area.id = e.area_id
) e
ON
  e.employer_id = v.employer_id
GROUP BY e.area_id, e.area_name;
