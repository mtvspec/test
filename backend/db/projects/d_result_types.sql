---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник "Тип результата" #tested #created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE projects.d_result_types (
  id SERIAL,
  parent_id INTEGER,
  type_name VARCHAR(300) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (type_name),
      FOREIGN KEY (parent_id) REFERENCES projects.e_result_types(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE projects.e_result_types IS 'Справочник - Тип результата';
COMMENT ON COLUMN projects.e_result_types.id IS 'Идентификатор типа результата';
COMMENT ON COLUMN projects.e_result_types.parent_id IS 'Идентификатор родительского типа результата';
COMMENT ON COLUMN projects.e_result_types.type_name IS 'Наименование типа результата';
COMMENT ON COLUMN projects.e_result_types.is_deleted IS 'Состояние записи';
-- Извлечь все типы требований
SELECT id, parent_id AS "parentID", type_name AS "typeName", is_deleted AS "isDeleted" FROM projects.d_result_types ORDER BY id;
-- Извлечь тип требования по идентификатору
SELECT id, parent_id AS "parentID", type_name AS "typeName", is_deleted AS "isDeleted" FROM projects.d_result_types WHERE id = {id};
-- Извлечь существующие типы требований
SELECT id, parent_id AS "parentID", type_name AS "typeName" FROM projects.d_result_types WHERE is_deleted = 'N' ORDER BY id;
-- Извлечь существующий тип требования по идентификатору типа требования
SELECT id, parent_id AS "parentID", type_name AS "typeName" FROM projects.d_result_types WHERE is_deleted = 'N' AND id = {id};
-- Извлечь несуществующие типы требований
SELECT id, parent_id AS "parentID", type_name AS "typeName" FROM projects.d_result_types WHERE is_deleted = 'Y' ORDER BY id;
-- Извлечь несуществующий тип требования по идентификатору типа требования
SELECT id, parent_id AS "parentID", type_name AS "typeName" FROM projects.d_result_types WHERE is_deleted = 'Y' AND id = {id};
-- Втавить тип требования
INSERT INTO projects.d_result_types (parent_id, type_name) VALUES ({parentID}, {typeName}) RETURNING id;
-- Обновить тип требования
UPDATE projects.d_result_types SET parent_id = {parentID}, type_name = {typeName} WHERE id = {id} RETURNING id;
-- Удалить тип требования
UPDATE projects.d_result_types SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить удаленный тип требования
UPDATE projects.d_result_types SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Результаты проекта
-- "Информационная система"
INSERT INTO projects.d_result_types (type_name) VALUES ('Информационная система'); -- 1
-- "Проектаная документация"
INSERT INTO projects.d_result_types (type_name) VALUES ('Проектная документация');
-- "Другое"
INSERT INTO projects.d_result_types (type_name) VALUES ('Другое');
-- "Виды обеспечений информационной системы"
INSERT INTO projects.d_result_types (parent_id, type_name) VALUES (1, 'Аппаратное обеспечение'); -- 2
-- На каком аппаратном обеспечении должна работать информационная система?
INSERT INTO projects.d_result_types (parent_id, type_name) VALUES (1, 'Программное обеспечение'); -- 3
-- На каком системном программном обеспечении должна работать информационная система и какое программное обеспечение необходимо разработать?
INSERT INTO projects.d_result_types (parent_id, type_name) VALUES (1, 'Правовое обеспечение'); -- 4
-- Что обеспечивает юридически работу информационной системы?
INSERT INTO projects.d_result_types (parent_id, type_name) VALUES (1, 'Методическое обеспечение'); -- 5
-- Какими методическими материалами необходимо обеспечить кадровое обеспечение информационной системы?
-- "Методическое обеспечение"
INSERT INTO projects.d_result_types (parent_id, type_name) VALUES (5, 'Руководство администратора'); -- 6
INSERT INTO projects.d_result_types (parent_id, type_name) VALUES (5, 'Руководство пользователя'); -- 7
--
INSERT INTO projects.d_result_types (type_name) VALUES ('Информационное обеспечение');
-- Какая информация и в каком виде необходима для обеспечения работы информационной системы?
INSERT INTO projects.d_result_types (type_name) VALUES ('Лингвистическое обеспечение');
-- Какие языки должна поддерживать информационная система?
INSERT INTO projects.d_result_types (type_name) VALUES ('Кадровое обеспечение');
-- Кто должен иметь возможность работать в информационной системе?
INSERT INTO projects.d_result_types (type_name) VALUES ('Организационное обеспечение');
-- Что должно сделать руководство для обеспечения работы кадрового обеспечения в информационной системе?

INSERT INTO projects.d_result_types (type_name) VALUES ('Проектная документация');
-- Проектная документация
INSERT INTO projects.d_result_types (type_name) VALUES ('Концепция');
INSERT INTO projects.d_result_types (type_name) VALUES ('Технико-экономическое обоснование');
INSERT INTO projects.d_result_types (type_name) VALUES ('Техно-рабочий проект');
INSERT INTO projects.d_result_types (type_name) VALUES ('Техническая спецификация');
INSERT INTO projects.d_result_types (type_name) VALUES ('Техническое задание');
INSERT INTO projects.d_result_types (type_name) VALUES ('Программа и методика испытаний');
INSERT INTO projects.d_result_types (type_name) VALUES ('Спецификация требований к ПО');
INSERT INTO projects.d_result_types (type_name) VALUES ('Описание программы');


-- Справочник "Виды обеспечений ИС"
-- "Аппаратное обеспечение"
-- "Программное обеспечение"
-- "Правовое обеспечение"
-- "Методическое обеспечение"
-- "Информационное обеспечение"
-- "Лингвистическое обеспечение"
-- "Кадровое обеспечение"
-- "Организационное обеспечение"
