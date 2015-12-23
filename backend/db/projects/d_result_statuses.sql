----------------------------------------------------------------------------------------------------
-- Справочник "Статус результата проекта"
----------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE projects.d_result_statuses (
  id SERIAL,
  result_status_name VARCHAR(500) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (result_status_name)
);
-- ok
COMMENT ON TABLE projects.d_result_statuses IS 'D Справочник - Статусы результата проекта';
COMMENT ON COLUMN projects.d_result_statuses.id IS 'Идентификатор статуса результата проекта';
COMMENT ON COLUMN projects.d_result_statuses.result_status_name IS 'Наименование статуса результата проекта';

SELECT id, result_status_name AS "resultStatusName" FROM projects.d_result_statuses ORDER BY id ASC;

INSERT INTO projects.d_result_statuses (result_status_name) VALUES ('Принят');

-- "Принят"
-- "Проектируется"
-- "Спроектирован"
-- "На реализации"
-- "Реализован"
-- "На тестировании"
-- "Протестирован"
-- "На отладке"
-- "Отлажен"
-- "Внедряется"
-- "Внедрен"
-- "На списании"
-- "Списан"
-- "Требуется уточнение"
-- "Отклонен"
