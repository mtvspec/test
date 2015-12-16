---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Роль' (entity role)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE users.e_roles (
  id SERIAL NOT NULL,
  role_name VARCHAR(200) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (role_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE users.e_roles IS 'E Роль пользователя';
COMMENT ON COLUMN users.e_roles.id IS 'Идентификатор роли пользователя';
COMMENT ON COLUMN users.e_roles.role_name IS 'Наименование роли пользователя';
COMMENT ON COLUMN users.e_roles.is_deleted IS 'Состояние записи';
-- Извлечь все роли
SELECT id, role_name AS "roleName", is_deleted AS "isDeleted" FROM users.e_roles ORDER BY id ASC;
-- Извлечь существующие роли
SELECT id, role_name AS "roleName" FROM user.e_roles  WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующие роли
SELECT id, role_name AS "roleName" FROM user.e_roles  WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь роль
SELECT id, role_name AS "roleName", is_deleted AS "isDeleted" FROM users.e_roles  WHERE id = {id};
-- Извлечь существующую роль
SELECT id, role_name AS "roleName" FROM users.e_roles  WHERE is_deleted = 'N' id = {id};
-- Извлечь несуществующую роль
SELECT id, role_name AS "roleName" FROM users.e_roles  WHERE is_deleted = 'Y' id = {id};
-- Вставить роль
INSERT INTO users.e_roles (role_name) VALUES ({roleName}) RETURNING id;
-- Обновить роль по идентификатору роли
UPDATE users.e_roles SET role_name = {roleName} WHERE id = {id} RETURNING id;
-- Удалить роль по идентификатору роли
UPDATE users.e_roles SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить роль по идентификатору роли
UPDATE users.e_roles SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Вставить роль "Администратор" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Администратор') RETURNING id;
-- Вставить роль "Руководитель" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Руководитель') RETURNING id;
-- Вставить роль "Руководитель проекта" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Руководитель проекта') RETURNING id;
-- Вставить роль "Разработчик" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Разработчик') RETURNING id;
-- Вставить роль "Технический писатель" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Технический писатель') RETURNING id;
-- Вставить роль "Постановщик задач" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Постановщик задач') RETURNING id;
-- Вставить роль "Тестировщик" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Тестировщик') RETURNING id;
-- Вставить роль "Пользователь" - ok
INSERT INTO users.e_roles (role_name) VALUES ('Пользователь') RETURNING id;
