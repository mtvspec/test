--=======================================================================================================================================================================================================================================================================--
-- Схема "Юридическое лицо" (schema company) - ok
--=======================================================================================================================================================================================================================================================================--
-- TODO Необходимо реализовать проверку БИН по маске на стороне бакэнда и фронтэнда
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- structure:
-- schema         "company"                                 - схема "Юридическое лицо"
-- entity         "e_companies"                             - сущность "Юридическое лицо"
-- entity         "e_divisions"                             - сущность "Подразделение юридического лица"
-- relationship   "r_e_companies_e_divisions"               - связь "Юридическое лицо - Подразделения юридического лица"
-- entity         "e_positions"                             - сущность "Должность физического лица"
-- relationship   "r_e_divisions_e_positions"               - связь "Подразделение юридического лица - Должности физического лица"
-- relationship   "r_e_positions_e_persons"                 - связь "Должность физического лица - Физические лица"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- dependencies:
-- schema "dict":
-- dictionary "is_deleted"
-- schema "person":
-- entity "e_persons"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA company;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Атрибут "Наименование юридического лица" - ok
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE company.a_companies_names (
  id SERIAL,
  short_name VARCHAR(100) NOT NULL,
  long_name VARCHAR(300),
  full_name VARCHAR(500),
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (short_name, long_name, full_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE company.a_companies_names IS 'А Наименование юридического лица';
COMMENT ON COLUMN company.a_companies_names.id IS 'Идентификатор наименования ЮЛ';
COMMENT ON COLUMN company.a_companies_names.short_name IS 'Короткое наименование ЮЛ';
COMMENT ON COLUMN company.a_companies_names.long_name IS 'Наименование ЮЛ';
COMMENT ON COLUMN company.a_companies_names.full_name IS 'Юридическое наименование ЮЛ';
COMMENT ON COLUMN company.a_companies_names.is_deleted IS 'Состояние записи';
-- Вставить наименование юридического лицо "Казипэкс" - 'Kazimpex', 'АО "РЦ "Казипэкс"', 'Акционерное общество "Республиканский центр "Казимпэкс"' - ok
INSERT INTO company.a_companies_names (short_name, long_name, full_name) VALUES ('Kazimpex', 'АО "РЦ "Казипэкс"', 'Акционерное общество "Республиканский центр "Казимпэкс"') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Юридическое лицо' (entity company) - ok
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE company.e_companies (
  id CHAR(12) NOT NULL,
  short_name VARCHAR(100) NOT NULL,
  long_name VARCHAR(300),
  full_name VARCHAR(500),
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE company.e_companies IS 'E Юридическое лицо';
COMMENT ON COLUMN company.e_companies.id IS 'БИН ЮЛ';
-- Извлечь все юридические лица - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName", is_deleted AS "isDeleted" FROM company.e_companies ORDER BY id ASC;
-- Извлечь юридическое лицо по БИН - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName", is_deleted AS "isDeleted" FROM company.e_companies WHERE id = {id};
-- Извлечь существующие юридические лица - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM company.e_companies WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующее юридическое лицо по БИН - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM company.e_companies WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все не существующие юридические лица - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM company.e_companies WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь не существующее юридическое лицо по БИН -
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM company.e_companies WHERE is_deleted = 'Y' AND id = {id};
-- Вставить юридическое лицо - ok
INSERT INTO company.e_companies (id, short_name, long_name, full_name) VALUES ({id}, {shortName}, {longName}, {fullName}) RETURNING id;
-- Обновить юридическое лицо - ok
UPDATE company.e_companies SET id = {id}, short_name = {shortName}, {long_name} = {longName}, full_name = {fullName} WHERE id = {id} RETURNING id;
-- Удалить юридическое лицо - ok
UPDATE company.e_companies SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить удаленное юридическое лицо - ok
UPDATE company.e_companies SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Вставить юридическое лицо "Казипэкс" - ok
INSERT INTO company.e_companies (id, short_name, long_name, full_name) VALUES ('871215301100', 'Казимпэкс', 'АО "РЦ "Казимпэкс"', 'Акционерное общество "Республиканский центр "Казимпэкс"') RETURNING id;
-- Вставить юридическое лицо "АТЦ" - ok
INSERT INTO company.e_companies (id, short_name, long_name, full_name) VALUES ('871215301101', 'АТЦ', 'Штаб АТЦ КНБ РК', 'Штаб Антитеррористического центра Комитета транспортного контроля Республики Казахстан') RETURNING id;
-- Вставить юридическое лицо "КГД" - ok
INSERT INTO company.e_companies (id, short_name, long_name, full_name) VALUES ('871215301102', 'КГД', 'КГД МФ РК', 'Комитет государственных доходов Министерства финансов Республики Казахстан') RETURNING id;
-- Извлечь юридическое лицо по БИН - '871215301100' - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName", is_deleted AS "isDeleted" FROM company.e_companies WHERE id = '871215301100';
-- Извлечь существующее юридическое лицо по БИН - '871215301100' - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM company.e_companies WHERE is_deleted = 'N' AND id = '871215301100';
-- Извлечь не существующее юридическое лицо по БИН - '871215301100' - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM company.e_companies WHERE is_deleted = 'Y' AND id = '871215301100';
-- Обновить юридическое лицо - '871215301100' - ok
UPDATE company.e_companies SET id = '871215301100', short_name = 'Казимпэкс', long_name = 'АО "РЦ "Казимпэкс"', full_name = 'Акционерное общество "Республиканский центр "Казимпэкс"' WHERE id = '871215301100' RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Подразделение ЮЛ' (entity division)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE company.e_divisions (
  id SERIAL NOT NULL,
  division_name VARCHAR(400) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (division_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE company.e_divisions IS 'E Подразделение юридического лица';
COMMENT ON COLUMN company.e_divisions.id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN company.e_divisions.parent_division_id IS 'Идентификатор родительского подразделения ЮЛ';
COMMENT ON COLUMN company.e_divisions.division_name IS 'Наименование подразделения ЮЛ';
COMMENT ON COLUMN company.e_divisions.is_deleted IS 'Состояние записи';
-- Извлечь все сущности "Подразделение ЮЛ"
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName", is_deleted AS "isDeleted" FROM company.e_divisions ORDER BY id ASC;
-- Извлечь сущность "Подразделение ЮЛ" по идентификатору сущности
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName", is_deleted AS "isDeleted" FROM company.e_divisions WHERE id = {id};
-- Извлечь существующие сущности "Подразделение ЮЛ"
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName" FROM company.e_divisions WHERE is_deleted = "N" ORDER BY id ASC;
-- Извлечь существующую сущность "Подразделение ЮЛ"
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName" FROM company.e_divisions WHERE is_deleted = "N" AND id = {id};
-- Вставить сущность "Подразделение ЮЛ"
INSERT INTO company.e_divisions (division_name) VALUES ({divisionName}) RETURNING id;
-- Вставить сущность "(дочернее) Подразделение ЮЛ"
INSERT INTO company.e_divisions (parent_division_id, division_name) VALUES ({parentDivisionID}, {divisionName}) RETURNING id;
-- Обновить сущность "Подразделение ЮЛ" по идентификатору сущности
UPDATE company.e_divisions SET division_name = {divisionName} WHERE id = {id} RETURNING id;
-- Обновить сущность "(дочернее) Подразделение ЮЛ" по идентификатору сущности
UPDATE company.e_divisions SET parent_division_id = {parentDivisionID}, division_name = {divisionName} RETURNING id;
-- Удалить сущность "Подразделение ЮЛ" по идентификатору сущности
UPDATE company.e_divisions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Вставить подразделение "Департамент информационных технологий"
INSERT INTO company.e_divisions (division_name) VALUES ('Департамент информационных технологий') RETURNING id;
-- Вставить подразделение "Отдел разработки"
INSERT INTO company.e_divisions (division_name) VALUES ('Отдел разработки') RETURNING id;
-- Вставить подразделение "Отдел консалтинга"
INSERT INTO company.e_divisions (division_name) VALUES ('Отдел консалтинга') RETURNING id;
-- Вставить подразделение "Отдел администрирования и сетевых технологий"
INSERT INTO company.e_divisions (division_name) VALUES ('Отдел администрирования и сетевых технологий') RETURNING id;
-- Вставить подразделение "Отдел мобильных приложений"
INSERT INTO company.e_divisions (division_name) VALUES ('Отдел мобильных приложений') RETURNING id;
-- Вставить подразделение "Отдел управления проектами"
INSERT INTO company.e_divisions (division_name) VALUES ('Отдел управления проектами') RETURNING id;
-- Вставить подразделение "Отдел сетевых технологий"
INSERT INTO company.e_divisions (division_name) VALUES ('Отдел сетевых технологий') RETURNING id;
-- Вставить подразделение "Отдел систем защиты"
INSERT INTO company.e_divisions (division_name) VALUES ('Отдел систем защиты') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Юридическое лицо - Подразделения ЮЛ' (relationship company - division)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE company.r_e_companies_e_divisions (
  id SERIAL NOT NULL,
  company_id CHAR(12) NOT NULL,
  division_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (company_id, division_id),
      UNIQUE (id),
      FOREIGN KEY (company_id) REFERENCES company.e_companies(bin),
      FOREIGN KEY (division_id) REFERENCES company.e_divisions(id)
);
COMMENT ON TABLE company.r_e_companies_e_divisions IS 'R Юридическое лицо - Подразделение ЮЛ';
COMMENT ON COLUMN company.r_e_companies_e_divisions.id IS 'Идентификатор связи';
COMMENT ON COLUMN company.r_e_companies_e_divisions.company_id IS 'Идентификатор юридического лица';
COMMENT ON COLUMN company.r_e_companies_e_divisions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN company.r_e_companies_e_divisions.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM company.r_e_companies_e_divisions ORDER BY id ASC;
-- Извлечь все связи 'Юридическое лицо - Подразделения' по идентификатору компании
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM company.r_e_companies_e_divisions WHERE company_id = {companyID} ORDER BY id ASC;
-- Извлечь существующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM company.r_e_companies_e_divisions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь несуществующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM company.r_e_companies_e_divisions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Вставить связь 'Юридическое лицо - Подразделение'
INSERT INTO company.r_e_companies_e_divisions (company_id, division_id) VALUES ({companyID}, {division_ID}) RETURNING id;
-- Обновить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE company.r_e_companies_e_divisions SET company_id = {companyID}, division_id = {divisionID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE company.r_e_companies_e_divisions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Должность физического лица' (entity person position)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE company.e_positions (
  id SERIAL,
  position_name VARCHAR(500) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (position_name),
      CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE company.e_positions IS 'E Должность физического лица';
COMMENT ON COLUMN company.e_positions.id IS 'Идентификатор должности';
COMMENT ON COLUMN company.e_positions.position_name IS 'Наименование должности';
COMMENT ON COLUMN company.e_positions.is_deleted IS 'Состояние записи';
-- Извлечь все должности
SELECT id, position_name AS "positionName", is_deleted AS "isDeleted" FROM company.e_positions ORDER BY id ASC;
-- Извлечь должность по идентификатору должности
SELECT id, position_name AS "positionName", is_deleted AS "isDeleted" FROM company.e_positions WHERE id = {id};
-- Извлечь все существующие должности
SELECT id, position_name AS "positionName" FROM company.e_positions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующую должность по идентификатору должности
SELECT id, position_name AS "positionName" FROM company.e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все несуществующие должности
SELECT id, position_name AS "positionName" FROM company.e_positions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующую должность по идентификатору должности
SELECT id, position_name AS "positionName" FROM company.e_positions WHERE is_deleted = 'Y' AND id = {id};
-- Вставить должность
INSERT INTO company.e_positions (position_name) VALUES ({positionName}) RETURNING id;
-- Обновить должность по идентификатору должности
UPDATE company.e_positions SET position_name = {positionName} WHERE id = {id};
-- Удалить должность по идентификатору должности
UPDATE company.e_positions SET is_deleted = 'Y' WHERE id = {id};
-- Восстановить должность по идентификатору должности
UPDATE company.e_positions SET is_deleted = 'N' WHERE id = {id};
-- Вставить должность "Менеджер 1-ой категории"
INSERT INTO company.e_positions (position_name) VALUES ('Менеджер 1-ой категории') RETURNING id;
-- Вставить должность "Менеджер 2-ой категории"
INSERT INTO company.e_positions (position_name) VALUES ('Менеджер 2-ой категории') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Подразделение юридического лица - Должности физического лица' (relationship division - position)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE company.r_e_divisions_e_positions (
  id SERIAL NOT NULL,
  division_id INTEGER NOT NULL,
  position_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (division_id, position_id),
      UNIQUE (id),
      FOREIGN KEY (division_id) REFERENCES company.e_divisions(id),
      FOREIGN KEY (position_id) REFERENCES company.e_positions(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE company.r_e_divisions_e_positions IS 'R Подразделение ЮЛ - Должность ФЛ';
COMMENT ON COLUMN company.r_e_divisions_e_positions.id IS 'Идентификатор связи';
COMMENT ON COLUMN company.r_e_divisions_e_positions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN company.r_e_divisions_e_positions.position_id IS 'Идентификатор должности ФЛ';
COMMENT ON COLUMN company.r_e_divisions_e_positions.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM company.r_e_divisions_e_positions ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM company.r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все несуществующие связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM company.r_e_divisions_e_positions WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Подразделение ЮЛ - Должность' по индетификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM company.r_e_divisions_e_positions WHERE id = {id};
-- Извлечь существующую связь 'Подразделение ЮЛ - Должность ЮЛ' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM company.r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Подразделение ЮЛ - Должность ЮЛ' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM company.r_e_divisions_e_positions WHERE id_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted = AS "isDeleted" FROM company.r_e_divisions_e_positions WHERE division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM company.r_e_divisions_e_positions WHERE is_deleted = 'N' AND division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM company.r_e_divisions_e_positions WHERE is_deleted = 'Y' AND division_id = {divisionID} ORDER BY id ASC;
-- Вставить связь 'Подразделение ЮЛ - Должность ФЛ'
INSERT INTO company.r_e_divisions_e_positions (division_id, position_id) VALUES ({divisionID}, {positionID}) RETURNING id;
-- Обновить связь 'Подразделение ЮЛ - Должность ФЛ' по идентификатору связи
UPDATE company.r_e_divisions_e_positions SET division_id = {divisionID}, position_id = {positionID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Подразделение ЮЛ - Должность ФЛ' по идентификатору связи
UPDATE company.r_e_divisions_e_positions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Должность физического лица - Физические лица' (relationship position - person)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE company.r_e_positions_e_persons (
  id SERIAL NOT NULL,
  position_id INTEGER NOT NULL,
  person_id CHAR(12) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (position_id, person_id),
      UNIQUE (id),
      FOREIGN KEY (position_id) REFERENCES company.e_positions(id),
      FOREIGN KEY (person_id) REFERENCES person.e_persons(iin),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE company.r_e_positions_e_persons IS 'R Должность ФЛ - Физическое лицо';
COMMENT ON COLUMN company.r_e_positions_e_persons.id IS 'Идентификатор связи';
COMMENT ON COLUMN company.r_e_positions_e_persons.position_id IS 'Идентификатор должности ФЛ';
COMMENT ON COLUMN company.r_e_positions_e_persons.person_id IS 'Идентификатор физического лица';
COMMENT ON COLUMN company.r_e_positions_e_persons.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Должности ФЛ - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM company.r_e_positions_e_persons ORDER BY id ASC;
-- Извлечь все существующие связи 'Должности ФЛ - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID" FROM company.r_e_positions_e_persons WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должности ФЛ - Физические лица' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM company.r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM company.r_e_positions_e_persons WHERE id = {id};
-- Извлечь существующую связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM company.r_e_positions_e_persons WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM company.r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM company.r_e_positions_e_persons WHERE position_id = {positionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM company.r_e_positions_e_persons WHERE is_deleted = 'N' AND position_id = {positionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM company.r_e_positions_e_persons WHERE is_deleted = 'Y' AND position_id = {positionID} ORDER BY id ASC;
-- Вставить связь 'Должность ФЛ - Физическое лицо'
INSERT INTO company.r_e_positions_e_persons (position_id, person_id) VALUES ({positionID}, {personID}) RETURNING id;
-- Обновить связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
UPDATE company.r_e_positions_e_persons SET position_id = {positionID}, person_id = {personID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Должность ФЛ - Физические лицо' по идентификатору связи
UPDATE company.r_e_positions_e_persons SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
