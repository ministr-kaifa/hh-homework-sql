-- 3. Написать запрос для получения средних значений по регионам (area_id) следующих величин:
--    compensation_from, compensation_to, среднее_арифметическое_from_и_to

SELECT
  e.area_name,
  avg(v.compensation_from)                                AS avg_compensation_from,
  avg(v.compensation_to)                                  AS avg_compensation_to,
  avg(v.compensation_from) + avg(v.compensation_to) / 2.0 AS avg_compensation
FROM (
  SELECT
    CASE
      WHEN compensation_gross IS TRUE
        THEN compensation_to * 0.87
      ELSE compensation_to
      END AS compensation_to,
    CASE
      WHEN compensation_gross IS TRUE
        THEN compensation_from * 0.87
      ELSE compensation_from
      END AS compensation_from,
    employer_id
  FROM
    vacancy
) v
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


