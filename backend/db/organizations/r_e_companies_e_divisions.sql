---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Связь 'Юридическое лицо - Подразделения ЮЛ' (relationship company - division)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE organizations.r_e_organization_e_divisions (
  id SERIAL NOT NULL,
  organization_id CHAR(12) NOT NULL,
  division_id INTEGER NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (company_id, division_id),
      UNIQUE (id),
      FOREIGN KEY (organization_id) REFERENCES organizations.e_organizations(bin),
      FOREIGN KEY (division_id) REFERENCES organizations.e_divisions(id)
);
COMMENT ON TABLE organizations.r_e_organizations_e_divisions IS 'R Юридическое лицо - Подразделение ЮЛ';
COMMENT ON COLUMN organizations.r_e_organizations_e_divisions.id IS 'Идентификатор связи';
COMMENT ON COLUMN organizations.r_e_organizations_e_divisions.organization_id IS 'Идентификатор юридического лица';
COMMENT ON COLUMN organizations.r_e_organizations_e_divisions.division_id IS 'Идентификатор подразделения ЮЛ';
COMMENT ON COLUMN organizations.r_e_organizations_e_divisions.is_deleted IS 'Состояние записи';
-- Извлечь все связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, organization_id AS "organizationID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM organizations.r_e_organizations_e_divisions ORDER BY id ASC;
-- Извлечь все связи 'Юридическое лицо - Подразделения' по идентификатору компании
SELECT id, organization_id AS "organizationID", division_id AS "divisionID", is_deleted AS "isDeleted" FROM organizations.r_e_organizations_e_divisions WHERE organization_id = {organizationID} ORDER BY id ASC;
-- Извлечь существующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, organization_id AS "organizationID", division_id AS "divisionID" FROM organizations.r_e_organizations_e_divisions WHERE is_deleted = 'N' ORDER BY id ASC;
-- Извлечь несуществующие связи 'Юридическое лицо - Подразделения ЮЛ'
SELECT id, organization_id AS "organizationID", division_id AS "divisionID" FROM organizations.r_e_organizations_e_divisions WHERE is_deleted = 'Y' ORDER BY id ASC;
-- Вставить связь 'Юридическое лицо - Подразделение'
INSERT INTO organizations.r_e_organizations_e_divisions (organization_id, division_id) VALUES ({organizationID}, {division_ID}) RETURNING id;
-- Обновить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE organizations.r_e_organizations_e_divisions SET organization_id = {organizationID}, division_id = {divisionID} WHERE id = {id} RETURNING id;
-- Удалить связь 'Юридическое лицо - Подразделение' по идентификатору связи
UPDATE organizations.r_e_organizations_e_divisions SET is_deleted = 'Y' WHERE id = {id} RETURNING id;
