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
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR,
    age INT,
    PRIMARY KEY(id)
);

CREATE TABLE species(
     id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR,
    PRIMARY KEY(id)
);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN  species_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species(id)
ON DELETE CASCADE;

ALTER TABLE animals ADD COLUMN  owners_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_owners
FOREIGN KEY (owners_id)
REFERENCES owners(id)
ON DELETE CASCADE;

-- Phase 4

CREATE TABLE vets (
      id INT GENERATED ALWAYS AS IDENTITY,
      name VARCHAR,
      age INT,
      date_of_graduation DATE,
      PRIMARY KEY (id)
);

CREATE TABLE specializations(
 id INT GENERATED ALWAYS AS IDENTITY,
 vet_id INT,
 specie_id INT
);
ALTER TABLE specializations ADD CONSTRAINT fk_vets
FOREIGN KEY (vet_id)
REFERENCES vets(id)
ON DELETE CASCADE;
ALTER TABLE specializations ADD CONSTRAINT fk_species
FOREIGN KEY (specie_id)
REFERENCES species(id)
ON DELETE CASCADE;

CREATE TABLE visits(
 id INT GENERATED ALWAYS AS IDENTITY,
 vet_id INT,
 animal_id INT,
 date_of_visit DATE
);

ALTER TABLE visits ADD CONSTRAINT fk_vets
FOREIGN KEY (vet_id)
REFERENCES vets(id)
ON DELETE CASCADE;
ALTER TABLE visits ADD CONSTRAINT fk_animals
FOREIGN KEY (animal_id)
REFERENCES animals(id)
ON DELETE CASCADE;