/* Database schema to keep the structure of entire database. */
CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name varchar(250),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
    PRIMARY KEY(id)
);

/*Phase 2*/

ALTER TABLE animals  ADD species varchar;

/*Phase 3*/

CREATE TABLE owners(
    id  SERIAL PRIMARY KEY,
    full_name VARCHAR,
    age INT
);

CREATE TABLE species(
    id  SERIAL PRIMARY KEY,
    name VARCHAR
);
