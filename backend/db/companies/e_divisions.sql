---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Подразделение ЮЛ' (entity division)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE companies.e_divisions (
  id SERIAL NOT NULL,
  division_name VARCHAR(400) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (division_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE company.e_divisions IS 'E Подразделение юридического лица';
COMMENT ON COLUMN company.e_divisions.id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN company.e_divisions.parent_division_id IS 'Идентификатор родительского подразделения ЮЛ';
COMMENT ON COLUMN company.e_divisions.division_name IS 'Наименование подразделения ЮЛ';
COMMENT ON COLUMN company.e_divisions.is_deleted IS 'Состояние записи';
-- Извлечь все сущности "Подразделение ЮЛ"
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName", is_deleted AS "isDeleted" FROM companies.e_divisions ORDER BY id ASC;
-- Извлечь сущность "Подразделение ЮЛ" по идентификатору сущности
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName", is_deleted AS "isDeleted" FROM companies.e_divisions WHERE id = {id};
-- Извлечь существующие сущности "Подразделение ЮЛ"
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName" FROM companies.e_divisions WHERE is_deleted = "N" ORDER BY id ASC;
-- Извлечь существующую сущность "Подразделение ЮЛ"
SELECT id, parent_division_id AS "parentDivisionID", division_name AS "divisionName" FROM companies.e_divisions WHERE is_deleted = "N" AND id = {id};
-- Вставить сущность "Подразделение ЮЛ"
INSERT INTO companies.e_divisions (division_name) VALUES ({divisionName}) RETURNING id;
-- Вставить сущность "(дочернее) Подразделение ЮЛ"
INSERT INTO companies.e_divisions (parent_division_id, division_name) VALUES ({parentDivisionID}, {divisionName}) RETURNING id;
-- Обновить сущность "Подразделение ЮЛ" по идентификатору сущности
UPDATE companies.e_divisions SET division_name = {divisionName} WHERE id = {id} RETURNING id;
-- Обновить сущность "(дочернее) Подразделение ЮЛ" по идентификатору сущности
UPDATE companies.e_divisions SET parent_division_id = {parentDivisionID}, division_name = {divisionName} RETURNING id;
-- Удалить сущность "Подразделение ЮЛ" по идентификатору сущности
UPDATE companies.e_divisions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Вставить подразделение "Департамент информационных технологий"
INSERT INTO companies.e_divisions (division_name) VALUES ('Департамент информационных технологий') RETURNING id;
-- Вставить подразделение "Отдел разработки"
INSERT INTO companies.e_divisions (division_name) VALUES ('Отдел разработки') RETURNING id;
-- Вставить подразделение "Отдел консалтинга"
INSERT INTO companies.e_divisions (division_name) VALUES ('Отдел консалтинга') RETURNING id;
-- Вставить подразделение "Отдел администрирования и сетевых технологий"
INSERT INTO companies.e_divisions (division_name) VALUES ('Отдел администрирования и сетевых технологий') RETURNING id;
-- Вставить подразделение "Отдел мобильных приложений"
INSERT INTO companies.e_divisions (division_name) VALUES ('Отдел мобильных приложений') RETURNING id;
-- Вставить подразделение "Отдел управления проектами"
INSERT INTO companies.e_divisions (division_name) VALUES ('Отдел управления проектами') RETURNING id;
-- Вставить подразделение "Отдел сетевых технологий"
INSERT INTO companies.e_divisions (division_name) VALUES ('Отдел сетевых технологий') RETURNING id;
-- Вставить подразделение "Отдел систем защиты"
INSERT INTO companies.e_divisions (division_name) VALUES ('Отдел систем защиты') RETURNING id;
