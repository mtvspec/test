---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Сущность 'Юридическое лицо' (entity company) - ok
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ok
CREATE TABLE companies.e_companies (
  id CHAR(12) NOT NULL,
  short_name VARCHAR(100) NOT NULL,
  long_name VARCHAR(300),
  full_name VARCHAR(500),
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
-- ok
COMMENT ON TABLE companies.e_companies IS 'E Юридическое лицо';
COMMENT ON COLUMN companies.e_companies.id IS 'БИН ЮЛ';
COMMENT ON COLUMN companies.e_companies.short_name IS 'Короткое наименование ЮЛ';
COMMENT ON COLUMN companies.e_companies.long_name IS 'Наименование ЮЛ';
COMMENT ON COLUMN companies.e_companies.full_name IS 'Юридическое наименование ЮЛ';
COMMENT ON COLUMN companies.e_companies.is_deleted IS 'Состояние записи';
-- Извлечь все юридические лица - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName", is_deleted AS "isDeleted" FROM companies.e_companies ORDER BY id ASC;
-- Извлечь юридическое лицо по БИН - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName", is_deleted AS "isDeleted" FROM companies.e_companies WHERE id = {id};
-- Извлечь существующие юридические лица - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM companies.e_companies WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь существующее юридическое лицо по БИН - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM companies.e_companies WHERE is_deleted = 'N' AND id = {id};
-- Извлечь все не существующие юридические лица - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM companies.e_companies WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Извлечь не существующее юридическое лицо по БИН -
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM companies.e_companies WHERE is_deleted = 'Y' AND id = {id};
-- Вставить юридическое лицо - ok
INSERT INTO companies.e_companies (id, short_name, long_name, full_name) VALUES ({id}, {shortName}, {longName}, {fullName}) RETURNING id;
-- Обновить юридическое лицо - ok
UPDATE companies.e_companies SET id = {id}, short_name = {shortName}, long_name = {longName}, full_name = {fullName} WHERE id = {id} RETURNING id;
-- Удалить юридическое лицо - ok
UPDATE companies.e_companies SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
-- Восстановить удаленное юридическое лицо - ok
UPDATE companies.e_companies SET is_deleted = 'N' WHERE id = {id} RETURNING id;
-- Вставить юридическое лицо "Казипэкс" - ok
INSERT INTO companies.e_companies (id, short_name, long_name, full_name) VALUES ('871215301100', 'Казимпэкс', 'АО "РЦ "Казимпэкс"', 'Акционерное общество "Республиканский центр "Казимпэкс"') RETURNING id;
-- Вставить юридическое лицо "АТЦ" - ok
INSERT INTO companies.e_companies (id, short_name, long_name, full_name) VALUES ('871215301101', 'АТЦ', 'Штаб АТЦ КНБ РК', 'Штаб Антитеррористического центра Комитета транспортного контроля Республики Казахстан') RETURNING id;
-- Вставить юридическое лицо "КГД" - ok
INSERT INTO companies.e_companies (id, short_name, long_name, full_name) VALUES ('871215301102', 'КГД', 'КГД МФ РК', 'Комитет государственных доходов Министерства финансов Республики Казахстан') RETURNING id;
-- Извлечь юридическое лицо по БИН - '871215301100' - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName", is_deleted AS "isDeleted" FROM companies.e_companies WHERE id = '871215301100';
-- Извлечь существующее юридическое лицо по БИН - '871215301100' - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM companies.e_companies WHERE is_deleted = 'N' AND id = '871215301100';
-- Извлечь не существующее юридическое лицо по БИН - '871215301100' - ok
SELECT id, short_name AS "shortName", long_name AS "longName", full_name AS "fullName" FROM companies.e_companies WHERE is_deleted = 'Y' AND id = '871215301100';
-- Обновить юридическое лицо - '871215301100' - ok
UPDATE companies.e_companies SET id = '871215301100', short_name = 'Казимпэкс', long_name = 'АО "РЦ "Казимпэкс"', full_name = 'Акционерное общество "Республиканский центр "Казимпэкс"' WHERE id = '871215301100' RETURNING id;
