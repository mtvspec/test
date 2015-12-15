---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Роль - Пользователь' (relationship user - role)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE users.r_e_user_e_roles (
  id SERIAL NOT NULL,
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (role_id, user_id),
      UNIQUE (id),
      FOREIGN KEY (user_id) REFERENCES users.e_users(id),
      FOREIGN KEY (role_id) REFERENCES users.e_roles(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE users.r_e_user_e_roles IS 'R Роль - Пользователь';
COMMENT ON COLUMN users.r_e_user_e_roles.id IS 'Идентификатор роли пользователя';
COMMENT ON COLUMN users.r_e_user_e_roles.user_id IS 'Идентификатор пользователя';
COMMENT ON COLUMN users.r_e_user_e_roles.role_id IS 'Идентификатор роли пользователя';
COMMENT ON COLUMN users.r_e_user_e_roles.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Роли - Пользователи' - ok
SELECT id, user_id AS "userID", role_id AS "roleID" FROM users.r_e_user_e_roles ORDER BY id ASC;
-- Извлечь связь "Роли - Пользователь" по идентификатору пользователя
SELECT id, user_id AS "userID", role_id AS "roleID" FROM users.r_e_user_e_roles WHERE is_deleted = 'N' AND user_id = {userID};
-- Вставить связь 'Роли - Пользователи'
INSERT INTO users.r_e_user_e_roles (user_id, role_id) VALUES ({userID}, {roleID}) RETURNING id;
-- Обновить связь 'Роль - Пользователь' по идентификатору связи
UPDATE users.r_e_user_e_roles SET user_id = {userID}, role_id = {roleID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Роль - Пользователь' по идентификатору связи
UPDATE users.r_e_user_e_roles SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Выбрать все роли всех пользователей
SELECT u.user_id AS "userID", u.role_id AS "roleID", r.role_name AS "roleName" FROM users.r_e_user_e_roles u, users.e_roles r WHERE u.role_id = r.id ORDER BY r.id ASC;
SELECT u.role_id AS "roleID", r.role_name AS "roleName" FROM users.r_e_user_e_roles u, users.e_roles r WHERE u.role_id = r.id AND user_id = {userID};
-- Пользователь "Тимур"
INSERT INTO users.r_e_user_e_roles (user_id, role_id) VALUES (1, 1) RETURNING id;
INSERT INTO users.r_e_user_e_roles (user_id, role_id) VALUES (1, 2) RETURNING id;
-- Пользователь "Куралай"
INSERT INTO users.r_e_user_e_roles (user_id, role_id) VALUES (2, 2) RETURNING id;
