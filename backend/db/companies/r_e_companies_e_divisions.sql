---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Юридическое лицо - Подразделения ЮЛ' (relationship company - division)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE companies.r_e_companies_e_divisions (
  id SERIAL NOT NULL,
  company_id CHAR(12) NOT NULL,
  division_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (company_id, division_id),
      UNIQUE (id),
      FOREIGN KEY (company_id) REFERENCES companies.e_companies(bin),
      FOREIGN KEY (division_id) REFERENCES companies.e_divisions(id)
);
COMMENT ON TABLE company.r_e_companies_e_divisions IS 'R Юридическое лицо - Подразделение ЮЛ';
COMMENT ON COLUMN company.r_e_companies_e_divisions.id IS 'Идентификатор связи';
COMMENT ON COLUMN company.r_e_companies_e_divisions.company_id IS 'Идентификатор юридического лица';
COMMENT ON COLUMN company.r_e_companies_e_divisions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN company.r_e_companies_e_divisions.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM companies.r_e_companies_e_divisions ORDER BY id ASC;
-- Извлечь все связи 'Юридическое лицо - Подразделения' по идентификатору компании
SELECT id, company_id AS "companyID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM companies.r_e_companies_e_divisions WHERE company_id = {companyID} ORDER BY id ASC;
-- Извлечь существующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM companies.r_e_companies_e_divisions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь несуществующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, company_id AS "companyID", division_id AS "divisionID" FROM companies.r_e_companies_e_divisions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Вставить связь 'Юридическое лицо - Подразделение'
INSERT INTO companies.r_e_companies_e_divisions (company_id, division_id) VALUES ({companyID}, {division_ID}) RETURNING id;
-- Обновить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE companies.r_e_companies_e_divisions SET company_id = {companyID}, division_id = {divisionID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE companies.r_e_companies_e_divisions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
