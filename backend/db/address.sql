--=======================================================================================================================================================================================================================================================================--
CREATE SCHEMA address;
--=======================================================================================================================================================================================================================================================================--
CREATE TABLE address.e_country (
  id SERIAL,
  country_name VARCHAR(300) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (country_name)
);

CREATE TABLE address.e_city (
  id SERIAL,
  city_name VARCHAR(300) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (city_name)
);

CREATE TABLE address.r_e_countries_e_cities (
  id SERIAL,
  country_id INTEGER,
  city_id INTEGER,
    PRIMARY KEY (country_id, city_id),
    UNIQUE (id),
    FOREIGN KEY (country_id) REFERENCES address.e_country(id),
    FOREIGN KEY (city_id) REFERENCES address.e_city(id)
);

CREATE TABLE address.e_distinct (
  id SERIAL,
  distinct_name VARCHAR(1000) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (distinct_name)
);

CREATE TABLE address.r_e_city_e_distinct (
  id SERIAL NOT NULL,
  city_id INTEGER,
  distinct_id INTEGER,
    PRIMARY KEY (city_id, distinct_id),
    UNIQUE (id),
    FOREIGN KEY (city_id) REFERENCES address.e_city(id),
    FOREIGN KEY (distinct_id) REFERENCES address.e_distinct(id)
);

CREATE TABLE address.e_street (
  id SERIAL,
  street_name VARCHAR(500) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (street_name)
);

CREATE TABLE address.r_e_distinct_e_street (
  id SERIAL,
  distinct_id INTEGER,
  street_id INTEGER,
    PRIMARY KEY (distinct_id, street_id),
    UNIQUE (id),
    FOREIGN KEY (distinct_id) REFERENCES address.e_distinct(id),
    FOREIGN KEY (street_id) REFERENCES address.e_street(id)
);

CREATE TABLE address.e_house (
  id SERIAL,
  house VARCHAR(10),
    PRIMARY KEY (id),
    UNIQUE (house)
);

CREATE TABLE address.r_e_street_e_house (
  id SERIAL,
  street_id INTEGER,
  house_id INTEGER,
    PRIMARY KEY (street_id, house_id),
    UNIQUE (id),
    FOREIGN KEY (street_id) REFERENCES address.e_street(id),
    FOREIGN KEY (house_id) REFERENCES address.e_house(id)
);

CREATE TABLE address.e_flat (
  id SERIAL,
  flat INTEGER(10) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (flat)
);

CREATE TABLE address.r_e_house_e_flat (
  id SERIAL,
  house_id INTEGER,
  flat_id INTEGER,
    PRIMARY KEY (house_id, flat_id),
    UNIQUE (id),
    FOREIGN KEY (house_id) REFERENCES address.e_house(id),
    FOREIGN KEY (flat_id) REFERENCES address._e_flat(id)
);

CREATE TABLE address.e_address (
  id SERIAL,
  country_id INTEGER NOT NULL,
  city_id INTEGER NOT NULL,
  distinct_id INTEGER,
  street_id INTEGER NOT NULL,
  house_id INTEGER NOT NULL,
  flat_id INTEGER,
    PRIMARY KEY (country_id, city_id, distinct_id, street_id, house_id, flat_id),
    UNIQUE (id),
    FOREIGN KEY (country_id) REFERENCES address.e_country(id),
    FOREIGN KEY (city_id) REFERENCES address.e_city(id),
    FOREIGN KEY (distinct_id) REFERENCES address.e_distinct(id),
    FOREIGN KEY (street_id) REFERENCES address.e_street(id),
    FOREIGN KEY (house_id) REFERENCES address.e_house(id),
    FOREIGN KEY (flat_id) REFERENCES address.e_flat(id)
);

-- Сущность "Результаты проектов"
CREATE TABLE open_project.e_projects_results (
  id SERIAL,
  type_id INTEGER NOT NULL, -- идентификатор типа результата
  responsible_person_id CHAR(12) NOT NULL, -- идентификатор ответственного (физического) лица
    is_deleted CHAR(1) NOT NULL DEFAULT 'N',
      PRIMARY KEY (id),
      FOREIGN KEY (responsible_person_id) REFERENCES fl.e_persons(id),
      FOREIGN KEY (type_id) REFERENCES dict.result_type(id),
      FOREIGN KEY (is_deleted) REFERENCES dict.is_deleted(id)
);
