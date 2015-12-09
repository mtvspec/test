--=======================================================================================================================================================================================================================================================================--
-- Проекты
--=======================================================================================================================================================================================================================================================================--
-- structure:
-- schema 'project'
-- entity 'e_projects'
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- dependencies:
-- schema 'dict':
-- dictionary 'is_deleted'
-- schema 'company':
-- entity 'company'
-- schema 'person':
-- entity 'person'
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Схема "Проект" (schema project)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA project;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Проект' (entity project)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
CREATE TABLE project.e_projects (
  id SERIAL,
  customer_id CHAR(12),
  project_formal_name CHAR(2),
  project_work_name VARCHAR(300) NOT NULL,
  project_official_name VARCHAR(500),
  start_date DATE,
  end_date DATE,
  budget NUMERIC,
  manager_id CHAR(12),
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (id, project_formal_name, project_work_name, project_official_name),
      FOREIGN KEY (customer_id) REFERENCES company.e_companies(id),
      FOREIGN KEY (manager_id) REFERENCES person.e_persons(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
--
COMMENT ON TABLE project.e_projects IS 'E Проект';
COMMENT ON COLUMN project.e_projects.id IS 'Идентификатор проекта';
COMMENT ON COLUMN project.e_projects.customer_id IS 'Идентификатор заказчика проекта';
COMMENT ON COLUMN project.e_projects.project_formal_name IS 'Формальное наименование проекта';
COMMENT ON COLUMN project.e_projects.project_work_name IS 'Рабочее наименование проекта';
COMMENT ON COLUMN project.e_projects.project_official_name IS 'Официальное наименование проекта';
COMMENT ON COLUMN project.e_projects.start_date IS 'Дата начала проекта';
COMMENT ON COLUMN project.e_projects.end_date IS 'Дата завершения проекта';
COMMENT ON COLUMN project.e_projects.budget IS 'Бюджет проекта';
COMMENT ON COLUMN project.e_projects.manager_id IS 'Идентификатор руководителя проекта';
COMMENT ON COLUMN project.e_projects.is_deleted IS 'Состояние записи';
-- Извлечь все проекты
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget AS "projectBudget", manager_id AS "projectManagerID", is_deleted AS "isDeleted" FROM project.e_projects ORDER BY id ASC;
-- Извлечь существующие проекты
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM project.e_projects WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь несуществующие проекты
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM project.e_projects WHERE is_deleted = 'Y' ORDER BY id ASC;
--  Извлечь проект по идентификатору проекта
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM project.e_projects WHERE id = {id};
-- Извлечь существующий проект по идентификатору проекта
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM project.e_projects WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь несуществующий проект по идентификатору проекта
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM project.e_projects WHERE is_deleted = 'Y' AND id = {id};
-- Вставить проект
INSERT INTO project.e_projects (customer_id, project_formal_name, project_work_name, project_official_name, start_date, end_date, budget, manager_id) VALUES ({projectCustomerID}, {projectFormalName}, {projectWorkName}, {projectOfficialName}, {projectStartDate}, {projectEndDate}, {projectBudget}, {projectManagerID}) RETURNING id;
-- Обновить проект по идентификатору проекта
UPDATE project.e_projects SET customer_id = {projectCustomerID}, project_formal_name = {projectFormalName}, project_work_name = {projectWorkName}, project_official_name = {projectOfficialName}, start_date = {projectStartDate}, end_date = {projectEndDate}, budget = {projectBudget}, manager_id = {projectManagerID} WHERE id = {id} RETURNING id;
-- Удалить проект по идентификатору проекта
DELETE FROM project.e_projects WHERE id = {id};
-- Praetorium
INSERT INTO project.e_projects (customer_id, project_formal_name, project_work_name, project_official_name, start_date, end_date, budget, manager_id) VALUES ('871215301101', 'PR', 'Praetorium', 'Информационная система "Praetorium"', '2015-01-01', '2015-12-31', 150000000, '871215301496') RETURNING id;
-- ЕИАС
INSERT INTO project.e_projects (customer_id, project_formal_name, project_work_name, project_official_name, start_date, end_date, budget, manager_id) VALUES ('871215301102', 'ES', 'ЕИАС', 'Программно-аппаратный комплекс Единой информационно-аналитической системы', '2015-01-01', '2015-12-31', 120000000, '871215301496') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Инициация проекта' (project init)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO Найти ответы на вопросы:
-- 1) Что является основанием для инициации проекта?
-- 2) Без чего нельзя инициировать проект?
-- Возможные ответы:
-- без назначенного руководителя проекта
-- без утвержденной проектной команды
-- без утвержденной заказчиком концепции результата проекта
-- без утвержденной рабочей группы проекта со стороны заказчика
-- без четкого понимания участниками проекта проблем решаемых результатом проекта
CREATE TABLE project.e_init (
  id SERIAL,
  project_id INTEGER NOT NULL,
  init_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (project_id),
      FOREIGN KEY (project_id) REFERENCES open_project.e_projects(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE open_project.e_project_init IS 'E Открытие проекта';
COMMENT ON COLUMN open_project.e_project_init.project_id IS 'Идентификатор проекта';
COMMENT ON COLUMN open_project.e_project_init.init_date IS 'Состояние записи';
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Закрытие проекта' (project close)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO Найти ответы на вопросы:
-- 1) Что является основанием для закрытия проекта?
CREATE TABLE project.e_close (
  id SERIAL,
  project_id INTEGER NOT NULL,
  close_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (project_id) REFERENCES project.e_projects(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
COMMENT ON TABLE project.e_project_close IS 'E Завершение проекта';
COMMENT ON COLUMN project.e_project_close.project_id IS 'Идентификатор проекта';
COMMENT ON COLUMN project.e_project_close.close_date IS 'Дата закрытия проекта';
COMMENT ON COLUMN project.e_project_close.is_deleted IS 'Состояние записи';
