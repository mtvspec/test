--=======================================================================================================================================================================================================================================================================--
-- General
--=======================================================================================================================================================================================================================================================================--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Физическое лицо' (entity person) # tested # created: work-dev, home-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE e_persons (
  id CHAR(12) NOT NULL, -- Необходимо реализовать проверку ИИН по маске на стороне бакэнда и фронтэнда (Внимание: ИИН представлен в формате VARCHAR)
  last_name VARCHAR(200) NOT NULL,
  first_name VARCHAR(200) NOT NULL,
  middle_name VARCHAR(300),
  dob DATE NOT NULL,
  gender_id CHAR(1) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (gender_id) REFERENCES dict.d_genders(id),
      CHECK (gender_id IN ('M','F')),
      CHECK (is_deleted IN ('N','Y'))
);
-- # tested # created: work-dev
COMMENT ON TABLE e_persons IS 'Сущность - Физическое лицо';
COMMENT ON COLUMN e_persons.id IS 'ИИН ФЛ';
COMMENT ON COLUMN e_persons.last_name IS 'Фамилия ФЛ';
COMMENT ON COLUMN e_persons.first_name IS 'Имя ФЛ';
COMMENT ON COLUMN e_persons.middle_name IS 'Отчество ФЛ';
COMMENT ON COLUMN e_persons.dob IS 'Дата рождения ФЛ';
COMMENT ON COLUMN e_persons.gender_id IS 'Пол ФЛ';
COMMENT ON COLUMN e_persons.is_deleted IS 'Пол ФЛ';
-- Извлечь всех физических лиц # tested
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM e_persons ORDER BY id ASC;
-- Извлечь физическое лицо по ИИН # tested
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM e_persons WHERE id = {id};
-- Извлечь всех существующих физических лиц # tested
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующие физическое лицо по ИИН # tested
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'N' AND id = {id};
-- Извлечь всех несуществующих физических лиц # tested
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующее физическое лицо по ИИН # tested
SELECT id, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Вставить физическое лицо
INSERT INTO e_persons (id, last_name, first_name, middle_name, dob, gender_id) VALUES ({id}, {lastName}, {firstName}, {middleName}, {dob}, {genderID}) RETURNING id;
-- Обновить физическое лицо по идентификатору физического лица
UPDATE e_persons SET id = {id}, last_name = {lastName}, first_name = {firstName} middle_name = {middleName}, dob = {dob}, gender_id = {genderID} WHERE id = {id} RETURNING id;
-- Удалить физическое лицо по идентификатору физического лица
UPDATE e_persons SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить физическое лицо по идентификатору физического лица
UPDATE e_persons SET is_deleted = 'N' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Физическое лицо' (log person) # tested # created: work-dev, home-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.e_persons (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id CHAR(6) NOT NULL,
    -- Физическое лицо
    iin CHAR(12) NOT NULL,
    last_name VARCHAR(300) NOT NULL,
    first_name VARCHAR(300) NOT NULL,
    middle_name VARCHAR(300),
    dob DATE NOT NULL,
    gender_id CHAR(1) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (session_id) REFERENCES meta.e_sessions(id),
      FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
      FOREIGN KEY (iin) REFERENCES e_persons(id),
      FOREIGN KEY (gender_id) REFERENCES dict.d_genders(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
      CHECK (gender_id IN ('M','F')),
      CHECK (is_deleted IN ('N','Y'))
);
-- # tested # created: work-dev
COMMENT ON TABLE log.e_persons IS 'Журнал - Физическое лицо';
COMMENT ON COLUMN log.e_persons.id IS 'Идентификатор записи журнала';
COMMENT ON COLUMN log.e_persons.session_id IS 'Идентификатор сессии';
COMMENT ON COLUMN log.e_persons.manipulation_date IS 'Дата изменения сущности';
COMMENT ON COLUMN log.e_persons.manipulation_type_id IS 'Идентификатор типа изменения сущности';
COMMENT ON COLUMN log.e_persons.iin IS 'ИИН ФЛ';
COMMENT ON COLUMN log.e_persons.last_name IS 'Фамилия ФЛ';
COMMENT ON COLUMN log.e_persons.first_name IS 'Имя ФЛ';
COMMENT ON COLUMN log.e_persons.middle_name IS 'Отчество ФЛ';
COMMENT ON COLUMN log.e_persons.dob IS 'Дата рождения ФЛ';
COMMENT ON COLUMN log.e_persons.gender_id IS 'Пол ФЛ';
COMMENT ON COLUMN log.e_persons.is_deleted IS 'Состояние записи';
-- Извлечь историю изменения сущности 'Физическое лицо' # tested
SELECT id, session_id AS "sessionID", manipulation_date AS "manipulationDate", manipulation_type_id AS "manipulationTypeID", iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", gender_id AS "genderID", is_deleted AS "isDeleted" FROM log.e_persons ORDER BY id ASC;
-- Вставить изменение в журнал истории изменения сущности 'Физическое лицо'
INSERT INTO log.e_persons (session_id, manipulation_type_id, iin, last_name, first_name, middle_name, gender_id, is_deleted) VALUES ({sessionID}, {manipulationTypeID}, {iin}, {lastName}, {firstName}, {middleName}, {genderID}, {isDeleted}) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал регистрации запросов сущности 'Физическое лицо' (log$ person) # tested
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log$.e_persons (
  id SERIAL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id CHAR(6) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (session_id) REFERENCES meta.e_sessions(id),
    FOREIGN KEY (manipulation_type_id) REFERENCES meta.manipulation_type(id)
);
-- Вставить запись в журнал
INSERT INTO log$.e_persons (session_id, manipulation_type_id) VALUES ({sessionID}, {manipulationTypeID}) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Юридическое лицо' (entity company) # tested
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE e_companies (
  id CHAR(12) NOT NULL, -- Необходимо реализовать проверку БИН по маске на стороне бакэнда и фронтэнда
  company_name VARCHAR(500) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (company_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
      CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE e_persons IS 'Сущность - Юридическое лицо';
COMMENT ON COLUMN e_persons.bin IS 'БИН ЮЛ';
COMMENT ON COLUMN e_persons.last_name IS 'Наименование ЮЛ';
COMMENT ON COLUMN log.e_persons.is_deleted IS 'Состояние записи';
-- Извлечь все юридические лица
SELECT id, company_name AS "companyName", is_deleted AS "isDeleted" FROM e_companies ORDER BY id ASC;
-- Извлечь юридическое лицо по БИН
SELECT id, company_name AS "companyName", is_deleted AS "isDeleted" FROM e_companies WHERE id = {id};
-- Извлечь все существующее юридические лица
SELECT id, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующее юридическое лицо по БИН
SELECT id, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все не существующие юридические лица
SELECT id, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь не существующее юридическое лицо по БИН
SELECT id, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'Y' AND id = {id};
-- Вставить юридическое лицо
INSERT INTO e_companies (id, company_name) VALUES ({id}, {companyName}) RETURNING id;
-- Обновить юридическое лицо
UPDATE e_companies SET id = {id}, company_name = {companyName} WHERE id = {id} RETURNING id;
-- Удалить юридическое лицо
UPDATE e_companies SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Юридическое лицо' (log company)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.e_companies (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id INTEGER NOT NULL,
    bin CHAR(12) NOT NULL,
    company_name VARCHAR(500) NOT NULL,
      is_deleted CHAR(1) NOT NULL DEFAULT 'N',
        PRIMARY KEY (id),
        FOREIGN KEY (session_id) REFERENCES meta.e_sessions(id),
        FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
        FOREIGN KEY (bin) REFERENCES e_companies(id),
        CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE log.e_companies IS 'Журнал - Юридическое лицо';
COMMENT ON COLUMN log.e_companies.bin IS 'БИН ЮЛ';
COMMENT ON COLUMN log.e_companies.bin IS 'БИН ЮЛ';
COMMENT ON COLUMN log.e_companies.last_name IS 'Наименование ЮЛ';
-- Извлечь все записи истории изменения сущности 'Юридическое лицо'
SELECT id, session_id AS "sessionID", manipulation_date AS "manipulationDate", manipulation_type_id AS "manipulationTypeID", bin, company_name AS "companyName", is_deleted AS 'isDeleted' FROM log.e_companies ORDER BY id ASC;
-- Вставить запись в журнал
INSERT INTO log.e_companies (session_id, manipulation_date, manipulation_type_id, bin, company_name) VALUES ({sessionID}, {manipulationDate}, {manipulationTypeID}, {bin}, {companyName}) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Должность физического лица' (entity position)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE e_positions (
  id SERIAL NOT NULL,
  position_name VARCHAR(500) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (position_name),
      CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE e_positions IS 'Сущность - Должность';
COMMENT ON COLUMN e_positions.id IS 'Идентификатор должности';
COMMENT ON COLUMN e_positions.position_name IS 'Наименование должности';
-- Извлечь все должности
SELECT id, position_name AS "positionName", is_deleted AS "isDeleted" FROM e_positions ORDER BY id ASC;
-- Извлечь должность по идентификатору должности
SELECT id, position_name AS "positionName", is_deleted AS "isDeleted" FROM e_positions WHERE id = {id};
-- Извлечь должность по наименованию должности
SELECT id FROM e_positions WHERE position_name = {positionName};
-- Извлечь все существующие должности
SELECT id, position_name AS "positionName" FROM e_positions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующую должность по идентификатору должности
SELECT id, position_name AS "positionName" FROM e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все несуществующие должности
SELECT id, position_name AS "positionName" FROM e_positions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующую должность по идентификатору должности
SELECT id, position_name AS "positionName" FROM e_positions WHERE is_deleted = 'Y' AND id = {id};
-- Вставить должность
INSERT INTO e_positions (position_name) VALUES ({positionName}) RETURNING id;
-- Обновить должность по идентификатору должности
UPDATE e_positions SET position_name = {positionName} WHERE id = {id};
-- Удалить должность по идентификатору должности
UPDATE e_positions SET is_deleted = 'Y' WHERE id = {id};
-- Восстановить должность по идентификатору должности
UPDATE e_positions SET is_deleted = 'N' WHERE id = {id};
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Должность ФЛ' (position log)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.e_positions (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id INTEGER NOT NULL,
    position_id INTEGER NOT NULL,
    position_name VARCHAR(500) NOT NULL,
      is_deleted CHAR(1) NOT NULL DEFAULT 'N',
        PRIMARY KEY (id),
        FOREIGN KEY (session_id) REFERENCES e_sessions(id),
        FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
        FOREIGN KEY (position_id) REFERENCES e_positions(id),
        CHECK (is_deleted IN ('N','Y'))
);
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Подразделение ЮЛ' (entity division)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE e_divisions (
  id SERIAL NOT NULL,
  parent_division_id INTEGER,
  division_name VARCHAR(400) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (division_name),
      FOREIGN KEY (parent_division_id) REFERENCES e_divisions(id),
      CHECK (is_deleted IN ('N', 'Y'))
);
COMMENT ON TABLE e_divisions IS 'Подразделение ЮЛ';
COMMENT ON COLUMN e_divisions.id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN e_divisions.parent_division_id IS 'Идентификатор родительского подразделения ЮЛ';
COMMENT ON COLUMN e_divisions.division_name IS 'Наименование подразделения ЮЛ';
COMMENT ON COLUMN e_divisions.is_deleted IS 'Признак удаления сущности';
-- Извлечь все подразделения ЮЛ
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName", is_deleted AS "isDeleted" FROM e_divisions ORDER BY id ASC;
-- Извлечь подразделение ЮЛ по идентификатору подразделения ЮЛ
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName", is_deleted AS "isDeleted" FROM e_divisions WHERE id = {id};
-- Вставить подразделение ЮЛ
INSERT INTO e_divisions (division_name) VALUES ({divisionName}) RETURNING id;
-- Вставить дочернее подразделение ЮЛ
INSERT INTO e_divisions (parent_division_id, division_name) VALUES ({parentDivisionID}, {divisionName}) RETURNING id;
-- Обновить подразделение ЮЛ
UPDATE e_divisions SET division_name = {divisionName} WHERE id = {id} RETURNING id;
-- Обновить дочернее подразделение ЮЛ
UPDATE e_divisions SET parent_division_id = {parentDivisionID}, division_name = {divisionName} RETURNING id;
-- Удалить подразделение ЮЛ
UPDATE e_divisions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Подразделение ЮЛ' (division log)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.e_divisions (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (session_id) REFERENCES e_sessions(id),
      FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
      FOREIGN KEY (division_id) REFERENCES e_divisions(id),
      CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE log.e_divisions IS 'Журнал - Подразделение ЮЛ';
COMMENT ON COLUMN log.e_divisions.id IS 'Идентификатор записи журнала';
COMMENT ON COLUMN log.e_divisions.session_id IS 'Идентификатор сессии';
COMMENT ON COLUMN log.e_divisions.manipulation_date IS 'Дата изменения сущности';
COMMENT ON COLUMN log.e_divisions.manipulation_type_id IS 'Идентификатор типа изменения сущности';
COMMENT ON COLUMN log.e_divisions.is_deleted IS 'Признак удаления сущности';
-- Связь 'Юридическое лицо - Подразделения ЮЛ' (relationship company - division)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE r_e_companies_e_divisions (
  id SERIAL NOT NULL,
  company_id CHAR(12) NOT NULL,
  division_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (company_id, division_id),
      UNIQUE (id),
      FOREIGN KEY (company_id) REFERENCES e_companies(bin),
      FOREIGN KEY (division_id) REFERENCES e_divisions(id),
      CHECK (is_deleted IN ('N', 'Y'))
);
COMMENT ON TABLE r_e_companies_e_divisions IS 'Связь - Юридическое лицо - Подразделение ЮЛ';
COMMENT ON COLUMN r_e_companies_e_divisions.id IS 'Идентификатор связи';
COMMENT ON COLUMN r_e_companies_e_divisions.company_id IS 'Идентификатор юридического лица';
COMMENT ON COLUMN r_e_companies_e_divisions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN r_e_companies_e_divisions.is_deleted IS 'Признак удаления сущности';
-- Извлечь все связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM r_e_companies_e_divisions ORDER BY id ASC;
-- Извлечь все связи 'Юридическое лицо - Подразделения' по идентификатору компании
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM r_e_companies_e_divisions WHERE company_id = {companyID} ORDER BY id ASC;
-- Извлечь существующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM r_e_companies_e_divisions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь несуществующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM r_e_companies_e_divisions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Вставить связь 'Юридическое лицо - Подразделение'
INSERT INTO r_e_companies_e_divisions (company_id, division_id) VALUES ({companyID}, {division_ID}) RETURNING id;
-- Обновить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE r_e_companies_e_divisions SET company_id = {companyID}, division_id = {divisionID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE r_e_companies_e_divisions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Подразделения ЮЛ - Должности ФЛ' (relationship division - position)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE r_e_divisions_e_positions (
  id SERIAL NOT NULL,
  division_id INTEGER NOT NULL,
  position_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (division_id, position_id),
      UNIQUE (id),
      FOREIGN KEY (division_id) REFERENCES e_divisions(id),
      FOREIGN KEY (position_id) REFERENCES e_positions(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
      CHECK (is_deleted IN ('N', 'Y'))
);
COMMENT ON TABLE r_e_divisions_e_positions IS 'Связь - Подразделение ЮЛ - Должность ФЛ';
COMMENT ON COLUMN r_e_divisions_e_positions.id IS 'Идентификатор связи';
COMMENT ON COLUMN r_e_divisions_e_positions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN r_e_divisions_e_positions.position_id IS 'Идентификатор должности ФЛ';
COMMENT ON COLUMN r_e_divisions_e_positions.is_deleted IS 'Признак удаления сущности';
-- Извлечь все связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM r_e_divisions_e_positions ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все несуществующие связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Подразделение ЮЛ - Должность' по индетификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM r_e_divisions_e_positions WHERE id = {id};
-- Извлечь существующую связь 'Подразделение ЮЛ - Должность ЮЛ' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Подразделение ЮЛ - Должность ЮЛ' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE id_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted = AS "isDeleted" FROM r_e_divisions_e_positions WHERE division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'N' AND division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'Y' AND division_id = {divisionID} ORDER BY id ASC;
-- Вставить связь 'Подразделение ЮЛ - Должность ФЛ'
INSERT INTO r_e_division_e_positions (division_id, position_id) VALUES ({divisionID}, {positionID}) RETURNING id;
-- Обновить связь 'Подразделение ЮЛ - Должность ФЛ' по идентификатору связи
UPDATE r_e_divisions_e_positions SET division_id = {divisionID}, position_id = {positionID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Подразделение ЮЛ - Должность ФЛ' по идентификатору связи
UPDATE r_e_divisions_e_positions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Должности - Физические лица' (relationship position - person)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE r_e_positions_e_persons (
  id SERIAL NOT NULL,
  position_id INTEGER NOT NULL,
  person_id CHAR(12) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (position_id, person_id),
      UNIQUE (id),
      FOREIGN KEY (position_id) REFERENCES e_positions(id),
      FOREIGN KEY (person_id) REFERENCES e_persons(iin),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
      CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE r_e_positions_e_persons IS 'Связь - Должность ФЛ - Физическое лицо';
COMMENT ON COLUMN r_e_positions_e_persons.id IS 'Идентификатор связи';
COMMENT ON COLUMN r_e_positions_e_persons.position_id IS 'Идентификатор должности ФЛ';
COMMENT ON COLUMN r_e_positions_e_persons.person_id IS 'Идентификатор физического лица';
COMMENT ON COLUMN r_e_positions_e_persons.is_deleted IS 'Признак удаления сущности';
-- Извлечь все связи 'Должности ФЛ - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM r_e_positions_e_persons ORDER BY id ASC;
-- Извлечь все существующие связи 'Должности ФЛ - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должности ФЛ - Физические лица' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM r_e_positions_e_persons WHERE id = {id};
-- Извлечь существующую связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM r_e_positions_e_persons WHERE position_id = {positionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'N' AND position_id = {positionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'Y' AND position_id = {positionID} ORDER BY id ASC;
-- Вставить связь 'Должность ФЛ - Физическое лицо'
INSERT INTO r_e_positions_e_persons (position_id, person_id) VALUES ({positionID}, {personID}) RETURNING id;
-- Обновить связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
UPDATE r_e_positions_e_persons SET position_id = {positionID}, person_id = {personID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Должность ФЛ - Физические лицо' по идентификатору связи
UPDATE r_e_positions_e_persons SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
--=======================================================================================================================================================================================================================================================================--
-- Справочники # tested # created: work-dev
--=======================================================================================================================================================================================================================================================================--
CREATE SCHEMA dict;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Пол физического лица (Мужской/Женский)' (dictionary gender) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dict.d_genders (
  id CHAR(1),
  gender_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (gender_name),
    CHECK (id IN ('M','F'))
);
-- # tested # created: work-dev
COMMENT ON TABLE dict.d_genders IS 'Справочник - Пол ФЛ';
COMMENT ON COLUMN dict.d_genders.id IS 'Идентификатор пола ФЛ';
COMMENT ON COLUMN dict.d_genders.gender_name IS 'Наименование пола ФЛ';
-- Извлечь значения справочника 'Пол физического лица' # tested # created: work-dev
SELECT id, gender_name AS "genderName" FROM dict.d_genders ORDER BY id DESC;
-- Извлечь значение справоничка 'Пол физического лица' по идентификатору значения справочника # tested # created: work-dev
SELECT id, gender_name AS "genderName" FROM dict.d_genders WHERE id = {id};
-- Вставить справочное значение 'Мужской' # tested # created: work-dev
INSERT INTO dict.d_genders (id, gender_name) VALUES ('M', 'Мужской') RETURNING id;
-- Вставить справочное значение 'Женский' # tested # created: work-dev
INSERT INTO dict.d_genders (id, gender_name) VALUES ('F', 'Женский') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Удален? (Нет/Да)' (dictionary is_deleted) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dict.is_deleted (
  id CHAR(1),
  condition_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (condition_name),
    CHECK (id IN ('N', 'Y'))
);
-- # tested # created: work-dev
COMMENT ON TABLE dict.is_deleted IS 'Справочник - Состояние записи';
COMMENT ON COLUMN dict.is_deleted.id IS 'Идентификатор состояния записи';
COMMENT ON COLUMN dict.is_deleted.condition_name IS 'Наименование состояния записи';
-- Извлечь значения справочника 'Удален (Нет/Да)' # tested
SELECT id, condition_name AS "conditionName" FROM dict.is_deleted ORDER BY id ASC;
-- Извлечь значение справочника 'Удален (Нет/Да)' по идентификатору значения справочника # tested
SELECT id, condition_name AS "conditionName" FROM dict.is_deleted WHERE id = {id};
-- Вставить справочное значение 'Нет' # tested # created: work-dev
INSERT INTO dict.is_deleted (id, condition_name) VALUES ('N', 'Нет') RETURNING id;
-- Вставить справочное значение 'Да' # tested # created: work-dev
INSERT INTO dict.is_deleted (id, condition_name) VALUES ('Y', 'Да') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Тип манипуляции над данными' (dictionary manipulation_type) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dict.manipulation_type (
  id CHAR(6) NOT NULL,
  manipulation_type_name VARCHAR(100) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (manipulation_type_name),
      CHECK (is_deleted IN ('N', 'Y'))
);
-- # tested # created: work-dev
COMMENT ON TABLE dict.manipulation_type IS 'Справочник - Состояние записи';
COMMENT ON COLUMN dict.manipulation_type.id IS 'Идентификатор состояния записи';
COMMENT ON COLUMN dict.manipulation_type.manipulation_type_name IS 'Наименование состояния записи';
COMMENT ON COLUMN dict.manipulation_type.is_deleted IS 'Признак удаления значения';
-- Вставить справочное значение 'SELECT' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('SELECT', 'SELECT');
-- Вставить справочное значение 'INSERT' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('INSERT', 'INSERT');
-- Вставить справочное значение 'UPDATE' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('UPDATE', 'UPDATE');
-- Вставить справочное значение 'DELETE' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('DELETE', 'DELETE');
--=======================================================================================================================================================================================================================================================================--
-- Метаданные # tested # created: work-dev
--=======================================================================================================================================================================================================================================================================--
CREATE SCHEMA meta;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Сессии' (entity session) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE meta.e_sessions (
  id SERIAL NOT NULL,
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  open_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  close_date TIMESTAMP WITH TIME ZONE,
  status CHAR(1) NOT NULL DEFAULT 'O',
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES meta.e_users(id),
    FOREIGN KEY (role_id) REFERENCES meta.e_roles(id),
    CHECK (status IN ('O','C'))
);
-- # tested # created: work-dev
COMMENT ON TABLE meta.e_sessions IS 'Сушность - Сессия';
COMMENT ON COLUMN meta.e_sessions.id IS 'Идентификатор сессии';
COMMENT ON COLUMN meta.e_sessions.user_id IS 'Идентификатор пользователя';
COMMENT ON COLUMN meta.e_sessions.role_id IS 'Идентификатор роли';
COMMENT ON COLUMN meta.e_sessions.open_date IS 'Дата и время открытия сессии';
COMMENT ON COLUMN meta.e_sessions.close_date IS 'Дата и время закрытия сессии';
COMMENT ON COLUMN meta.e_sessions.status IS 'Cтатус сессии';
-- Извлечь сессию по идентификатору сессии # tested # created: work-dev
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM meta.e_sessions WHERE id = {id};
-- Извлечь сессии по идентификатору пользователя # tested # created: work-dev
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM meta.e_sessions WHERE user_id = {userID};
-- Вставить сессию # tested # created: work-dev
INSERT INTO meta.e_sessions (user_id, role_id) VALUES ({userID}, {roleID}) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Пользователи' (entity user) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE meta.e_users (
  id SERIAL NOT NULL,
  person_id CHAR(12) NOT NULL,
  u_username VARCHAR(20) NOT NULL,
  u_password VARCHAR(4000) NOT NULL,
    is_blocked CHAR(1) NOT NULL DEFAULT 'N',
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (u_username, u_password),
      UNIQUE (id),
      FOREIGN KEY (person_id) REFERENCES e_persons(id),
      CHECK (is_blocked IN ('N', 'Y')),
      CHECK (is_deleted IN ('N', 'Y'))
);
-- # tested # created: work-dev
COMMENT ON TABLE meta.e_users IS 'Сушность - Пользователь';
COMMENT ON COLUMN meta.e_users.id IS 'Идентификатор учетной записи';
COMMENT ON COLUMN meta.e_users.person_id IS 'Идентификатор физического лица';
COMMENT ON COLUMN meta.e_users.u_username IS 'Имя пользователя';
COMMENT ON COLUMN meta.e_users.u_password IS 'Пароль пользователя';
COMMENT ON COLUMN meta.e_users.is_blocked IS 'Признак блокирования учетной записи';
COMMENT ON COLUMN meta.e_users.is_deleted IS 'Признак удаления записи';
-- Извлечь пользователя (физическое лицо) по имени пользователя # tested
SELECT id, person_id AS "personID", u_username AS "username", is_blocked AS "isBlocked",  is_deleted AS "isDeleted" FROM meta.e_users WHERE u_username = {username};
-- Вставить пользователя # tested # created: work-dev
INSERT INTO meta.e_users (person_id, u_username, u_password) VALUES ({personID}, {username}, {password}) RETURNING id;
-- Изменить пароль пользователя по идентификатору пользователя
UPDATE meta.e_users SET u_password = {password} WHERE id = {id} RETURNING id;
-- Удалить пользователя по идентификатору пользователя # tested
UPDATE meta.e_users SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить пользователя по идентификатору пользователя # tested
UPDATE meta.e_users SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Заблокировать пользователя по идентификатору пользователя # tested
UPDATE meta.e_users SET is_blocked = 'Y' WHERE id = {id} RETURNING id;
-- Разблокировать пользователя по идентификатору пользователя # tested
UPDATE meta.e_users SET is_blocked = 'N' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Роли' (entity role) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE meta.e_roles (
  id SERIAL NOT NULL,
  role_name VARCHAR(200) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (role_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
      CHECK (is_deleted IN ('N', 'Y'))
);
-- # tested
COMMENT ON TABLE meta.e_roles IS 'Сущность - Роль пользователя';
COMMENT ON COLUMN meta.e_roles.id IS 'Идентификатор роли пользователя';
COMMENT ON COLUMN meta.e_roles.role_name IS 'Наименование роли пользователя';
COMMENT ON COLUMN meta.e_users.is_deleted IS 'Признак удаления записи';
-- Извлечь все роли # tested
SELECT id, role_name AS "roleName", is_deleted AS "isDeleted" FROM meta.e_roles ORDER BY id ASC;
-- Извлечь существующие роли # tested
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующие роли # tested
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь роль # tested
SELECT id, role_name AS "roleName", is_deleted AS "isDeleted" FROM meta.e_roles  WHERE id = {id};
-- Извлечь существующую роль # tested
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'N' id = {id};
-- Извлечь несуществующую роль # tested
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'Y' id = {id};
-- Вставить роль # tested # created: work-dev
INSERT INTO meta.e_roles (role_name) VALUES ({roleName}) RETURNING id;
-- Обновить роль по идентификатору роли # tested # created: work-dev
UPDATE meta.e_roles SET role_name = {roleName} WHERE id = {id} RETURNING id;
-- Удалить роль по идентификатору роли # tested
UPDATE meta.e_roles SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить роль по идентификатору роли # tested
UPDATE meta.e_roles SET is_deleted = 'N' WHERE id = {id} RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Роли - Пользователи' (relationship role - user)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE meta.r_e_roles_e_users (
  id SERIAL NOT NULL,
  role_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (role_id, user_id),
      UNIQUE (id)
      FOREIGN KEY (role_id) REFERENCES meta.e_roles(id),
      FOREIGN KEY (user_id) REFERENCES meta.e_users(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
      CHECK (is_deleted IN ('N', 'Y'))
);
-- Извлечь все связи 'Роли - Пользователи'
SELECT id, role_id AS "roleID", user_id AS "userID" FROM meta.r_e_roles_e_users ORDER BY id ASC;
-- Вставить связь 'Роли - Пользователи'
INSERT INTO meta.r_e_roles_e_users (role_id, user_id) VALUES ({roleID}, {userID}) RETURNING id;
-- Обновить связь 'Роль - Пользователь' по идентификатору связи
UPDATE meta.r_e_roles_e_users SET role_id = {roleID}, user_id = {userID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Роль - Пользователь' по идентификатору связи
UPDATE meta.r_e_roles_e_users SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
--=======================================================================================================================================================================================================================================================================--
