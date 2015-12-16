----------------------------------------------------------------------------------------------------
-- Сущность 'Проект' (entity project)
----------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE projects.e_projects (
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
      FOREIGN KEY (customer_id) REFERENCES organizations.e_organizations(id),
      FOREIGN KEY (manager_id) REFERENCES persons.e_persons(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE projects.e_projects IS 'E Проект';
COMMENT ON COLUMN projects.e_projects.id IS 'Идентификатор проекта';
COMMENT ON COLUMN projects.e_projects.customer_id IS 'Идентификатор заказчика проекта';
COMMENT ON COLUMN projects.e_projects.project_formal_name IS 'Формальное наименование проекта';
COMMENT ON COLUMN projects.e_projects.project_work_name IS 'Рабочее наименование проекта';
COMMENT ON COLUMN projects.e_projects.project_official_name IS 'Официальное наименование проекта';
COMMENT ON COLUMN projects.e_projects.start_date IS 'Дата начала проекта';
COMMENT ON COLUMN projects.e_projects.end_date IS 'Дата завершения проекта';
COMMENT ON COLUMN projects.e_projects.budget IS 'Бюджет проекта';
COMMENT ON COLUMN projects.e_projects.manager_id IS 'Идентификатор руководителя проекта';
COMMENT ON COLUMN projects.e_projects.is_deleted IS 'Состояние записи';
-- Извлечь все проекты
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget AS "projectBudget", manager_id AS "projectManagerID", is_deleted AS "isDeleted" FROM projects.e_projects ORDER BY id ASC;
-- Извлечь существующие проекты
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM projects.e_projects WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь несуществующие проекты
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM projects.e_projects WHERE is_deleted = 'Y' ORDER BY id ASC;
--  Извлечь проект по идентификатору проекта
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM projects.e_projects WHERE id = {id};
-- Извлечь существующий проект по идентификатору проекта
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM projects.e_projects WHERE is_deleted = 'Y' AND id = {id};
-- Извлечь несуществующий проект по идентификатору проекта
SELECT id, customer_id AS "projectCustomerID", project_formal_name AS "projectFormalName", project_work_name AS "projectWorkName", project_official_name AS "projectOfficialName", start_date AS "projectStartDate", end_date AS "projectEndDate", budget, manager_id AS "managerID" FROM projects.e_projects WHERE is_deleted = 'Y' AND id = {id};
-- Вставить проект
INSERT INTO projects.e_projects (customer_id, project_formal_name, project_work_name, project_official_name, start_date, end_date, budget, manager_id) VALUES ({projectCustomerID}, {projectFormalName}, {projectWorkName}, {projectOfficialName}, {projectStartDate}, {projectEndDate}, {projectBudget}, {projectManagerID}) RETURNING id;
-- Обновить проект по идентификатору проекта
UPDATE projects.e_projects SET customer_id = {projectCustomerID}, project_formal_name = {projectFormalName}, project_work_name = {projectWorkName}, project_official_name = {projectOfficialName}, start_date = {projectStartDate}, end_date = {projectEndDate}, budget = {projectBudget}, manager_id = {projectManagerID} WHERE id = {id} RETURNING id;
-- Удалить проект по идентификатору проекта
DELETE FROM projects.e_projects WHERE id = {id};
-- Praetorium
INSERT INTO projects.e_projects (customer_id, project_formal_name, project_work_name, project_official_name, start_date, end_date, budget, manager_id) VALUES ('871215301101', 'PR', 'Praetorium', 'Информационная система "Praetorium"', '2015-01-01', '2015-12-31', 150000000, '890402350620') RETURNING id;
-- ЕИАС
INSERT INTO projects.e_projects (customer_id, project_formal_name, project_work_name, project_official_name, start_date, end_date, budget, manager_id) VALUES ('871215301102', 'ES', 'ЕИАС', 'Программно-аппаратный комплекс Единой информационно-аналитической системы', '2015-01-01', '2015-12-31', 120000000, '890402350620') RETURNING id;
