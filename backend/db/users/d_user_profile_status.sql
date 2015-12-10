---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Состояние учетной записи' (dictionary user profile condition)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE users.d_user_profile_status (
  id CHAR(1),
  condition_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (condition_name),
    CHECK (id IN ('N', 'Y'))
);
-- ok
COMMENT ON TABLE users.d_user_profile_status IS 'D Состояние учетной записи';
COMMENT ON COLUMN users.d_user_profile_status.id IS 'Идентификатор состояния учетной записи';
COMMENT ON COLUMN users.d_user_profile_status.condition_name IS 'Наименование состояния учетной записи';
-- Вставить справочное значение 'Нет' - ok
INSERT INTO users.d_user_profile_status (id, condition_name) VALUES ('N', 'Нет') RETURNING id;
-- Вставить справочное значение 'Да' - ok
INSERT INTO users.d_user_profile_status (id, condition_name) VALUES ('Y', 'Да') RETURNING id;
