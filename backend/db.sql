-- Сущность 'Физические лица'
-- Created
CREATE TABLE e_persons (
  iin CHAR(12) NOT NULL, -- Необходимо реализовать проверку ИИН по маске на стороне бакэнда и фронтэнда (Внимание: ИИН представлен в формате VARCHAR)
  last_name VARCHAR(200) NOT NULL,
  first_name VARCHAR(200) NOT NULL,
  middle_name VARCHAR(300),
  dob DATE NOT NULL,
  gender_id CHAR(1) NOT NULL,
  is_deleted CHAR(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (iin),
  FOREIGN KEY (gender_id) REFERENCES dict.d_genders(id),
  CHECK (iin >= 12 AND iin <= 12),
  CHECK (gender_id IN ('M','F')),
  CHECK (is_deleted IN ('N','Y'))
);
-- Извлечь всех физических лиц
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM e_persons ORDER BY iin ASC;
-- Извлечь физическое лицо по ИИН
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID", is_deleted AS "isDeleted" FROM e_persons WHERE iin = {iin};
-- Извлечь всех существующих физических лиц
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'N' ORDER BY iin ASC;
-- Извлечь существующие физическое лицо по ИИН
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'N' AND iin = {iin};
-- Извлечь всех несуществующих физических лиц
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'Y' ORDER BY iin ASC;
-- Извлечь несуществующее физическое лицо по ИИН
SELECT iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", dob, gender_id AS "genderID" FROM e_persons WHERE is_deleted = 'Y' AND iin = {iin};
-- Вставить физическое лицо
INSERT INTO e_persons (iin, last_name, first_name, middle_name, dob, gender_id) VALUES ({iin}, {lastName}, {firstName}, {middleName}, {dob}, {genderID}) RETURNING iin;
-- Обновить физическое лицо
UPDATE e_persons SET iin = {iin}, last_name = {lastName}, first_name = {firstName} middle_name = {middleName}, dob = {dob}, gender_id = {genderID} WHERE iin = {iin} RETURNING iin;
-- Удалить физическо лицо
UPDATE e_persons SET is_deleted = 1 WHERE iin = {iin} RETURNING iin;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Физическое лицо'
-- Created
CREATE TABLE log.e_persons (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  manipulation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  manipulation_type_id CHAR(1) NOT NULL,
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
  FOREIGN KEY (iin) REFERENCES e_persons(iin),
  FOREIGN KEY (gender_id) REFERENCES dict.d_genders(id),
  FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
  CHECK (gender_id IN ('M','F')),
  CHECK (is_deleted IN ('N','Y'))
);
-- Извлечь историю изменения сущности 'Физическое лицо'
SELECT id, session_id AS "sessionID", man_date AS "manDate", type_id AS "typeID", iin, last_name AS "lastName", first_name AS "firstName", middle_name AS "middleName", gender_id AS "genderID", is_deleted AS "isDeleted" FROM log.e_persons ORDER BY id ASC;
-- Вставить изменение в журнал истории изменения сущности 'Физическое лицо'
INSERT INTO log.e_persons (session_id, manipulation_type_id, iin, last_name, first_name, middle_name, gender_id, is_deleted) values ({sessionID}, {manipulationTypeID}, {iin}, {lastName}, {firstName}, {middleName}, {genderID}, {isDeleted}) RETURNING id;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Юридические лица'
-- Created
CREATE TABLE e_companies (
  bin CHAR(12) NOT NULL, -- Необходимо реализовать проверку БИН по маске на стороне бакэнда и фронтэнда
  company_name VARCHAR(500) NOT NULL,
  is_deleted CHAR NOT NULL DEFAULT 'N',
  PRIMARY KEY (bin),
  UNIQUE (company_name),
  FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id),
  CHECK (is_deleted IN ('N','Y'))
);
-- Извлечь все юридические лица
SELECT bin, company_name AS "companyName", is_deleted AS "isDeleted" FROM e_companies ORDER BY bin ASC;
-- Извлечь юридическое лицо по БИН
SELECT bin, company_name AS "companyName", is_deleted AS "isDeleted" FROM e_companies WHERE bin = {bin};
-- Извлечь все существующее юридические лица
SELECT bin, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'N' ORDER BY bin ASC;
-- Извлечь существующее юридическое лицо по БИН
SELECT bin, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'N' AND bin = {bin};
-- Извлечь все не существующие юридические лица
SELECT bin, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'Y' ORDER BY bin ASC;
-- Извлечь не существующее юридическое лицо по БИН
SELECT bin, company_name AS "companyName" FROM e_companies WHERE is_deleted = 'Y' AND bin = {bin};
-- Вставить юридическое лицо
-- Tested: OK
INSERT INTO e_companies (bin, company_name) VALUES ({bin}, {companyName}) RETURNING bin;
-- Обновить юридическое лицо
UPDATE e_companies SET bin = {bin}, company_name = {companyName} WHERE bin = {bin} RETURNING bin;
-- Удалить юридическое лицо
UPDATE e_companies SET is_deleted = 'Y' WHERE bin = {bin} RETURNING bin;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Юридическое лицо'
CREATE TABLE log.e_companies (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  man_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  type_id INTEGER NOT NULL,
  bin CHAR(12) NOT NULL,
  company_name VARCHAR(500) NOT NULL,
  is_deleted CHAR(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (id),
  FOREIGN KEY (session_id) REFERENCES meta.e_sessions(id),
  FOREIGN KEY (type_id) REFERENCES dict.manipulation_type(id),
  FOREIGN KEY (bin) REFERENCES e_companies(bin),
  CHECK (is_deleted IN ('N','Y'))
);
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Должность'
CREATE TABLE e_positions (
  id SERIAL NOT NULL,
  position_name VARCHAR(500) NOT NULL,
  is_deleted CHAR(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (id),
  UNIQUE (position_name),
  CHECK (is_deleted IN ('N','Y'))
);
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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Журнал истории изменения сущности 'Должность'
CREATE TABLE log.e_positions (
  id SERIAL NOT NULL,
  session_id INTEGER NOT NULL,
  man_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  type_id INTEGER NOT NULL,
  position_id INTEGER NOT NULL,
  position_name VARCHAR(500) NOT NULL,
  is_deleted CHAR(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (id),
  FOREIGN KEY (session_id) REFERENCES e_sessions(id),
  FOREIGN KEY (type_id) REFERENCES dict.manipulation_type(id),
  FOREIGN KEY (position_id) REFERENCES e_positions(id),
  CHECK (is_deleted IN ('N','Y'))
);
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Подразделения юридических лиц'
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
-- Извлечь все подразделения юридических лиц
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName" FROM e_divisions ORDER BY id ASC;
-- Извлечь подразделение 
-- ==========================================================================================================================================================================================================================--
-- Справочники
-- ==========================================================================================================================================================================================================================--
-- Created
CREATE SCHEMA dict;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Пол физического лица (Мужской/Женский)'
-- Created
CREATE TABLE dict.d_genders (
  id CHAR(1),
  gender_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (gender_name),
  CHECK (id IN ('M','F'))
);
-- Извлечь значения справочника 'Пол физического лица'
SELECT id, gender_name AS "genderName" FROM dict.d_genders ORDER BY id ASC;
-- Извлечь значение справоничка 'Пол физического лица' по идентификатору значения справочника
SELECT id, gender_name AS "genderName" FROM dict.d_genders WHERE id = {id};
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Удален? (Нет/Да)'
-- Created
CREATE TABLE dict.is_deleted (
  id CHAR(1),
  condition_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (condition_name),
  CHECK (id IN ('N', 'Y'))
);
-- Извлечь значения справочника 'Удален (Нет/Да)'
SELECT id, condition_name AS "conditionName" FROM dict.is_deleted ORDER BY id ASC;
-- Извлечь значение справочника 'Удален (Нет/Да)' по идентификатору значения справочника
SELECT id, condition_name AS "conditionName" FROM dict.is_deleted WHERE id = {id};
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Тип манипуляции над данными'
-- Created
CREATE TABLE dict.manipulation_type (
  id CHAR(1) NOT NULL,
  manipulation_type_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (manipulation_type_name)
);
-- ==========================================================================================================================================================================================================================--
-- Метаданные
-- ==========================================================================================================================================================================================================================--
-- Created
CREATE SCHEMA meta;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Сессии'
-- Created
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
-- Извлечь сессию по идентификатору пользователя
SELECT id, role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate" status FROM meta.e_sessions WHERE user_id = {userID};
-- Вставить сессию
INSERT INTO meta.e_sessions (user_id, role_id) VALUES ({userID}, {roleID}) RETIRNING id;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Пользователи'
-- Created
CREATE TABLE meta.e_users (
  id SERIAL NOT NULL,
  person_id CHAR(12) NOT NULL,
  u_username VARCHAR(20) NOT NULL,
  u_password VARCHAR(20) NOT NULL,
  is_blocked CHAR(1) NOT NULL DEFAULT 'N',
  is_deleted CHAR(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (u_username, u_password),
  UNIQUE (id),
  FOREIGN KEY (person_id) REFERENCES e_persons(iin),
  CHECK (is_blocked IN ('N', 'Y')),
  CHECK (is_deleted IN ('N', 'Y'))
);
-- Извлечь пользователя по имени пользователя
SELECT id, person_id AS "personID", status FROM meta.e_users WHERE u_username = {username}; 
-- Вставить пользователя
INSERT INTO meta.e_users (person_id, u_username, u_password) VALUES ({personID}, {username}, {password}) RETURNING id;
-- Изменить пароль пользователя по идентификатору пользователя
UPDATE meta.e_users SET u_password = {password} WHERE id = {id};
-- Удалить пользователя по идентификатору пользователя
UPDATE meta.e_users SET is_deleted = 'Y' WHERE id = {id};
-- Восстановить пользователя по идентификатору пользователя
UPDATE meta.e_users SET is_deleted = 'N' WHERE id = {id};
-- Заблокировать пользователя по идентификатору пользователя
UPDATE meta.e_users SET is_blocked = 'Y' WHERE id = {id};
-- Разблокировать пользователя по идентификатору пользователя
UPDATE meta.e_users SET is_blocked = 'N' WHERE id = {id};
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Роли'
-- Created
CREATE TABLE meta.e_roles (
  id SERIAL NOT NULL,
  role_name VARCHAR(200) NOT NULL,
  is_deleted CHAR(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (id),
  UNIQUE (role_name),
  CHECK (is_deleted IN ('N', 'Y'))
);
-- Извлечь все роли
SELECT id, role_name FROM meta.e_roles ORDER BY id ASC;
-- Вставить роль
INSERT INTO meta.e_roles (role_name) VALUES ({roleName});
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Роли - Пользователи'
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
-- ==========================================================================================================================================================================================================================--
-- Связь 'Компании - Подразделения'
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
-- Извлечь все связи 'Компании - Подразделения'
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM r_e_companies_e_divisions ORDER BY id ASC;
-- Извлечь все связи 'Компания - Подразделения' по идентификатору компании
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM r_e_companies_e_divisions WHERE company_id = {companyID} ORDER BY id ASC;
-- Извлечь существующие связи 'Компания - Подразделения'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM r_e_companies_e_divisions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь несуществующие связи 'Компания - Подразделения'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM r_e_companies_e_divisions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Вставить связь 'Компания - Подразделение'
INSERT INTO r_e_companies_e_divisions (company_id, division_id) VALUES ({companyID}, {division_ID}) RETURNING id;
-- Обновить связь 'Компания - Подразделение' по идентификатору связи
UPDATE r_e_companies_e_divisions SET company_id = {companyID}, division_id = {divisionID} WHERE id = {id};
-- Удалить связь 'Компания - Подразделение' по идентификатору связи
UPDATE r_e_companies_e_divisions SET is_deleted = 'Y' WHERE id = {id};
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Подразделения - Должности'
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
-- Извлечь все связи 'Подразделения - Должности'
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM r_e_divisions_e_positions ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделения - Должности'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все несуществующие связи 'Подразделения - Должности'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Подразделение - Должность' по индетификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM r_e_divisions_e_positions WHERE id = {id};
-- Извлечь существующую связь 'Подразделение - Должность' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Подразделение - Должность' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE id_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Подразделение - Должности' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted = AS "isDeleted" FROM r_e_divisions_e_positions WHERE division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделение - Должности' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'N' AND division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Подразделение - Должности' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM r_e_divisions_e_positions WHERE is_deleted = 'Y' AND division_id = {divisionID} ORDER BY id ASC;
-- Вставить связь 'Подразделение - Должность'
INSERT INTO r_e_division_e_positions (division_id, position_id) VALUES ({divisionID}, {positionID}) RETURNING id;
-- Обновить связь 'Подразделение - Должность' по идентификатору связи
UPDATE r_e_divisions_e_positions SET division_id = {divisionID}, position_id = {positionID} WHERE id = {id};
-- Удалить связь 'Подразделение - Должность' по идентификатору связи
UPDATE r_e_divisions_e_positions SET is_deleted = 'Y' WHERE id = {id};
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Должности - Физические лица'
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
-- Извлечь все связи 'Должности - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM r_e_positions_e_persons ORDER BY id ASC;
-- Извлечь все существующие связи 'Должности - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должности - Физические лица' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Должность - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM r_e_positions_e_persons WHERE id = {id};
-- Извлечь существующую связь 'Должность - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Должность - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Должность - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM r_e_positions_e_persons WHERE position_id = {positionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Должность - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'N' AND position_id = {positionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должность - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM r_e_positions_e_persons WHERE is_deleted = 'Y' AND position_id = {positionID} ORDER BY id ASC;
-- Вставить связь 'Должность - Физическое лицо'
INSERT INTO r_e_positions_e_persons (position_id, person_id) VALUES ({positionID}, {personID}) RETURNING id;
-- Обновить связь 'Должность - Физическое лицо' по идентификатору связи
UPDATE r_e_positions_e_persons SET position_id = {positionID}, person_id = {personID} WHERE id = {id};
-- Удалить связь 'Должность - Физические лицо' по идентификатору связи
UPDATE r_e_positions_e_persons SET is_deleted = 'Y' WHERE id = {id};
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------