---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Репозиторий
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE conf.objects (
  id SERIAL,
  schema_name VARCHAR(500) NOT NULL,
  table_name VARCHAR(500) NOT NULL,
  column_name VARCHAR(500) NOT NULL,
  column_data_type VARCHAR(500) NOT NULL,
  column_length INTEGER NOT NULL,
  column_default_value VARCHAR(500) NOT NULL,
  referenced_schema_name VARCHAR(500),
  referenced_table_name VARCHAR(500),
  referenced_column_name VARCHAR(500),
  created CHAR(1) NOT NULL DEFAULT 'N',
    PRIMARY KEY (schema_name, table_name, column_name),
    UNIQUE (id, schema_name, table_name)
);
