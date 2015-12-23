---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Участники проекта - Проекты - Участники' (projects members)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE open_project.r_e_projects_e_members (
  id SERIAL,
  project_id INTEGER NOT NULL,
  member_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (project_id, member_id),
      UNIQUE (id),
      FOREIGN KEY (project_id) REFERENCES open_project.e_projects(id),
      FOREIGN KEY (member_id) REFERENCES open_project.e_members(id)
);
COMMENT ON TABLE open_project.r_e_projects_e_members IS 'Связь - Участники проекта';
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность "Результаты проектов" #tested #created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Извлечь все результаты проектов
SELECT id, project_id AS "projectID", type_id AS "typeID", result_name AS "resultName", parent_id AS "parentID", author_id AS "authorID", responsible_person_id AS "responsiblePersonID", status_id AS "statusID", is_deleted AS "isDeleted" FROM open_project.e_project_results ORDER BY id ASC;
-- Извлечь результаты проекта по идентификатору проекта
SELECT id, project_id AS "projectID", type_id AS "typeID", result_name AS "resultName", parent_id AS "parentID", author_id AS "authorID", responsible_person_id AS "responsiblePersonID", status_id AS "statusID", is_deleted AS "isDeleted" FROM open_project.e_project_results WHERE project_id = {projectID} ORDER BY id ASC;
-- Вставить результат проекта
INSERT INTO open_project.e_project_results (project_id, type_id, result_name, author_id, responsible_person_id, status_id) VALUES ({projectID}, {typeID}, {resultName}, {authorID}, {responsiblePersonID}, {statusID}) RETURNING id;
-- Вставить дочерний результат проекта
INSERT INTO open_project.e_project_results (project_id, type_id, result_name, parent_id, author_id, responsible_person_id, status_id) VALUES ({projectID}, {typeID}, {resultName}, {parentID}, {authorID}, {responsiblePersonID}, {statusID}) RETURNING id;
-- Обновить результат проекта
UPDATE open_project.e_project_results SET project_id = {projectID}, type_id = {typeID}, result_name = {resultName}, parent_id = {parentID}, author_id = {authorID}, responsible_person_id = {responsiblePersonID}, status_id = {statusID} WHERE id = {id} RETURNING id;
-- Удалить результат проекта
UPDATE open_project.e_project_results SET is_deleted = 'N' WHERE id = {id} RETURNING id;

INSERT INTO projects.e_project_results (project_id, type_id, result_name, author_id, responsible_person_id, status_id) VALUES (1, 1, '"Praetorium"', '871215301496', '871215301496', 1) RETURNING id;

INSERT INTO open_project.e_project_results (project_id, type_id, result_name, parent_id, author_id, responsible_person_id, status_id) VALUES (1, 3, 'Подсистема хранения данных', 1, '871215301496', '871215301496', 1) RETURNING id;



-- Справочник "Тип результата"
-- "Информационная система"
-- "Подсистема"
-- "Модуль"
-- "Функция"
-- "Документ"


-- Связь "Проект - Результаты проекта"
CREATE TABLE open_project.r_e_projects_e_results (
  id SERIAL,
  project_id INTEGER NOT NULL,
  result_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (project_id, result_id),
      UNIQUE (id)
      FOREIGN KEY (project_id) REFERENCES open_project.e_projects(id)
      FOREIGN KEY (result_id) REFERENCES open_project.e_projects_results(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);

INSERT INTO open_project.e_projects_results (project_id, result_id) VALUES ({projectID}, {resultID}) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность "Замечания" #tested #created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE open_project.e_remarks (
  id SERIAL,
  author_id CHAR(12) NOT NULL,
  object_id INTEGER NOT NULL,
  remark_text VARCHAR(4000) NOT NULL,
  responsible_person_id CHAR(12) NOT NULL,
  reg_datetime TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  status_id INTEGER NOT NULL DEFAULT 1,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (remark_text),
      FOREIGN KEY (author_id) REFERENCES fl.e_persons(id),
      FOREIGN KEY (object_id) REFERENCES open_project.e_remarks_objects(id),
      FOREIGN KEY (responsible_person_id) REFERENCES fl.e_persons(id),
      FOREIGN KEY (status_id) REFERENCES dict.remark_status(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- Извлечь все замечания
SELECT id, author_id AS "authorID", object_id AS "objectID", remark_text AS "remarkText", responsible_person_id AS "responsiblePersonID", reg_datetime AS "regDateTime", status_id AS "statusID" FROM open_project.e_remarks ORDER BY id ASC;
-- Вставить замечание
INSERT INTO open_project.e_remarks (author_id, object_id, remark_text, responsible_person_id, status_id) VALUES ({authorID}, {objectID}, {remarkText}, {responsiblePersonID}, {statusID}) RETURNING id;
-- "Замечание к истории изменения условного наименования ОПГ"
INSERT INTO open_project.e_remarks (author_id, object_id, remark_text, responsible_person_id, status_id) VALUES ('871215301496', 1, 'Убрать возможность добавления условного наименования ОПГ', '771122350160', 1) RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник "Статусы замечаний" #tested #created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dict.remark_status (
  id SERIAL,
  status_name VARCHAR(300) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (status_name)
);
-- Извлечь все статусы замечаний
SELECT id, status_name AS "statusName" FROM dict.remark_status ORDER BY id ASC;
-- Вставить статус
INSERT INTO dict.remark_status (status_name) VALUES ({statusName}) RETURNING id;
-- "Новое"
INSERT INTO dict.remark_status (status_name) VALUES ('Новое') RETURNING id;
-- "Принято"
INSERT INTO dict.remark_status (status_name) VALUES ('Принято') RETURNING id;
-- "На устранении"
INSERT INTO dict.remark_status (status_name) VALUES ('На устранении') RETURNING id;
-- "Устранено"
INSERT INTO dict.remark_status (status_name) VALUES ('Устранено') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность "Объект замечаний" #tested #created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE open_project.e_remarks_objects (
  id SERIAL,
  object_name VARCHAR (1000) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (object_name)
);
-- Извлечь все объекты замечаний
SELECT id, object_name AS "objectName" FROM open_project.e_remarks_objects ORDER BY id ASC;
-- Вставить объект замечания
INSERT INTO open_project.e_remarks_objects (object_name) VALUES ({objectName}) RETURNING id;
-- "История изменения условных наименований ОПГ"
INSERT INTO open_project.e_remarks_objects (object_name) VALUES ('История изменения условных наименований ОПГ') RETURNING id;


CREATE TABLE open_project.e_requirements (
  id SERIAL,
  author_id CHAR(12) NOT NULL,
  responsible_person_id CHAR(12) NOT NULL, -- Идентификатор ответственного (физического) лица
  type_id INTEGER NOT NULL,
  requirement_name VARCHAR(300) NOT NULL,
  requirement_description VARCHAR(4000),
  create_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  status_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (author_id) REFERENCES fl.e_persons(id),
      FOREIGN KEY (responsible_person_id) REFERENCES fl.e_persons(id),
      FOREIGN KEY (type_id) REFERENCES dict.requirement_type(id),
      FOREIGN KEY (status_id) REFERENCES dict.requirement_status(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);

CREATE TABLE dict.requirement_type (
  id SERIAL,
  type_name VARCHAR(300) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (type_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);

INSERT INTO dict.requirement_type (type_name) VALUES ({typeName}) RETURNING id;
-- Типы требований
INSERT INTO dict.requirement_type (type_name) VALUES ('Функциональное требование');
INSERT INTO dict.requirement_type (type_name) VALUES ('Нефункциональное требование');
INSERT INTO dict.requirement_type (type_name) VALUES ('Бизнес-требование');
INSERT INTO dict.requirement_type (type_name) VALUES ('Бизнес-правило');
INSERT INTO dict.requirement_type (type_name) VALUES ('Ограничение');
INSERT INTO dict.requirement_type (type_name) VALUES ('Системное требование');
INSERT INTO dict.requirement_type (type_name) VALUES ('Пользовательское требование');
INSERT INTO dict.requirement_type (type_name) VALUES ('Характеристика');
INSERT INTO dict.requirement_type (type_name) VALUES ('Атрибут качества');
INSERT INTO dict.requirement_type (type_name) VALUES ('Требование к внешнему интерфейсу');

-- Справочник "Статусы требований"
CREATE TABLE dict.requirement_status (
  id SERIAL,
  status_name VARCHAR(300) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (status_name)
);

INSERT INTO dict.requirement_status (status_name) VALUES ({statusName}) RETURNING id;
-- Статусы требований
INSERT INTO dict.requirement_status (status_name) VALUES ('Принято');
INSERT INTO dict.requirement_status (status_name) VALUES ('Сформулировано');
INSERT INTO dict.requirement_status (status_name) VALUES ('Согласовано');
INSERT INTO dict.requirement_status (status_name) VALUES ('Утверждено');
INSERT INTO dict.requirement_status (status_name) VALUES ('Реализовано');
INSERT INTO dict.requirement_status (status_name) VALUES ('Протестировано');

INSERT INTO dict.requirement_status (status_name) VALUES ('Отклонено');

-- Сущность "Информационная система"
CREATE TABLE open_project.e_information_systems (
  id SERIAL,
  formal_name CHAR(3) NOT NULL,
  work_name VARCHAR(300) NOT NULL,
  official_name VARCHAR(500),
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (formal_name, work_name, official_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE open_project.e_information_systems IS 'Сущность - Информационная система';
COMMENT ON COLUMN open_project.e_information_systems.id IS 'Идентификатор информационной системы';
COMMENT ON COLUMN open_project.e_information_systems.formal_name IS 'Формальное наименование информационной системы';
COMMENT ON COLUMN open_project.e_information_systems.work_name IS 'Рабочее наименование информационной системы';
COMMENT ON COLUMN open_project.e_information_systems.official_name IS 'Официальное наименование информационной системы';
COMMENT ON COLUMN open_project.e_information_systems.is_deleted IS 'Состояние записи';
-- Сущность "Компонент информационной системы"
CREATE TABLE open_project.e_information_system_components (
  id SERIAL,
  short_name VARCHAR(100),
  long_name VARCHAR(500) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (short_name, long_name),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);

-- Связь "Информационная система - Компоненты информационной системы"
CREATE TABLE open_project.r_e_information_systems_e_components (
  id SERIAL,
  information_system_id INTEGER NOT NULL,
  component_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (information_system_id, component_id),
      UNIQUE (id),
        FOREIGN KEY (information_system_id) REFERENCES open_project.e_information_systems(id),
        FOREIGN KEY (component_id) REFERENCES open_project.e_information_system_components(id)
);

--  Сущность "Функция компонента информационной системы"
CREATE TABLE open_project.e_functions (
  id SERIAL,
  component_id INTEGER NOT NULL,
  function_name VARCHAR(1000) NOT NULL,
  status_id INTEGER NOT NULL,
  author_id CHAR(12) NOT NULL,
  responsible_person_id CHAR(12) NOT NULL, -- Идентификатор ответственного (физического) лица
  status_change_datetime TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (function_name, author_id),
      UNIQUE (id),
      FOREIGN KEY (component_id) REFERENCES open_project.e_information_system_components(id),
      FOREIGN KEY (status_id) REFERENCES dict.function_status(id),
      FOREIGN KEY (author_id) REFERENCES fl.e_persons(id),
      FOREIGN KEY (responsible_person_id) REFERENCES fl.e_persons(id)
);
-- Сущность "Группа функций компонента информационной системы"
CREATE TABLE open_project.e_function_groups (
  id SERIAL,
  group_name VARCHAR(300) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N'
    PRIMARY KEY (id),
    UNIQUE (group_name),
    FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- Связь "Группа функций - Функции компонента информационной системы"
CREATE TABLE open_project.r_e_function_groups_e_functions (
  id SERIAL,
  group_id INTEGER NOT NULL,
  function_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (group_id, function_id),
      UNIQUE (id),
      FOREIGN KEY (group_id) REFERENCES open_project.e_function_groups(id),
      FOREIGN KEY (function_id) REFERENCES open_project.e_functions(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
