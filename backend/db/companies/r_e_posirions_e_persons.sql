----------------------------------------------------------------------------------------------------
-- Связь 'Должность физического лица - Физические лица' (relationship position - person)
----------------------------------------------------------------------------------------------------
--
CREATE TABLE companies.r_e_positions_e_persons (
  id SERIAL NOT NULL,
  position_id INTEGER NOT NULL,
  person_id CHAR(12) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (position_id, person_id),
      UNIQUE (id),
      FOREIGN KEY (position_id) REFERENCES companies.e_positions(id),
      FOREIGN KEY (person_id) REFERENCES persons.e_persons(iin),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
--
COMMENT ON TABLE companies.r_e_positions_e_persons IS 'R Должность ФЛ - Физическое лицо';
COMMENT ON COLUMN companies.r_e_positions_e_persons.id IS 'Идентификатор связи';
COMMENT ON COLUMN companies.r_e_positions_e_persons.position_id IS 'Идентификатор должности ФЛ';
COMMENT ON COLUMN companies.r_e_positions_e_persons.person_id IS 'Идентификатор физического лица';
COMMENT ON COLUMN companies.r_e_positions_e_persons.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Должности ФЛ - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM companies.r_e_positions_e_persons ORDER BY id ASC;
-- Извлечь все существующие связи 'Должности ФЛ - Физические лица'
SELECT id, position_id AS "positionID", person_id AS "personID" FROM companies.r_e_positions_e_persons WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должности ФЛ - Физические лица' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM companies.r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM companies.r_e_positions_e_persons WHERE id = {id};
-- Извлечь существующую связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM companies.r_e_positions_e_persons WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующую связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
SELECT id, position_id AS "positionID", person_id AS "personID" FROM companies.r_e_positions_e_persons WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь все связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID", is_deleted AS "isDeleted" FROM companies.r_e_positions_e_persons WHERE position_id = {positionID} ORDER BY id ASC;
-- Извлечь все существующие связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM companies.r_e_positions_e_persons WHERE is_deleted = 'N' AND position_id = {positionID} ORDER BY id ASC;
-- Извлечь все несуществующие связи 'Должность ФЛ - Физические лица' по идентификатору должности
SELECT id, position_id AS "positionID", person_id AS "personID" FROM companies.r_e_positions_e_persons WHERE is_deleted = 'Y' AND position_id = {positionID} ORDER BY id ASC;
-- Вставить связь 'Должность ФЛ - Физическое лицо'
INSERT INTO companies.r_e_positions_e_persons (position_id, person_id) VALUES ({positionID}, {personID}) RETURNING id;
-- Обновить связь 'Должность ФЛ - Физическое лицо' по идентификатору связи
UPDATE companies.r_e_positions_e_persons SET position_id = {positionID}, person_id = {personID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Должность ФЛ - Физические лицо' по идентификатору связи
UPDATE companies.r_e_positions_e_persons SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
