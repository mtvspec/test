--=======================================================================================================================================================================================================================================================================--
-- Справочники # tested # created: work-dev
--=======================================================================================================================================================================================================================================================================--
CREATE SCHEMA dict;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Удален? (Нет/Да)' (dictionary is_deleted) # tested # created: work-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dict.is_deleted (
  id CHAR(1),
  condition_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (condition_name),
    CHECK (id IN ('N', 'Y'))
);
-- # tested # created: work-dev
COMMENT ON TABLE dict.is_deleted IS 'Справочник - Состояние записи';
COMMENT ON COLUMN dict.is_deleted.id IS 'Идентификатор состояния записи';
COMMENT ON COLUMN dict.is_deleted.condition_name IS 'Наименование состояния записи';
-- Извлечь значения справочника 'Удален (Нет/Да)' # tested
SELECT id, condition_name AS "conditionName" FROM dict.is_deleted ORDER BY id ASC;
-- Извлечь значение справочника 'Удален (Нет/Да)' по идентификатору значения справочника # tested
SELECT id, condition_name AS "conditionName" FROM dict.is_deleted WHERE id = {id};
-- Вставить справочное значение 'Нет' # tested # created: work-dev
INSERT INTO dict.is_deleted (id, condition_name) VALUES ('N', 'Нет') RETURNING id;
-- Вставить справочное значение 'Да' # tested # created: work-dev
INSERT INTO dict.is_deleted (id, condition_name) VALUES ('Y', 'Да') RETURNING id;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Справочник 'Тип манипуляции над данными' (dictionary manipulation_type) # tested # created: work-dev, home-dev
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dict.manipulation_type (
  id CHAR(6) NOT NULL,
  manipulation_type_name VARCHAR(100) NOT NULL,
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      UNIQUE (manipulation_type_name),
      CHECK (is_deleted IN ('N', 'Y'))
);
-- # tested # created: work-dev, home-dev
COMMENT ON TABLE dict.manipulation_type IS 'Справочник - Состояние записи';
COMMENT ON COLUMN dict.manipulation_type.id IS 'Идентификатор состояния записи';
COMMENT ON COLUMN dict.manipulation_type.manipulation_type_name IS 'Наименование состояния записи';
COMMENT ON COLUMN dict.manipulation_type.is_deleted IS 'Состояние записи';
-- Вставить справочное значение 'SELECT' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('SELECT', 'SELECT');
-- Вставить справочное значение 'INSERT' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('INSERT', 'INSERT');
-- Вставить справочное значение 'UPDATE' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('UPDATE', 'UPDATE');
-- Вставить справочное значение 'DELETE' # tested # work-dev: created
INSERT INTO dict.manipulation_type (id, manipulation_type_name) VALUES ('DELETE', 'DELETE');
