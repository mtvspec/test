---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Сессия' (entity session) #tested
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE users.e_sessions (
  id SERIAL NOT NULL,
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  open_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT LOCALTIMESTAMP,
  close_date TIMESTAMP WITH TIME ZONE,
  status_id CHAR(1) NOT NULL DEFAULT 'O',
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users.e_users(id),
    FOREIGN KEY (role_id) REFERENCES users.e_roles(id),
    FOREIGN KEY (status_id) REFERENCES users.d_session_status(id)
);
-- ok
COMMENT ON TABLE users.e_sessions IS 'E Сессия';
COMMENT ON COLUMN users.e_sessions.id IS 'Идентификатор сессии';
COMMENT ON COLUMN users.e_sessions.user_id IS 'Идентификатор пользователя';
COMMENT ON COLUMN users.e_sessions.role_id IS 'Идентификатор роли';
COMMENT ON COLUMN users.e_sessions.open_date IS 'Дата и время открытия сессии';
COMMENT ON COLUMN users.e_sessions.close_date IS 'Дата и время закрытия сессии';
COMMENT ON COLUMN users.e_sessions.status_id IS 'Идентификатор состояния сессии';
-- Извлечь все сессии
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM users.e_sessions ORDER BY id ASC;
-- Извлечь сессию по идентификатору сессии
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM users.e_sessions WHERE id = {id};
-- Извлечь сессии по идентификатору пользователя
SELECT id, user_id AS "userID", role_id AS "roleID", open_date AS "openDate", close_date AS "closeDate", status FROM users.e_sessions WHERE user_id = {userID};
-- Вставить сессию
INSERT INTO users.e_sessions (user_id, role_id) VALUES ({userID}, {roleID}) RETURNING id;
-- Закрыть сессию
UPDATE users.e_sessions SET status_id = 'C', close_date = 'now()' WHERE id = {id};
