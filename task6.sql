-- 6. Создать необходимые индексы (обосновать выбор столбцов)

-- Для авторизации
CREATE INDEX employee_credentials_idx ON employee (email, password_hash);

CREATE INDEX employer_credentials_idx ON employer (email, password_hash);

-- Для фильтрации вакансий соискателем, резюме работодателем
CREATE INDEX vacancy_specialization_idx ON vacancy (specialization_id);

CREATE INDEX resume_specialization_idx ON resume (specialization_id);
