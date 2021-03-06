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
CREATE SCHEMA projects; -- ok
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
