--=======================================================================================================================================================================================================================================================================--
-- Метаданные # tested # created: work-dev
--=======================================================================================================================================================================================================================================================================--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- structure:
-- dictionary     "d_user_profile_status" - справочник "Состояние учетной записи"
-- dictionary     "d_session_status" - справочник "Состояние сессии"
-- entity         "e_roles" - сущность "Роль пользователя"
-- entity         "e_users" - сущность "Пользователь"
-- relationship   "r_e_user_e_roles" - связь "Роль - Пользователь"
-- entity         "e_sessions" - сущность "Сессия"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- dependencies:
-- schema "dict" - схема "Справочники"
-- dictionary "is_deleted" - справочник "Состояние записи"
-- schema "person" - схема "Физическое лицо"
-- entity "e_persons" - сущность "Физическое лицо"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA meta; -- ok
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Состояние учетной записи' (dictionary user profile condition) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE meta.d_user_profile_status (
  id CHAR(1),
  condition_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (condition_name),
    CHECK (id IN ('N', 'Y'))
);
COMMENT ON TABLE meta.d_user_profile_status IS 'D Состояние учетной записи';
COMMENT ON COLUMN meta.d_user_profile_status.id IS 'Идентификатор состояния учетной записи';
COMMENT ON COLUMN meta.d_user_profile_status.condition_name IS 'Наименование состояния учетной записи';
-- Вставить справочное значение 'Нет' # tested # created: work-dev
INSERT INTO meta.d_user_profile_status (id, condition_name) VALUES ('N', 'Нет') RETURNING id;
-- Вставить справочное значение 'Да' # tested # created: work-dev
INSERT INTO meta.d_user_profile_status (id, condition_name) VALUES ('Y', 'Да') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Состояние сессии' (dictionary session condition)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE meta.d_session_status (
  id CHAR(1),
  condition_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (condition_name),
    CHECK (id IN ('O', 'C'))
);
-- ok
COMMENT ON TABLE meta.d_session_status IS 'D Состояние сессии';
COMMENT ON COLUMN meta.d_session_status.id IS 'Идентификатор состояния сессии';
COMMENT ON COLUMN meta.d_session_status.condition_name IS 'Наименование состояния сессии';
-- Вставить справочное значение 'Открыта' - ok
INSERT INTO meta.d_session_status (id, condition_name) VALUES ('O', 'Открыта') RETURNING id;
-- Вставить справочное значение 'Закрыта' - ok
INSERT INTO meta.d_session_status (id, condition_name) VALUES ('C', 'Закрыта') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Роль' (entity role)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE meta.e_roles (
  id SERIAL NOT NULL,
  role_name VARCHAR(200) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (role_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE meta.e_roles IS 'Сущность - Роль пользователя';
COMMENT ON COLUMN meta.e_roles.id IS 'Идентификатор роли пользователя';
COMMENT ON COLUMN meta.e_roles.role_name IS 'Наименование роли пользователя';
COMMENT ON COLUMN meta.e_roles.is_deleted IS 'Состояние записи';
-- Извлечь все роли
SELECT id, role_name AS "roleName", is_deleted AS "isDeleted" FROM meta.e_roles ORDER BY id ASC;
-- Извлечь существующие роли
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующие роли
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь роль
SELECT id, role_name AS "roleName", is_deleted AS "isDeleted" FROM meta.e_roles  WHERE id = {id};
-- Извлечь существующую роль
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'N' id = {id};
-- Извлечь несуществующую роль
SELECT id, role_name AS "roleName" FROM meta.e_roles  WHERE is_deleted = 'Y' id = {id};
-- Вставить роль
INSERT INTO meta.e_roles (role_name) VALUES ({roleName}) RETURNING id;
-- Обновить роль по идентификатору роли
UPDATE meta.e_roles SET role_name = {roleName} WHERE id = {id} RETURNING id;
-- Удалить роль по идентификатору роли
UPDATE meta.e_roles SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить роль по идентификатору роли
UPDATE meta.e_roles SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Вставить роль "Администратор"
INSERT INTO meta.e_roles (role_name) VALUES ('Администратор') RETURNING id;
-- Вставить роль "Пользователь"
INSERT INTO meta.e_roles (role_name) VALUES ('Пользователь') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Пользователь' (entity user)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE meta.e_users (
  id SERIAL NOT NULL,
  person_id CHAR(12) NOT NULL,
  u_username VARCHAR(20) NOT NULL,
  u_password VARCHAR(4000) NOT NULL,
  default_role_id INTEGER NOT NULL,
    is_blocked CHAR(1) NOT NULL DEFAULT 'N',
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (u_username, u_password),
      UNIQUE (id),
      FOREIGN KEY (person_id) REFERENCES person.e_persons(id),
      FOREIGN KEY (default_role_id) REFERENCES meta.e_roles(id),
      FOREIGN KEY (is_blocked) REFERENCES meta.d_user_profile_status(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE meta.e_users IS 'E Пользователь';
COMMENT ON COLUMN meta.e_users.id IS 'Идентификатор учетной записи';
COMMENT ON COLUMN meta.e_users.person_id IS 'Идентификатор физического лица';
COMMENT ON COLUMN meta.e_users.u_username IS 'Имя пользователя';
COMMENT ON COLUMN meta.e_users.u_password IS 'Пароль пользователя';
COMMENT ON COLUMN meta.e_users.default_role_id IS 'Идентификатор роли по умолчанию';
COMMENT ON COLUMN meta.e_users.is_blocked IS 'Состояние учетной записи';
COMMENT ON COLUMN meta.e_users.is_deleted IS 'Состояние записи';
-- Извлечь всех пользователей - ok
SELECT id, person_id AS "personID", u_username AS "username", u_password AS "password", default_role_id AS "defaultRoleID", is_blocked AS "isBlocked", is_deleted AS "isDeleted" FROM meta.e_users ORDER BY id ASC;
-- Извлечь пользователя (физическое лицо) по имени пользователя # tested
SELECT id, person_id AS "personID", u_username AS "username", is_blocked AS "isBlocked",  is_deleted AS "isDeleted" FROM meta.e_users WHERE u_username = {username};
-- Вставить пользователя # tested # created: work-dev
INSERT INTO meta.e_users (person_id, u_username, u_password, default_role_id) VALUES ({personID}, {username}, {password}, {defaultRoleID}) RETURNING id;
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
-- Вставить пользователя "Тимур" - ok
INSERT INTO meta.e_users (person_id, u_username, u_password, default_role_id) VALUES ('871215301496', 'mtvspec', '$2a$10$qjPA2g9BVo.36aBQSucIeuQymEtD114rgvOWFgxiQkNwlNaKi06pK', 1) RETURNING id;
-- Вставить пользователя "Куралай" - ok
INSERT INTO meta.e_users (person_id, u_username, u_password, default_role_id) VALUES ('940909450852', 'tkspec', '$2a$10$0/dm17l/FsHKBoEKkp.ddu7G7cU2/AJb3j5kquL56uCyA82tRwuDq', 2) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Роль - Пользователь' (relationship user - role)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE meta.r_e_user_e_roles (
  id SERIAL NOT NULL,
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (role_id, user_id),
      UNIQUE (id),
      FOREIGN KEY (user_id) REFERENCES meta.e_users(id),
      FOREIGN KEY (role_id) REFERENCES meta.e_roles(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE meta.r_e_user_e_roles IS 'R Роль - Пользователь';
COMMENT ON COLUMN meta.r_e_user_e_roles.id IS 'Идентификатор роли пользователя';
COMMENT ON COLUMN meta.r_e_user_e_roles.user_id IS 'Идентификатор пользователя';
COMMENT ON COLUMN meta.r_e_user_e_roles.role_id IS 'Идентификатор роли пользователя';
COMMENT ON COLUMN meta.r_e_user_e_roles.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Роли - Пользователи' - ok
SELECT id, user_id AS "userID", role_id AS "roleID" FROM meta.r_e_user_e_roles ORDER BY id ASC;
-- Извлечь связь "Роли - Пользователь" по идентификатору пользователя
SELECT id, user_id AS "userID", role_id AS "roleID" FROM meta.r_e_user_e_roles WHERE is_deleted = 'N' AND user_id = {userID};
-- Вставить связь 'Роли - Пользователи'
INSERT INTO meta.r_e_user_e_roles (user_id, role_id) VALUES ({userID}, {roleID}) RETURNING id;
-- Обновить связь 'Роль - Пользователь' по идентификатору связи
UPDATE meta.r_e_user_e_roles SET user_id = {userID}, role_id = {roleID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Роль - Пользователь' по идентификатору связи
UPDATE meta.r_e_user_e_roles SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Выбрать все роли всех пользователей
SELECT u.user_id AS "userID", r.role_name AS "roleName" FROM meta.r_e_user_e_roles u, meta.e_roles r WHERE u.role_id = r.id ORDER BY r.id ASC;
SELECT u.role_id AS "roleID", r.role_name AS "roleName" FROM meta.r_e_user_e_roles u, meta.e_roles r WHERE u.role_id = r.id AND user_id = {userID};
-- Пользователь "Тимур"
INSERT INTO meta.r_e_user_e_roles (user_id, role_id) VALUES (1, 1) RETURNING id;
INSERT INTO meta.r_e_user_e_roles (user_id, role_id) VALUES (1, 2) RETURNING id;
-- Пользователь "Куралай"
INSERT INTO meta.r_e_user_e_roles (user_id, role_id) VALUES (2, 2) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Сессия' (entity session) #tested
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE meta.e_sessions (
  id SERIAL NOT NULL,
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  open_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  close_date TIMESTAMP WITH TIME ZONE,
  status_id CHAR(1) NOT NULL DEFAULT 'O',
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES meta.e_users(id),
    FOREIGN KEY (role_id) REFERENCES meta.e_roles(id),
    FOREIGN KEY (status_id) REFERENCES meta.d_session_status(id)
);
-- ok
COMMENT ON TABLE meta.e_sessions IS 'E Сессия';
COMMENT ON COLUMN meta.e_sessions.id IS 'Идентификатор сессии';
COMMENT ON COLUMN meta.e_sessions.user_id IS 'Идентификатор пользователя';
COMMENT ON COLUMN meta.e_sessions.role_id IS 'Идентификатор роли';
COMMENT ON COLUMN meta.e_sessions.open_date IS 'Дата и время открытия сессии';
COMMENT ON COLUMN meta.e_sessions.close_date IS 'Дата и время закрытия сессии';
COMMENT ON COLUMN meta.e_sessions.status_id IS 'Идентификатор состояния сессии';
-- Извлечь все сессии
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM meta.e_sessions ORDER BY id ASC;
-- Извлечь сессию по идентификатору сессии
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM meta.e_sessions WHERE id = {id};
-- Извлечь сессии по идентификатору пользователя
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM meta.e_sessions WHERE user_id = {userID};
-- Вставить сессию
INSERT INTO meta.e_sessions (user_id, role_id) VALUES ({userID}, {roleID}) RETURNING id;
-- Закрыть сессию
UPDATE meta.e_sessions SET status_id = 'C', close_date = 'now()' WHERE id = {id};
