-- 2. Заполнить базу данных тестовыми данными (порядка 10к вакансий и 100к резюме)

WITH area_random_data AS (
  SELECT
    substr(md5(random()::text), 1, 25) AS random_name
  FROM generate_series(1, 100)
)
INSERT INTO area(name)
SELECT
  random_name
FROM area_random_data;


WITH specialization_random_data AS (
  SELECT
    substr(md5(random()::text), 1, 25) AS random_name
  FROM generate_series(1, 1_000)
)
INSERT INTO specialization(name)
SELECT
    random_name
FROM specialization_random_data;


WITH employer_random_data AS (
  SELECT
    substr(md5(random()::text), 1, 25)  AS random_name,
    substr(md5(random()::text), 1, 25)  AS random_email,
    substr(md5(random()::text), 1, 64)  AS random_password_hash,
    (random() * 99)::INT + 1            AS random_area_id
  FROM GENERATE_SERIES(1, 10_000)
)
INSERT INTO employer(name, email, password_hash, area_id)
  SELECT
    random_name,
    concat(random_email, '@example.com'),
    random_password_hash,
    random_area_id
  FROM employer_random_data;


WITH employee_random_data AS (
  SELECT
    substr(md5(random()::text), 1, 25)  AS random_name,
    substr(md5(random()::text), 1, 25)  AS random_email,
    substr(md5(random()::text), 1, 64)  AS random_password_hash,
    (random() * 99)::INT + 1            AS random_area_id
  FROM GENERATE_SERIES(1, 100_000)
)
INSERT INTO employee(name, email, password_hash, area_id)
  SELECT
    random_name,
    concat(random_email, '@example.com'),
    random_password_hash,
    random_area_id
  FROM employee_random_data;


WITH vacancy_random_data AS (
  SELECT
    substr(md5(random()::text), 1, 25)                                                        AS random_title,
    md5(random()::text)                                                                       AS random_description,
    (random() < 0.5)                                                                          AS random_compensation_gross,
    round(13890 + (random() * 250_000)::INT, -3)                                              AS random_compensation_from,
    round((random() * 50_000)::INT, -3)                                                       AS random_compensation_delta,
    '2020-01-01 00:00:00'::timestamp + random() * (now() - '2020-01-01 00:00:00'::timestamp)  AS random_created_at,
    (random() * 9_999)::INT + 1                                                               AS random_employer_id,
    (random() * 999)::INT + 1                                                                 AS random_specialization_id
  FROM generate_series(1, 10_000)
)
INSERT INTO vacancy(title, description, compensation_from, compensation_to, compensation_gross, 
                    created_at, employer_id, specialization_id)
  SELECT
    random_title,
    random_description,
    random_compensation_from,
    random_compensation_from + random_compensation_delta,
    random_compensation_gross,
    random_created_at,
    random_employer_id,
    random_specialization_id
  FROM vacancy_random_data;


WITH resume_random_data AS (
  SELECT
    substr(md5(random()::text), 1, 25)                                                        AS random_title,
    md5(random()::text)                                                                       AS random_description,
    '2020-01-01 00:00:00'::timestamp + random() * (now() - '2020-01-01 00:00:00'::timestamp)  AS random_created_at,
    (random() * 9_999)::INT + 1                                                               AS random_employee_id,
    (random() * 999)::INT + 1                                                                 AS random_specialization_id
  FROM generate_series(1, 100_000)
)
INSERT INTO resume(title, description, created_at, employee_id, specialization_id)
SELECT
  random_title,
  random_description, 
  random_created_at,
  random_employee_id,
  random_specialization_id
FROM resume_random_data;


WITH response_random_data AS (
  SELECT DISTINCT ON (random_vacancy_id, random_resume_id)
    greatest(v.created_at, r.created_at) + random() * (now() - greatest(v.created_at, r.created_at))  AS random_created_at,
    v.id                                                                                              AS random_vacancy_id,
    r.id                                                                                              AS random_resume_id
  FROM 
    vacancy v 
  LEFT JOIN employer er
  ON
    er.id = v.employer_id
  INNER JOIN resume r
    LEFT JOIN employee ee
    ON
      ee.id = r.employee_id
  ON 
    v.specialization_id = r.specialization_id AND er.area_id = ee.area_id
  ORDER BY random_vacancy_id, random_resume_id, RANDOM()
  LIMIT 50_000
)
INSERT INTO response(created_at, vacancy_id, resume_id)
SELECT
  random_created_at,
  random_vacancy_id,
  random_resume_id
FROM response_random_data;
