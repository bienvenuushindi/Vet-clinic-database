/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT name from animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name from animals WHERE neutered='t' AND escape_attempts < 3;
SELECT date_of_birth from animals WHERE name='Agumon' OR name='Pikachu';
SELECT name,escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * from animals WHERE neutered='t';
SELECT * from animals WHERE name !='Gabumon';
SELECT * from animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*Phase 2*/

BEGIN; UPDATE animals SET species='unspecified'; ROLLBACK;

BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species='pokemon' WHERE species='';
COMMIT;


BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK ;
SELECT * FROM animals;


BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT deleteAfterFirstJanuary;
UPDATE animals SET weight_kg = (weight_kg * -1);
ROLLBACK TO SAVEPOINT deleteAfterFirstJanuary;
UPDATE animals SET weight_kg = (weight_kg * -1) WHERE weight_kg < 0;
COMMIT;


SELECT count(*) FROM animals;
SELECT count(*) FROM animals WHERE escape_attempts=0;
SELECT SUM(weight_kg) / count(weight_kg) as AVERAGE_WEIGHT FROM animals;
SELECT MAX(escape_attempts) FROM animals;
SELECT MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT AVG(escape_attempts) as AVERAGE_BY_SPECIES FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

/*Phase 3*/

