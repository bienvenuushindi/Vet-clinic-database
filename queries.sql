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
-- Phase 4
--     Who was the last animal seen by William Tatcher?
SELECT B.name as vet_name, Anim.name as animal_name, A.date_of_visit as Last_Visit
FROM visits A
         RIGHT JOIN vets B ON A.vet_id = B.id
         RIGHT JOIN animals Anim ON A.vet_id = Anim.id
GROUP BY B.name, A.date_of_visit, animal_name
HAVING MAX(A.date_of_visit) =
       (SELECT MAX(vet_visits.date_of_visit)
        FROM (SELECT * From visits WHERE vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')) as vet_visits);
--     How many different animals did Stephanie Mendez see?
SELECT DISTINCT ON (animal_id) *
FROM (SELECT *
      FROM visits
      WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')) AS specific_vet_visit;
--     List all vets and their specialties, including vets with no specialties.
SELECT VS.name, SP.name
FROM (SELECT V.name, S.specie_id
      FROM vets V
               LEFT JOIN specializations S ON S.vet_id = V.id) as VS
         LEFT JOIN species SP ON VS.specie_id = SP.id;
--     List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT *
FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
  AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';
--     What animal has the most visits to vets?
SELECT COUNT(*) as number_of_visits, A.name as animal_name
FROM visits B
         RIGHT JOIN animals A ON B.animal_id = A.id
GROUP BY A.name
HAVING COUNT(*) =
       (SELECT MAX(count_results.visits_per_animals)
        FROM (select count(A.vet_id) as visits_per_animals FROM visits A GROUP BY A.animal_id) as count_results);
--     Who was Maisy Smith's first visit?
SELECT B.name, A.date_of_visit as First_Visit, C.name as Animal_Name
FROM visits A
         RIGHT JOIN vets B ON A.vet_id = B.id
         RIGHT JOIN animals C ON A.animal_id = C.id
GROUP BY B.name, A.date_of_visit, C.name
HAVING MIN(A.date_of_visit) =
       (SELECT MIN(vet_visits.date_of_visit)
        FROM (SELECT * From visits WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')) as vet_visits);
--     Details for most recent visit: animal information, vet information, and date of visit.
SELECT A.id, B.name as vet_name, C.name as Animal_name, A.date_of_visit
FROM visits A
         RIGHT JOIN vets B ON A.vet_id = B.id
         RIGHT JOIN animals C ON A.animal_id = C.id
GROUP BY C.name, B.name, A.id, A.date_of_visit
HAVING MAX(A.date_of_visit) =
       (SELECT MAX(date_of_visit) FROM visits);
--     How many visits were with a vet that did not specialize in that animal's species?
SELECT V.*
FROM visits V
WHERE NOT (select exists(select 1
                         from (SELECT S.vet_id
                               FROM specializations S
                               WHERE S.specie_id = -- get vet list of a specific specie
                                     (
                                         SELECT species_id
                                         FROM animals
                                         WHERE id = V.animal_id -- return a specie of a specific animal
                                     ))
                                  as specific_specie_vets
                         where specific_specie_vets.vet_id = V.vet_id));
--     What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT Vet.name as vet_name, count(SP.name) as Visited, SP.name as specialty
FROM visits V
         LEFT JOIN vets Vet ON Vet.id = V.vet_id
         LEFT JOIN animals A ON A.id = V.animal_id
         LEFT JOIN species SP ON SP.id = A.species_id
WHERE V.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
GROUP BY SP.name, Vet.name
HAVING COUNT(SP.name) =
       (SELECT MAX(results.count)
        FROM (SELECT count(visit_per_vet.specie_id)
              FROM (SELECT A.species_id as specie_id
                    FROM visits V
                             LEFT JOIN animals A ON A.id = V.animal_id
                    WHERE V.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')) as visit_per_vet
              GROUP BY visit_per_vet.specie_id) as results);

