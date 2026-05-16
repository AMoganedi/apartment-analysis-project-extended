SELECT *
FROM propertydatabase_staging2;

SELECT AVG(nr)
FROM (
	SELECT Estate_Agent, COUNT(*) AS nr
	FROM propertydatabase_staging2
	GROUP BY estate_agent) AS sub_table;

SELECT *
FROM propertydatabase_staging2
WHERE Estate_Agent = '';

SELECT Floor_size, CAST(Floor_size AS UNSIGNED)
FROM propertydatabase_staging2
WHERE floor_size IS NOT NULL;

UPDATE propertydatabase_staging2
SET Floor_size = CAST(Floor_size AS UNSIGNED);

ALTER TABLE propertydatabase_staging2
MODIFY COLUMN Floor_size INTEGER;

SELECT Property_location
FROM propertydatabase_staging2
GROUP BY property_location;

SELECT *
FROM propertydatabase_staging2
WHERE floor_size > 300;

SELECT estate_agent, COUNT(estate_agent)
FROM propertydatabase_staging2
GROUP BY estate_agent;


DELETE
FROM propertydatabase_staging2
WHERE estate_agent IN(
	SELECT estate_agent
	FROM (
		SELECT estate_agent, COUNT(*) AS nr
		FROM propertydatabase_staging2
		GROUP BY Estate_Agent
		HAVING nr < 20
		ORDER BY nr ASC) AS sub_table);
        
SELECT *
FROM propertydatabase_staging2;

SELECT *
FROM propertydatabase_staging2
WHERE property_price <= 0;


SELECT Estate_Agent, TRIM(estate_agent)
FROM propertydatabase_staging2;

UPDATE propertydatabase_staging2
SET estate_agent = TRIM(estate_agent);


SELECT property_city, COUNT(*)
FROM propertydatabase_staging2
GROUP BY property_city;


SELECT *
FROM propertydatabase_staging2;

UPDATE propertydatabase_staging2
SET property_type = 'Apartment';

DELETE 
FROM propertydatabase_staging2
WHERE floor_size > 200;