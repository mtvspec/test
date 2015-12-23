----------------------------------------------------------------------------------------------------
-- Сущность "Результаты проектов"
----------------------------------------------------------------------------------------------------
-- ok
 CREATE TABLE projects.e_project_results (
  id SERIAL,
  project_id INTEGER NOT NULL,
  type_id INTEGER NOT NULL, -- идентификатор типа результата
  result_name VARCHAR(500),
  parent_id INTEGER,
  author_id CHAR(12),
  responsible_person_id CHAR(12), -- идентификатор ответственного (физического) лица
  status_id INTEGER,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (project_id) REFERENCES projects.e_projects(id),
      FOREIGN KEY (type_id) REFERENCES projects.d_result_types(id),
      FOREIGN KEY (parent_id) REFERENCES projects.e_project_results(id),
      FOREIGN KEY (author_id) REFERENCES persons.e_persons(id),
      FOREIGN KEY (responsible_person_id) REFERENCES persons.e_persons(id),
      FOREIGN KEY (status_id) REFERENCES projects.d_result_statuses(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE projects.e_project_results IS 'E - Результаты проектов';
