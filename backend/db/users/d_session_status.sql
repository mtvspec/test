---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Состояние сессии' (dictionary session condition)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE users.d_session_status (
  id CHAR(1),
  condition_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (condition_name),
    CHECK (id IN ('O', 'C'))
);
-- ok
COMMENT ON TABLE users.d_session_status IS 'D Состояние сессии';
COMMENT ON COLUMN users.d_session_status.id IS 'Идентификатор состояния сессии';
COMMENT ON COLUMN users.d_session_status.condition_name IS 'Наименование состояния сессии';
-- Вставить справочное значение 'Открыта' - ok
INSERT INTO users.d_session_status (id, condition_name) VALUES ('O', 'Открыта') RETURNING id;
-- Вставить справочное значение 'Закрыта' - ok
INSERT INTO users.d_session_status (id, condition_name) VALUES ('C', 'Закрыта') RETURNING id;
