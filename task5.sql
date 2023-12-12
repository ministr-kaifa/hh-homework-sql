-- 5. Написать запрос для получения id и title вакансий, 
--    которые собрали больше 5 откликов в первую неделю после публикации

SELECT 
  v.id, 
  v.title
FROM
  vacancy v
JOIN response r
ON v.id = r.vacancy_id
WHERE r.created_at <= v.created_at + INTERVAL '1 week'
GROUP BY v.id, v.title
HAVING 5 < count(*);
