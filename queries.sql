/*-- Queries that provide answers to the questions from all projects. --*/

SELECT *
from animals
WHERE name LIKE '%mon';
SELECT name
from animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name
from animals
WHERE neutered = 't'
  AND escape_attempts < 3;
SELECT date_of_birth
from animals
WHERE name = 'Agumon'
   OR name = 'Pikachu';
SELECT name, escape_attempts
from animals
WHERE weight_kg > 10.5;
SELECT *
from animals
WHERE neutered = 't';
SELECT *
from animals
WHERE name != 'Gabumon';
SELECT *
from animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*-- Phase 2 --*/

BEGIN;
UPDATE animals
SET species='unspecified';
ROLLBACK;

BEGIN;
UPDATE animals
SET species='digimon'
WHERE name LIKE '%mon';
UPDATE animals
SET species='pokemon'
WHERE species = '';
COMMIT;


BEGIN;
DELETE
FROM animals;
SELECT *
FROM animals;
ROLLBACK;
SELECT *
FROM animals;


BEGIN;
DELETE
FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT deleteAfterFirstJanuary;
UPDATE animals
SET weight_kg = (weight_kg * -1);
ROLLBACK TO SAVEPOINT deleteAfterFirstJanuary;
UPDATE animals
SET weight_kg = (weight_kg * -1)
WHERE weight_kg < 0;
COMMIT;


SELECT count(*)
FROM animals;
SELECT count(*)
FROM animals
WHERE escape_attempts = 0;
SELECT SUM(weight_kg) / count(weight_kg) as AVERAGE_WEIGHT
FROM animals;
SELECT MAX(escape_attempts)
FROM animals;
SELECT MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;
SELECT AVG(escape_attempts) as AVERAGE_BY_SPECIES
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- Phase 3
SELECT A.full_name as Owner_name, B.name as Animals_name
FROM owners A
         RIGHT JOIN animals B ON B.owners_id = A.id
WHERE A.full_name = 'Melody Pond';

SELECT A.name as Specy_name, B.*
FROM species A
         RIGHT JOIN animals B ON B.species_id = A.id
WHERE A.name = 'pokemon';

SELECT A.full_name as Owner_name, B.name as Animals_name
FROM owners A
         RIGHT JOIN animals B ON B.owners_id = A.id;

SELECT count(A.*) as Number_of_animals, B.name
FROM animals A
         RIGHT JOIN species B ON A.species_id = B.id
GROUP BY B.name;

SELECT A.full_name as Owner_name, B.*
FROM owners A
         JOIN animals B ON B.owners_id = A.id
WHERE A.full_name = 'Jennifer Orwell'
  AND B.species_id = (SELECT id FROM species WHERE name = 'Digimon');

SELECT A.full_name as Owner_name, B.*
FROM owners A
         JOIN animals B ON B.owners_id = A.id
WHERE A.full_name = 'Dean Winchester'
  AND B.escape_attempts = 0;

SELECT COUNT(*), B.full_name
FROM animals A
         RIGHT JOIN owners B ON A.owners_id = B.id
GROUP BY B.full_name
HAVING COUNT(*) =
       (SELECT MAX(count_results.animals_per_owner)
        FROM (SELECT count(A.*) as animals_per_owner
              FROM animals A
              GROUP BY A.owners_id) as count_results);
