SELECT *
FROM propertydatabase_staging2;


SELECT property_city, COUNT(*)
FROM propertydatabase_staging2
WHERE floor_size > 200
GROUP BY Property_city;

SELECT property_city, COUNT(*), ROUND(AVG(property_price), 2) STDDEV, ROUND(STDDEV_SAMP(property_price),2) AS STDDEV
FROM propertydatabase_staging2
GROUP BY property_city;



-- MAX, MIN and Range
SELECT MAX(property_price) AS max,
MIN(property_price) AS min,
MAX(property_price) - MIN(property_price) AS range_sample
FROM propertydatabase_staging2;



-- Mode
SELECT property_price, COUNT(Property_price)
FROM propertydatabase_staging2
GROUP BY property_price
LIMIT 5;

-- MEAN, MEDIAN and STDDEV
WITH ranked_table AS
(
	SELECT Floor_size,
    PERCENT_RANK() OVER(ORDER BY Floor_size) AS percentile
    FROM propertydatabase_staging2
    ORDER BY floor_size
)
SELECT ROUND(AVG(floor_size), 2) AS Mean,
MIN(CASE WHEN percentile >= 0.5 THEN floor_size END) AS Median,
ROUND(STDDEV_SAMP(floor_size), 2) AS Standard_deviation
FROM ranked_table;


-- Further STDDEV details
SELECT ROUND((STDDEV_SAMP(property_price)/AVG(property_price)) * 100, 2) AS interpretation
FROM propertydatabase_staging2;

-- 25th, 75th and IQR
WITH ranked_cte AS
(
	SELECT bathrooms,
    PERCENT_RANK() OVER(ORDER BY bathrooms) AS percentile
    FROM propertydatabase_staging2
    ORDER BY bathrooms
)
SELECT MIN(CASE WHEN percentile >= .25 THEN bathrooms END) AS first_Q,
MIN(CASE WHEN percentile >= .75 THEN bathrooms END) AS third_Q,
MIN(CASE WHEN percentile >= .75 THEN bathrooms END) - 
MIN(CASE WHEN percentile >= .25 THEN bathrooms END) AS IQR
FROM ranked_cte;


-- Checking for outliers (IQR)
SELECT property_price
FROM propertydatabase_staging2
WHERE property_price > (16550 + 1.5 * 9290)
	OR 
    property_price < (7260 - 1.5 * 9290);



-- Checking outliers (Z_SCORE)
SELECT property_price, 
ROUND((property_price - 13212.83)/10113.49, 2) AS z_score,
COUNT(*) AS nr
FROM propertydatabase_staging2
GROUP BY property_price;


-- Agents
SELECT estate_agent, AVG(property_price), COUNT(estate_agent)
FROM propertydatabase_staging2
GROUP BY estate_agent;

SELECT COUNT(*)
FROM propertydatabase_staging2
WHERE Estate_Agent IS NULL;


WITH ranked_table AS
(
	SELECT Property_city,
    property_price,
    PERCENT_RANK() OVER(ORDER BY property_price) AS percentile
    FROM propertydatabase_staging2
    ORDER BY property_price
)
SELECT property_city,
COUNT(*),
ROUND(AVG(property_price), 2) AS Mean,
MIN(CASE WHEN percentile >= 0.5 THEN property_price END) AS Median
FROM ranked_table
GROUP BY property_city;


-- Pearson Correlation
SELECT
	ROUND((SUM((parking_space - bd_mean) * (property_price - price_mean)))/
    (STDDEV(parking_space) * STDDEV(property_price) * (COUNT(*) - 1)), 2) AS correlation
FROM propertydatabase_staging2
CROSS JOIN (
	SELECT 
		AVG(parking_space) AS bd_mean,
        AVG(Property_price) AS price_mean
	FROM propertydatabase_staging2) AS means;
    
    

SELECT AVG(parking_space) AS bd_mean,
AVG(property_price) AS price_mean
FROM propertydatabase_staging2;


-- Simple Linear Regression slope
SELECT ROUND(SUM((floor_size - 75.57)*(property_price - 13212.8330))/
		SUM(POW(floor_size - 75.57, 2)),2) AS Slope
FROM propertydatabase_staging2;

SELECT "Bedrooms" AS Feature,
0.23 AS Correlation,
5.29 AS `R_Square (in %)`,
3481.47 AS Regression_slope
UNION ALL
SELECT "Bathrooms" AS Feature,
0.48 AS Correlation,
23 AS `R_Square (in %)`,
8211.95 AS Regression_slope
UNION ALL
SELECT "Floor size" AS Feature,
0.13 AS Correlation,
1.69 AS `R_Square (in %)`,
53.52 AS Regression_slope
UNION ALL
SELECT "Parking space" AS Feature,
0.22 AS Correlation,
4.84 AS `R_Square (in %)`,
4082.71 AS Regression_slope;