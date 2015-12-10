--================================================================================================--
-- Сущность 'Пользователь' (entity user)
--================================================================================================--
-- ok
CREATE TABLE users.e_users (
  id SERIAL NOT NULL,
  person_id CHAR(12) NOT NULL,
  u_username VARCHAR(20) NOT NULL,
  u_password VARCHAR(4000) NOT NULL,
  default_role_id INTEGER NOT NULL,
    is_blocked CHAR(1) NOT NULL DEFAULT 'N',
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (u_username, u_password),
      UNIQUE (id),
      FOREIGN KEY (person_id) REFERENCES persons.e_persons(id),
      FOREIGN KEY (default_role_id) REFERENCES users.e_roles(id),
      FOREIGN KEY (is_blocked) REFERENCES users.d_user_profile_status(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE users.e_users IS 'E Пользователь';
COMMENT ON COLUMN users.e_users.id IS 'Идентификатор учетной записи';
COMMENT ON COLUMN users.e_users.person_id IS 'Идентификатор физического лица';
COMMENT ON COLUMN users.e_users.u_username IS 'Имя пользователя';
COMMENT ON COLUMN users.e_users.u_password IS 'Пароль пользователя';
COMMENT ON COLUMN users.e_users.default_role_id IS 'Идентификатор роли по умолчанию';
COMMENT ON COLUMN users.e_users.is_blocked IS 'Состояние учетной записи';
COMMENT ON COLUMN users.e_users.is_deleted IS 'Состояние записи';
-- Извлечь всех пользователей - ok
SELECT id, person_id AS "personID", u_username AS "username", u_password AS "password", default_role_id AS "defaultRoleID", is_blocked AS "isBlocked", is_deleted AS "isDeleted" FROM users.e_users ORDER BY id ASC;
--
SELECT id, person_id AS "personID", u_username AS "username", u_password AS "password", default_role_id AS "defaultRoleID", is_blocked AS "isBlocked", is_deleted AS "isDeleted" FROM users.e_users ORDER BY id ASC;
-- Извлечь пользователя (физическое лицо) по имени пользователя
SELECT id, person_id AS "personID", u_username AS "username", is_blocked AS "isBlocked",  is_deleted AS "isDeleted" FROM users.e_users WHERE u_username = {username};
-- Вставить пользователя
INSERT INTO users.e_users (person_id, u_username, u_password, default_role_id) VALUES ({personID}, {username}, {password}, {defaultRoleID}) RETURNING id;
-- Изменить пароль пользователя по идентификатору пользователя
UPDATE users.e_users SET u_password = {password} WHERE id = {id} RETURNING id;
-- Удалить пользователя по идентификатору пользователя
UPDATE users.e_users SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить пользователя по идентификатору пользователя
UPDATE users.e_users SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Заблокировать пользователя по идентификатору пользователя
UPDATE users.e_users SET is_blocked = 'Y' WHERE id = {id} RETURNING id;
-- Разблокировать пользователя по идентификатору пользователя
UPDATE users.e_users SET is_blocked = 'N' WHERE id = {id} RETURNING id;
-- Вставить пользователя "Тимур" - ok
INSERT INTO users.e_users (person_id, u_username, u_password, default_role_id) VALUES ('871215301496', 'mtvspec', '$2a$10$qjPA2g9BVo.36aBQSucIeuQymEtD114rgvOWFgxiQkNwlNaKi06pK', 1) RETURNING id;
-- Вставить пользователя "Куралай" - ok
INSERT INTO users.e_users (person_id, u_username, u_password, default_role_id) VALUES ('940909450852', 'tkspec', '$2a$10$0/dm17l/FsHKBoEKkp.ddu7G7cU2/AJb3j5kquL56uCyA82tRwuDq', 2) RETURNING id;
