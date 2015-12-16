---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Должность физического лица' (entity person position)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE organizations.e_positions (
  id SERIAL,
  position_name VARCHAR(500) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (position_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE organizations.e_positions IS 'E Должность физического лица';
COMMENT ON COLUMN organizations.e_positions.id IS 'Идентификатор должности';
COMMENT ON COLUMN organizations.e_positions.position_name IS 'Наименование должности';
COMMENT ON COLUMN organizations.e_positions.is_deleted IS 'Состояние записи';
-- Извлечь все должности
SELECT id, position_name AS "positionName", is_deleted AS "isDeleted" FROM organizations.e_positions ORDER BY id ASC;
-- Извлечь должность по идентификатору должности
SELECT id, position_name AS "positionName", is_deleted AS "isDeleted" FROM organizations.e_positions WHERE id = {id};
-- Извлечь все существующие должности
SELECT id, position_name AS "positionName" FROM organizations.e_positions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующую должность по идентификатору должности
SELECT id, position_name AS "positionName" FROM organizations.e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все несуществующие должности
SELECT id, position_name AS "positionName" FROM organizations.e_positions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь несуществующую должность по идентификатору должности
SELECT id, position_name AS "positionName" FROM organizations.e_positions WHERE is_deleted = 'Y' AND id = {id};
-- Вставить должность
INSERT INTO organizations.e_positions (position_name) VALUES ({positionName}) RETURNING id;
-- Обновить должность по идентификатору должности
UPDATE organizations.e_positions SET position_name = {positionName} WHERE id = {id};
-- Удалить должность по идентификатору должности
UPDATE organizations.e_positions SET is_deleted = 'Y' WHERE id = {id};
-- Восстановить должность по идентификатору должности
UPDATE organizations.e_positions SET is_deleted = 'N' WHERE id = {id};
-- Вставить должность "Директор"
INSERT INTO organizations.e_positions (position_name) VALUES ('Директор') RETURNING id;
-- Вставить должность "Менеджер 1-ой категории"
INSERT INTO organizations.e_positions (position_name) VALUES ('Менеджер 1-ой категории') RETURNING id;
-- Вставить должность "Менеджер 2-ой категории"
INSERT INTO organizations.e_positions (position_name) VALUES ('Менеджер 2-ой категории') RETURNING id;
