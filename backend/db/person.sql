--=======================================================================================================================================================================================================================================================================--
-- Схема "Физическое лицо" (schema person) - ok
--=======================================================================================================================================================================================================================================================================--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- structure:
-- dictionary "d_person_gender" - справочник "Пол физического лица"
-- entity "e_persons" - сущность "Физическое лицо"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA person;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Пол физического лица' (dictionary person gender)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE person.d_person_gender (
  id CHAR(1),
  gender_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (gender_name),
    CHECK (id IN ('M','F'))
);
-- ok
COMMENT ON TABLE person.d_person_gender IS 'D Пол физического лица';
COMMENT ON COLUMN person.d_person_gender.id IS 'Идентификатор пола ФЛ';
COMMENT ON COLUMN person.d_person_gender.gender_name IS 'Наименование пола ФЛ';
-- Извлечь значения справочника 'Пол физического лица' - ok
SELECT id, gender_name AS "genderName" FROM person.d_person_gender ORDER BY id DESC;
-- Извлечь значение справоничка 'Пол физического лица' по идентификатору справочного значения - ok
SELECT id, gender_name AS "genderName" FROM person.d_person_gender WHERE id = {id};
-- Вставить справочное значение 'Мужской' - ok
INSERT INTO person.d_person_gender (id, gender_name) VALUES ('M', 'Мужской') RETURNING id;
-- Вставить справочное значение 'Женский' - ok
INSERT INTO person.d_person_gender (id, gender_name) VALUES ('F', 'Женский') RETURNING id;
-- Извлечь значение справоничка 'Пол физического лица' по идентификатору справочного значения 'F' - ok
SELECT id, gender_name AS "genderName" FROM person.d_person_gender WHERE id = 'F';
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Физическое лицо' (entity person) - ok
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE person.e_persons (
  id CHAR(12) NOT NULL, -- Необходимо реализовать проверку ИИН по маске на стороне бакэнда и фронтэнда (Внимание: ИИН представлен в формате VARCHAR)
  last_name VARCHAR(200) NOT NULL,
  first_name VARCHAR(200) NOT NULL,
  middle_name VARCHAR(300),
  dob DATE NOT NULL,
  gender_id CHAR(1) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (gender_id) REFERENCES person.d_person_gender(id)
);
-- ok
COMMENT ON TABLE person.e_persons IS 'E Физическое лицо';
COMMENT ON COLUMN person.e_persons.id IS 'ИИН ФЛ';
COMMENT ON COLUMN person.e_persons.last_name IS 'Фамилия ФЛ';
COMMENT ON COLUMN person.e_persons.first_name IS 'Имя ФЛ';
COMMENT ON COLUMN person.e_persons.middle_name IS 'Отчество ФЛ';
COMMENT ON COLUMN person.e_persons.dob IS 'Дата рождения ФЛ';
COMMENT ON COLUMN person.e_persons.gender_id IS 'Пол ФЛ';
COMMENT ON COLUMN person.e_persons.is_deleted IS 'Состояние записи';
-- Извлечь всех физических лиц - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM person.e_persons ORDER BY id ASC;
-- Извлечь физическое лицо по ИИН - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM person.e_persons WHERE id = {id};
-- Извлечь всех существующих физических лиц - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM person.e_persons WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующие физическое лицо по ИИН - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM person.e_persons WHERE is_deleted = 'N' AND id = {id};
-- Извлечь всех несуществующих физических лиц - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM person.e_persons WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующее физическое лицо по ИИН - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM person.e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Вставить физическое лицо - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ({id}, {lastName}, {firstName}, {middleName}, {dob}, {genderID}) RETURNING id;
-- Обновить физическое лицо по идентификатору физического лица - ok
UPDATE person.e_persons SET id = {id}, last_name = {lastName}, first_name = {firstName} middle_name = {middleName}, dob = {dob}, gender_id = {genderID} WHERE id = {id} RETURNING id;
-- Удалить (логически) физическое лицо по идентификатору физического лица - ok
UPDATE person.e_persons SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить (логически) удаленное физическое лицо по идентификатору физического лица - ok
UPDATE person.e_persons SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Вставить физическое лицо "Маусумбаев Тимур Владимирович" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('871215301496', 'Маусумбаев', 'Тимур', 'Владимирович', '1987-12-15', 'M') RETURNING id;
-- Втавить физическое лицо "Талапкызы Куралай" - ok
INSERT INTO person.e_persons (id, last_name, first_name, dob, gender_id) VALUES ('940909450852', 'Талапкызы', 'Куралай', '1994-09-09', 'F') RETURNING id;
-- Вставить физическое лицо "Ожанов Руслан Адиьевич" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('890402350620', 'Ожанов', 'Руслан', 'Адиьевич', '1989-04-02', 'M') RETURNING id;
-- Вставить физическое лицо "Кенченбаева Надия Рашитовна" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('630623401756', 'Кенченбаева', 'Надия', 'Рашитовна', '1963-06-23', 'F') RETURNING id;
-- Вставить физическое лицо "Касымов Руслан Толегенович" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('791002301669', 'Касымов', 'Руслан', 'Толегенович', '1979-10-02', 'M') RETURNING id;
-- Вставить физическое лицо "Абдикаримов Сакен Сагандыкович" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('771122350160', 'Абдикаримов', 'Сакен', 'Сагандыкович', '1977-11-22', 'M') RETURNING id;
-- Вставить физическое лицо "Шахпутов Ерболат Айтмухамедгалиевич" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('770415300233', 'Шахпутов', 'Ерболат', 'Айтмухамедгалиевич', '1977-04-15', 'M') RETURNING id;
-- Вставить физическое лицо "Адиетов Хайдар Кадимович" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('890710351355', 'Адиетов', 'Хайдар', 'Кадимович', '1989-07-10', 'M') RETURNING id;
-- Вставить физическое лицо "Менкибаев Султан Вячеславович" - ok
INSERT INTO person.e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ('920916350563', 'Менкибаев', 'Султан', 'Вячеславович', '1992-09-16', 'M') RETURNING id;
-- Извлечь физичекое лицо по идентификатору физического лица - '871215301496' - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM person.e_persons WHERE id = '871215301496';
-- Извлечь существующее физичекое лицо по идентификатору физического лица - '871215301496' - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM person.e_persons WHERE is_deleted = 'N' AND id = '871215301496';
-- Удалить физическое лицо по идентификатору физического лица - '871215301496' - ok
UPDATE person.e_persons SET is_deleted = 'Y' WHERE id = '871215301496' RETURNING id;
-- Извлечь несуществующих физических лиц - ok
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM person.e_persons WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Восстановить физическое лицо по идентификатору физического лица - '871215301496' - ok
UPDATE person.e_persons SET is_deleted = 'N' WHERE id = '871215301496' RETURNING id;
