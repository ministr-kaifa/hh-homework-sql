-- 1. Спроектировать базу данных hh (основные таблицы: вакансии, резюме, отклики, специализации).
--    По необходимым столбцам ориентироваться на сайт hh.ru

DROP TABLE IF EXISTS area CASCADE;
CREATE TABLE area (
  id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL
);


DROP TABLE IF EXISTS specialization CASCADE;
CREATE TABLE specialization (
  id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL
);


DROP TABLE IF EXISTS employer CASCADE;
CREATE TABLE employer (
  id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name          VARCHAR(200) NOT NULL,
  email         VARCHAR(200) NOT NULL UNIQUE CHECK (email LIKE '%_@__%.__%'),
  password_hash TEXT NOT NULL,
  area_id       INT NOT NULL REFERENCES area(id) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS employee CASCADE;
CREATE TABLE employee (
  id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name          VARCHAR(200) NOT NULL,
  email         VARCHAR(200) NOT NULL UNIQUE CHECK (email LIKE '%_@__%.__%'),
  password_hash TEXT NOT NULL,
  area_id       INT NOT NULL REFERENCES area(id) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS vacancy CASCADE;
CREATE TABLE vacancy (
  id                  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title               VARCHAR(200),
  description         TEXT,
  compensation_from   INT,
  compensation_to     INT,
  compensation_gross  BOOL,
  created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  employer_id         INT NOT NULL REFERENCES employer(id) ON DELETE CASCADE ON UPDATE CASCADE,
  specialization_id   INT NOT NULL REFERENCES specialization(id) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS resume CASCADE;
CREATE TABLE resume (
  id                INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title             VARCHAR(200) NOT NULL,
  description       TEXT,
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  employee_id       INT NOT NULL REFERENCES employee (id) ON DELETE CASCADE ON UPDATE CASCADE,
  specialization_id INT NOT NULL REFERENCES specialization (id) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS response CASCADE;
CREATE TABLE response (
  id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  vacancy_id  INTEGER NOT NULL REFERENCES vacancy (id) ON DELETE CASCADE ON UPDATE CASCADE,
  resume_id   INTEGER NOT NULL REFERENCES resume (id) ON DELETE CASCADE ON UPDATE CASCADE
);
