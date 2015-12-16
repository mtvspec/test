---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Пол физического лица' (dictionary person gender)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE persons.d_genders (
  id CHAR(1),
  gender_name VARCHAR(10) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (gender_name)
);
-- ok
COMMENT ON TABLE persons.d_person_gender IS 'D Пол физического лица';
COMMENT ON COLUMN persons.d_person_gender.id IS 'Идентификатор пола ФЛ';
COMMENT ON COLUMN persons.d_person_gender.gender_name IS 'Наименование пола ФЛ';
-- Извлечь значения справочника 'Пол физического лица' - ok
SELECT id, gender_name AS "genderName" FROM persons.d_person_gender ORDER BY id DESC;
-- Извлечь значение справоничка 'Пол физического лица' по идентификатору справочного значения - ok
SELECT id, gender_name AS "genderName" FROM persons.d_person_gender WHERE id = {id};
-- Вставить справочное значение 'Мужской' - ok
INSERT INTO persons.d_person_gender (id, gender_name) VALUES ('M', 'Мужской') RETURNING id;
-- Вставить справочное значение 'Женский' - ok
INSERT INTO persons.d_person_gender (id, gender_name) VALUES ('F', 'Женский') RETURNING id;
-- Извлечь значение справоничка 'Пол физического лица' по идентификатору справочного значения 'F' - ok
SELECT id, gender_name AS "genderName" FROM persons.d_person_gender WHERE id = 'F';
