--=======================================================================================================================================================================================================================================================================--
-- Журналирование изменений
--=======================================================================================================================================================================================================================================================================--
CREATE SCHEMA log;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Юридическое лицо' (log company)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.ul_e_companies (
  id SERIAL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id INTEGER NOT NULL,
    company_id CHAR(12) NOT NULL,
    short_name VARCHAR(100) NOT NULL,
    long_name VARCHAR(300),
    full_name VARCHAR(500),
      is_deleted CHAR(1) NOT NULL DEFAULT 'N',
        PRIMARY KEY (id),
        FOREIGN KEY (session_id) REFERENCES meta.e_sessions(id),
        FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
        FOREIGN KEY (company_id) REFERENCES ul.e_companies(id),
        CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE log.e_companies IS 'Журнал - Юридическое лицо';
COMMENT ON COLUMN log.e_companies.id IS 'Идентификатор записи журнала';
COMMENT ON COLUMN log.e_companies.session_id IS 'Идентификатор сессии';
COMMENT ON COLUMN log.e_companies.manipulation_date IS 'Дата изменения сущности';
COMMENT ON COLUMN log.e_companies.manipulation_type_id IS 'Идентификатор типа изменения сущности';
COMMENT ON COLUMN log.e_companies.company_id IS 'БИН ЮЛ';
COMMENT ON COLUMN log.e_companies.short_name IS 'Короткое наименование ЮЛ';
COMMENT ON COLUMN log.e_companies.long_name IS 'Наименование ЮЛ';
COMMENT ON COLUMN log.e_companies.full_name IS 'Юридическое наименование ЮЛ';
COMMENT ON COLUMN log.e_companies.is_deleted IS 'Состояние записи';
-- Извлечь все записи истории изменения сущности 'Юридическое лицо'
SELECT id, session_id AS "sessionID", manipulation_date AS "manipulationDate", manipulation_type_id AS "manipulationTypeID", company_id AS "companyID", short_name AS "shortName", long_name AS "longName", full_name AS "fullName", is_deleted AS 'isDeleted' FROM log.e_companies ORDER BY id ASC;
-- Вставить запись в журнал
INSERT INTO log.e_companies (session_id, manipulation_date, manipulation_type_id, company_id, short_name, long_name, full_name) VALUES ({sessionID}, {manipulationDate}, {manipulationTypeID}, {companyID}, {shortName}, {longName}, {fullName}) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Физическое лицо' (log person) # tested # created: work-dev, home-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.fl_e_persons (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id CHAR(6) NOT NULL,
    person_id CHAR(12) NOT NULL,
    last_name VARCHAR(300) NOT NULL,
    first_name VARCHAR(300) NOT NULL,
    middle_name VARCHAR(300),
    dob DATE NOT NULL,
    gender_id CHAR(1) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (session_id) REFERENCES meta.e_sessions(id),
      FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
      FOREIGN KEY (person_id) REFERENCES fl.e_persons(id),
      FOREIGN KEY (gender_id) REFERENCES dict.d_genders(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
      CHECK (gender_id IN ('M','F')),
      CHECK (is_deleted IN ('N','Y'))
);
-- # tested # created: work-dev
COMMENT ON TABLE log.fl_e_persons IS 'Журнал - Физическое лицо';
COMMENT ON COLUMN log.fl_e_persons.id IS 'Идентификатор записи журнала';
COMMENT ON COLUMN log.fl_e_persons.session_id IS 'Идентификатор сессии';
COMMENT ON COLUMN log.fl_e_persons.manipulation_date IS 'Дата изменения сущности';
COMMENT ON COLUMN log.fl_e_persons.manipulation_type_id IS 'Идентификатор типа изменения сущности';
COMMENT ON COLUMN log.fl_e_persons.iin IS 'ИИН ФЛ';
COMMENT ON COLUMN log.fl_e_persons.last_name IS 'Фамилия ФЛ';
COMMENT ON COLUMN log.fl_e_persons.first_name IS 'Имя ФЛ';
COMMENT ON COLUMN log.fl_e_persons.middle_name IS 'Отчество ФЛ';
COMMENT ON COLUMN log.fl_e_persons.dob IS 'Дата рождения ФЛ';
COMMENT ON COLUMN log.fl_e_persons.gender_id IS 'Пол ФЛ';
COMMENT ON COLUMN log.fl_e_persons.is_deleted IS 'Состояние записи';
-- Извлечь историю изменения сущности 'Физическое лицо' # tested
SELECT id, session_id AS "sessionID", manipulation_date AS "manipulationDate", manipulation_type_id AS "manipulationTypeID", iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", gender_id AS "genderID", is_deleted AS "isDeleted" FROM log.fl_e_persons ORDER BY id ASC;
-- Вставить изменение в журнал истории изменения сущности 'Физическое лицо'
INSERT INTO log.fl_e_persons (session_id, manipulation_type_id, iin, last_name, first_name, middle_name, gender_id, is_deleted) VALUES ({sessionID}, {manipulationTypeID}, {iin}, {lastName}, {firstName}, {middleName}, {genderID}, {isDeleted}) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал регистрации запросов сущности 'Физическое лицо' (log$ person) # tested
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.e_persons (
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
        FOREIGN KEY (session_id) REFERENCES users.e_sessions(id),
        FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
        FOREIGN KEY (position_id) REFERENCES ul.e_positions(id),
        CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE log.e_positions IS 'Журнал - Должность ФЛ';
COMMENT ON COLUMN log.e_positions.id IS 'Идентификатор записи журнала';
COMMENT ON COLUMN log.e_positions.session_id IS 'Идентификатор сессии';
COMMENT ON COLUMN log.e_positions.manipulation_date IS 'Дата изменения сущности';
COMMENT ON COLUMN log.e_positions.manipulation_type_id IS 'Идентификатор типа изменения сущности';
COMMENT ON COLUMN log.e_positions.position_id IS 'Идентификатор должности';
COMMENT ON COLUMN log.e_positions.position_name IS 'Наименование должности';
COMMENT ON COLUMN log.e_positions.is_deleted IS 'Состояние записи';
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Подразделение ЮЛ' (division log)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE log.ul_e_divisions (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id INTEGER NOT NULL,
    division_id INTEGER NOT NULL,
    parent_division_id INTEGER,
    division_name VARCHAR (400) NOT NULL,
      is_deleted CHAR(1) NOT NULL DEFAULT 'N',
        PRIMARY KEY (id),
        FOREIGN KEY (session_id) REFERENCES users.e_sessions(id),
        FOREIGN KEY (manipulation_type_id) REFERENCES dict.manipulation_type(id),
        FOREIGN KEY (division_id) REFERENCES ul.e_divisions(id),
        CHECK (is_deleted IN ('N','Y'))
);
COMMENT ON TABLE log._ul.e_divisions IS 'Журнал - Подразделение ЮЛ';
COMMENT ON COLUMN log.ul_e_divisions.id IS 'Идентификатор записи журнала';
COMMENT ON COLUMN log.ul_e_divisions.session_id IS 'Идентификатор сессии';
COMMENT ON COLUMN log.ul_e_divisions.manipulation_date IS 'Дата изменения сущности';
COMMENT ON COLUMN log.ul_e_divisions.manipulation_type_id IS 'Идентификатор типа изменения сущности';
COMMENT ON COLUMN log.ul_e_divisions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN log.ul_e_divisions.parent_division_id IS 'Идентификатор родительского подразделения ЮЛ';
COMMENT ON COLUMN log.ul_e_divisions.division_name IS 'Наименование подразделения ЮЛ';
COMMENT ON COLUMN log.ul_e_divisions.is_deleted IS 'Состояние записи';
