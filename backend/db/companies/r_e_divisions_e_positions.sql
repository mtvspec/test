---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Подразделение юридического лица - Должности физического лица' (relationship division - position)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE companies.r_e_divisions_e_positions (
  id SERIAL NOT NULL,
  division_id INTEGER NOT NULL,
  position_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (division_id, position_id),
      UNIQUE (id),
      FOREIGN KEY (division_id) REFERENCES companies.e_divisions(id),
      FOREIGN KEY (position_id) REFERENCES companies.e_positions(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE companies.r_e_divisions_e_positions IS 'R Подразделение ЮЛ - Должность ФЛ';
COMMENT ON COLUMN companies.r_e_divisions_e_positions.id IS 'Идентификатор связи';
COMMENT ON COLUMN companies.r_e_divisions_e_positions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN companies.r_e_divisions_e_positions.position_id IS 'Идентификатор должности ФЛ';
COMMENT ON COLUMN companies.r_e_divisions_e_positions.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM companies.r_e_divisions_e_positions ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM companies.r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все несуществующие связи 'Подразделения ЮЛ - Должности ФЛ'
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM companies.r_e_divisions_e_positions WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Подразделение ЮЛ - Должность' по индетификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted AS "isDeleted" FROM companies.r_e_divisions_e_positions WHERE id = {id};
-- Извлечь существующую связь 'Подразделение ЮЛ - Должность ЮЛ' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM companies.r_e_divisions_e_positions WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Подразделение ЮЛ - Должность ЮЛ' по идентификатору связи
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM companies.r_e_divisions_e_positions WHERE id_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID", is_deleted = AS "isDeleted" FROM companies.r_e_divisions_e_positions WHERE division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM companies.r_e_divisions_e_positions WHERE is_deleted = 'N' AND division_id = {divisionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Подразделение ЮЛ - Должности ФЛ' по идентификатору подразделения
SELECT id, division_id AS "divisionID", position_id AS "positionID" FROM companies.r_e_divisions_e_positions WHERE is_deleted = 'Y' AND division_id = {divisionID} ORDER BY id ASC;
-- Вставить связь 'Подразделение ЮЛ - Должность ФЛ'
INSERT INTO companies.r_e_divisions_e_positions (division_id, position_id) VALUES ({divisionID}, {positionID}) RETURNING id;
-- Обновить связь 'Подразделение ЮЛ - Должность ФЛ' по идентификатору связи
UPDATE companies.r_e_divisions_e_positions SET division_id = {divisionID}, position_id = {positionID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Подразделение ЮЛ - Должность ФЛ' по идентификатору связи
UPDATE companies.r_e_divisions_e_positions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
