# Сущность 'Физические лица'
CREATE TABLE e_persons (
  iin NUMERIC[12,0] NOT NULL, -- Необходимо реализовать проверку ИИН по маске на стороне бакэнда и фронтэнда
  last_name VARCHAR(300) NOT NULL,
  first_name VARCHAR(300) NOT NULL,
  middle_name VARCHAR(300),
  dob DATE NOT NULL,
  gender_id INTEGER NOT NULL,
  PRIMARY KEY (iin),
  FOREIGN KEY (gender_id) REFERENCES dict.d_genders(id)
);
# Сущность 'Юридические лица'
CREATE TABLE e_companies (
  bin NUMERIC[12,0] NOT NULL, -- Необходимо реализовать проверку БИН по маске на стороне бакэнда и фронтэнда
  company_name VARCHAR(500) NOT NULL,
  PRIMARY KEY (bin),
  UNIQUE (company_name)
);
# Сущность 'Должность'
CREATE TABLE e_positions (
  id SERIAL,
  position_name VARCHAR(500) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (position_name)
);
# Сущность 'Подразделения юридических лиц'
CREATE TABLE e_divisions (
  id SERIAL,
  company_id NUMERIC[12,0] NOT NULL,
  division_name VARCHAR(400) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (division_name),
  FOREIGN KEY (company_id) REFERENCES e_companies(bin)
);
# Справочники
CREATE SCHEMA dict;
# Справочник 'Пол физического лица'
CREATE TABLE dict.d_genders (
  id SERIAL,
  gender_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (gender_name),
  CHECK (id IN (0,1))
);