-- Сущность 'Физические лица'
-- Created
CREATE TABLE e_persons (
  iin CHAR(12) NOT NULL, -- Необходимо реализовать проверку ИИН по маске на стороне бакэнда и фронтэнда (Внимание: ИИН представлен в формате VARCHAR)
  last_name VARCHAR(300) NOT NULL,
  first_name VARCHAR(300) NOT NULL,
  middle_name VARCHAR(300),
  dob DATE NOT NULL,
  gender_id INTEGER NOT NULL,
  is_deleted SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (iin),
  FOREIGN KEY (gender_id) REFERENCES dict.d_genders(id),
  CHECK (is_deleted IN (0,1))
);
-- Извлечь всех физических лиц
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM e_persons ORDER BY iin ASC;
-- Извлечь физическое лицо по ИИН
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM e_persons WHERE iin = {iin};
-- Извлечь всех существующих физических лиц
SELECT iin, last_name, first_name, middle_name, dob, gender_id FROM e_persons WHERE is_deleted = 0 ORDER BY iin ASC;
-- Извлечь существующие физическое лицо по ИИН
SELECT iin, last_name, first_name, middle_name, dob, gender_id FROM e_persons WHERE is_deleted = 0 AND iin = {iin};
-- Извлечь всех несуществующих физических лиц
SELECT iin, last_name, first_name, middle_name, dob, gender_id FROM e_persons WHERE is_deleted = 1 ORDER BY iin ASC;
-- Извлечь несуществующие физическое лицо по ИИН
SELECT iin, last_name, first_name, middle_name, dob, gender_id FROM e_persons WHERE is_deleted = 1 AND iin = {iin};
-- Вставить физическое лицо
INSERT INTO e_persons (iin, last_name, first_name, middle_name, dob, gender_id) VALUES ({iin}, {lastName}, {firstName}, {middleName}, {dob}, {genderID}) RETURNING iin;
-- Обновить физическое лицо
UPDATE e_persons SET iin = {iin}, last_name = {lastName}, middle_name = {middleName}, dob = {dob}, gender_id = {genderID} WHERE iin = {iin} RETURNING iin;
-- Удалить физическо лицо
UPDATE e_persons SET is_deleted = 1 WHERE iin = {iin} RETURNING iin; 
-- Журнал истории изменения сущности 'Физическое лицо'
CREATE TABLE log.e_persons (
  id SERIAL,
  session_id INTEGER NOT NULL,
  man_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  type_id INTEGER NOT NULL,
  iin VARCHAR(12) NOT NULL,
  last_name VARCHAR(300) NOT NULL,
  first_name VARCHAR(300) NOT NULL,
  middle_name VARCHAR(300),
  gender_id INTEGER NOT NULL,
  is_deleted INTEGER(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  FOREIGN KEY (session_id) REFERENCES e_sessions(id),
  FOREIGN KEY (type_id) REFERENCES dict.manipulation_type(id),
  FOREIGN KEY (iin) REFERENCES e_persons(iin),
  CHECK (is_deleted IN (0,1))
);
-- Сущность 'Юридические лица'
-- Created
CREATE TABLE e_companies (
  bin NUMERIC(12,0) NOT NULL, -- Необходимо реализовать проверку БИН по маске на стороне бакэнда и фронтэнда
  company_name VARCHAR(500) NOT NULL,
  PRIMARY KEY (bin),
  UNIQUE (company_name)
);
-- Журнал истории изменения сущности 'Юридическое лицо'
CREATE TABLE log.e_companies (
  id SERIAL,
  session_id INTEGER NOT NULL,
  man_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  type_id INTEGER NOT NULL,
  bin NUMERIC[12,0] NOT NULL,
  company_name VARCHAR(500) NOT NULL,
  is_deleted INTEGER(1) NOT NULL DEFAULT 0 CHECK (is_deleted in (0,1)),
  PRIMARY KEY (id),
  FOREIGN KEY (session_id) REFERENCES e_sessions(id),
  FOREIGN KEY (type_id) REFERENCES dict.manipulation_type(id),
  FOREIGN KEY (bin) REFERENCES e_companies(bin)
);
-- Сущность 'Должность'
CREATE TABLE e_positions (
  id SERIAL,
  position_name VARCHAR(500) NOT NULL,
  is_deleted INTEGER(1) NOT NULL DEFAULT 0 CHECK (is_deleted in (0,1)),
  PRIMARY KEY (id),
  UNIQUE (position_name)
);
-- Журнал истории изменения сущности 'Должность'
CREATE TABLE log.e_positions (
  id SERIAL,
  session_id INTEGER NOT NULL,
  man_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  type_id INTEGER NOT NULL,
  position_id INTEGER NOT NULL,
  position_name VARCHAR(500) NOT NULL,
  is_deleted INTEGER(1) NOT NULL DEFAULT 0 CHECK (is_deleted in (0,1)),
  PRIMARY KEY (id),
  FOREIGN KEY (session_id) REFERENCES e_sessions(id),
  FOREIGN KEY (type_id) REFERENCES dict.manipulation_type(id),
  FOREIGN KEY (position_id) REFERENCES e_positions(id)
);
-- Сущность 'Подразделения юридических лиц'
CREATE TABLE e_divisions (
  id SERIAL,
  parent_division_id INTEGER,
  division_name VARCHAR(400) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (division_name),
  FOREIGN KEY (parent_division_id) REFERENCES e_divisions(id)
);
-- Справочники
-- Created
CREATE SCHEMA dict;
-- Справочник 'Пол физического лица'
-- Created
CREATE TABLE dict.d_genders (
  id SERIAL,
  gender_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (gender_name),
  CHECK (id IN (1,2))
);
-- Связь 'Компании - Подразделения'
CREATE TABLE r_e_companies_e_divisions (
  id SERIAL NOT NULL,
  company_id NUMERIC[12,0] NOT NULL,
  division_id INTEGER NOT NULL,
  PRIMARY KEY (company_id, division_id),
  UNIQUE (id),
  FOREIGN KEY (company_id) REFERENCES e_companies(id),
  FOREIGN KEY (division_id) REFERENCES e_divisions(id)
);
-- Связь 'Подразделения - Должности'
CREATE TABLE r_e_divisions_e_positions (
  id SERIAL NOT NULL,
  division_id INTEGER NOT NULL,
  position_id INTEGER NOT NULL,
  PRIMARY KEY (division_id, position_id),
  UNIQUE (id),
  FOREIGN KEY (division_id) REFERENCES e_divisions(id),
  FOREIGN KEY (position_id) REFERENCES e_positions(id)
);
-- Связь 'Должности - Физические лица'
CREATE TABLE r_positions_e_persons (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  position_id INTEGER NOT NULL,
  person_id NUMERIC[12,0] NOT NULL,
  create_date DATE NOT NULL,
  is_deleted INTEGER(1) NOT NULL DEFAULT 0 CHECK (is_deleted in (0,1)),
  PRIMARY KEY (position_id, person_id),
  UNIQUE (id),
  FOREIGN KEY (position_id) REFERENCES e_positions(id),
  FOREIGN KEY (person_id) REFERENCES e_persons(id),
  FOREIGN KEY (serssion_id) REFERENCES e_sessions(id) 
);
-- Сущность 'Сессии'
CREATE TABLE e_sessions (
  id SERIAL NOT NULL,
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  open_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  close_date TIMESTAMP WITH TIME ZONE,
  status INTEGER(1) NOT NULL DEFAULT 0 CHECK (status in (0,1))
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES e_users(id),
  FOREIGN KEY (role_id) REFERENCES e_roles(id)
);
-- Сущность 'Пользователи'
CREATE TABLE e_users (
  id SERIAL NOT NULL,
  person_id NUMERIC[12,0] NOT NULL,
  u_username VARCHAR(20) NOT NULL,
  u_password VARCHAR(20) NOT NULL,
  status_id INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (u_username, u_password),
  UNIQUE (id),
  FOREIGN KEY (person_id) REFERENCES e_persons(iin)
);
-- Сущность 'Роли'
CREATE TABLE e_roles (
  id SERIAL NOT NULL,
  role_name VARCHAR(200) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (role_name)
);
-- Связь 'Роли - Пользователи'
CREATE TABLE e_roles_e_users (
  id SERIAL NOT NULL,
  role_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  PRIMARY KEY (role_id, user_id),
  UNIQUE (id)
  FOREIGN KEY (role_id) REFERENCES e_roles(id),
  FOREIGN KEY (user_id) REFERENCES e_users(id)
);