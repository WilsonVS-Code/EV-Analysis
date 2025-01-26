# Data Cleaning 
-- Removing unwanted columns 
ALTER TABLE dataev.electric_vehicle_population_data 
DROP COLUMN `VIN (1-10)`,
DROP COLUMN `Vehicle Location`,
DROP COLUMN `Electric Utility`,
DROP COLUMN `2020 Census Tract`,
DROP COLUMN `Legislative District`;

-- Changes to column name 
SELECT *
FROM dataev.electric_vehicle_population_data;
ALTER TABLE dataev.electric_vehicle_population_data
CHANGE Make Brand VARCHAR(50),
CHANGE `Model Year` `Year of Manufacture` INT;

ALTER TABLE dataev.electric_vehicle_population_data
CHANGE `Electric Range` `Electric Range (Miles)` INT;

-- Checking for Missing Values
SELECT *
FROM dataev.electric_vehicle_population_data
WHERE CONCAT_WS(',', County, City, State, 'Postal Code', 'Model Year', 'Make', Model, 'Electric Vehicle Type', 'Clean Alternative Fuel Vehicle (CAFV) Eligibility', 'Electric Range', 'Base MSRP', 'DOL Vehicle ID') IS NULL;

-- Conditional formatting for the values of the column 
SELECT DISTINCT `Clean Alternative Fuel Vehicle (CAFV) Eligibility`
FROM dataev.electric_vehicle_population_data;

UPDATE dataev.electric_vehicle_population_data
SET `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Unknown due to lack of research'
WHERE `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Eligibility unknown as battery range has not been researched';

-- Cleaning the EV Charging Station dataset
SELECT *
FROM dataev.alt_fuel_stations;

-- Remove the data that shows that its currently unavailable
DELETE FROM dataev.alt_fuel_stations
WHERE `Groups With Access Code` = 'TEMPORARILY UNAVAILABLE (Public)';

-- Change the name of the column 
ALTER TABLE dataev.alt_fuel_stations
CHANGE `Open Date` `Charging Station Open Date` text;

-- Removing the rows that does not have a value
DELETE FROM dataev.alt_fuel_stations
WHERE `Date Last Confirmed` IS NULL 
AND `Charging Station Open Date` IS NULL;

-- Creating a new column for Charging station open Year
ALTER TABLE dataev.alt_fuel_stations 
ADD `Charging Station Open Year` TEXT;

-- Populating the Values in the new column
UPDATE dataev.alt_fuel_stations
SET `Charging Station Open Year` = CASE 
           WHEN `Charging Station Open Date` IS NOT NULL THEN RIGHT(`Charging Station Open Date`, 4)
           WHEN `Date Last Confirmed` IS NOT NULL THEN RIGHT(`Date Last Confirmed`, 4)
           ELSE NULL
       END;


# Basic Level Analysis
-- Top 5 Cars Manufacture for EVs
SELECT BRAND, COUNT(*) AS `Number of Cars Manufactured`
FROM dataev.electric_vehicle_population_data
GROUP BY BRAND 
ORDER BY COUNT(BRAND) DESC 
LIMIT 5;

SELECT *
FROM dataev.electric_vehicle_population_data;

-- Distribution of Vehicle Types 
SELECT `Electric Vehicle Type`, COUNT(*) AS `Number of Vehicle Type`
FROM dataev.electric_vehicle_population_data
GROUP BY `Electric Vehicle Type`;

-- Top 5 Average Electric Range as per Brand and Model 
SELECT Brand, AVG(`Electric Range (Miles)`) AS `Average Electric Range`, Model
FROM dataev.electric_vehicle_population_data
GROUP BY Brand, Model
ORDER BY AVG(`Electric Range (Miles)`) DESC
LIMIT 5;

-- Top 5 Brands with most sustainable Electric Range (Choosing the maximum electric range from each brand)
SELECT Brand, MAX(`Electric Range (Miles)`) AS `Max Electric Range`
FROM dataev.electric_vehicle_population_data
GROUP BY Brand
ORDER BY MAX(`Electric Range (Miles)`) DESC
LIMIT 5; 

# Intermediate Level Analysis
SELECT *
FROM dataev.electric_vehicle_population_data;

-- The number of EVs manufactured over the years
SELECT `Year of Manufacture`, COUNT(*) AS TotalVehicles
FROM dataev.electric_vehicle_population_data
GROUP BY `Year of Manufacture`
ORDER BY `Year of Manufacture` ASC;

-- Top 5 Average Electric Range as per Brand and Model 
SELECT Brand, MAX(`Electric Range (Miles)`) AS `Max Electric Range`, Model
FROM dataev.electric_vehicle_population_data
GROUP BY Brand, Model
ORDER BY MAX(`Electric Range (Miles)`) DESC
LIMIT 5;

-- Percentage of Vehicles eligible for CAFV Program 
SELECT `Clean Alternative Fuel Vehicle (CAFV) Eligibility`, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dataev.electric_vehicle_population_data) AS Percentage
FROM dataev.electric_vehicle_population_data
GROUP BY `Clean Alternative Fuel Vehicle (CAFV) Eligibility`;

-- Top 5 Cities in Washington with registered EVs
SELECT City, Count(*) AS `Number of Registered EVs`
FROM dataev.electric_vehicle_population_data
GROUP BY City
ORDER BY Count(*) DESC
LIMIT 5;


# Advanced Level Analysis 
-- Electric Range Ranking by Manufacturer over the years 
SELECT DISTINCT ev.`Year of Manufacture`, ev.Brand, ev.Model, ev.`Electric Range (Miles)`
FROM dataev.electric_vehicle_population_data ev 
JOIN (
    SELECT `Year of Manufacture`, MAX(`Electric Range (Miles)`) AS MaxRange
    FROM dataev.electric_vehicle_population_data
    GROUP BY `Year of Manufacture`
) AS MaxRanges
ON ev.`Year of Manufacture` = MaxRanges.`Year of Manufacture`
   AND ev.`Electric Range (Miles)` = MaxRanges.MaxRange
ORDER BY ev.`Year of Manufacture` ASC;

-- Identifying the number of EVS being manufactured by each manufacturer over the years
SELECT Brand, `Year of Manufacture`, Count(*) AS `Number of EV Manufactured`
FROM dataev.electric_vehicle_population_data
GROUP BY `Year of Manufacture`, Brand
ORDER BY `Year of Manufacture` ,Brand;

-- Identifying the proportion of EV Models from each brand that is eligible for the CAFV Program 
SELECT Brand, 
COUNT(DISTINCT CASE WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Clean Alternative Fuel Vehicle Eligible' THEN Model END) as Eligible_Models,
COUNT(DISTINCT Model) AS Total_Models,
ROUND(COUNT(DISTINCT CASE WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Clean Alternative Fuel Vehicle Eligible' THEN Model END)*100/COUNT(DISTINCT Model),2) AS ProportionEligible
FROM dataev.electric_vehicle_population_data
GROUP BY Brand
ORDER BY ProportionEligible DESC, Eligible_Models DESC;

SELECT *
FROM dataev.electric_vehicle_population_data;

-- Identifying number of EVs that gets the CAFV Program from each manufacturing year 
SELECT `Year of Manufacture`, COUNT(*) AS `Number of EVs Manufactured Each Year`, 
COUNT(CASE WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Clean Alternative Fuel Vehicle Eligible' 
              THEN 1 
          END) AS EligibleEVs,
    ROUND(
        COUNT(CASE 
                  WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Clean Alternative Fuel Vehicle Eligible' 
                  THEN 1 
              END) * 100.0 / COUNT(*), 2
    ) AS PercentageEligible,
	ROUND(
        COUNT(CASE 
                  WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Unknown due to lack of research' 
                  THEN 1 
              END) * 100.0 / COUNT(*), 2
    ) AS PercentageUnknown, 
    	ROUND(
        COUNT(CASE 
                  WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Not eligible due to low battery range' 
                  THEN 1 
              END) * 100.0 / COUNT(*), 2
    ) AS PercentageIneligible
FROM dataev.electric_vehicle_population_data
GROUP BY `Year of Manufacture`
ORDER BY `Year of Manufacture` ASC;


-- Identify the number of cars with base MSRP = 0 based on the brand.
SELECT Brand, 
COUNT(CASE WHEN `BASE MSRP` = 0
              THEN 1 
          END) AS PriceUnknown,
COUNT(CASE WHEN `BASE MSRP` != 0
              THEN 1 
          END) AS PriceKnown
FROM dataev.electric_vehicle_population_data
GROUP BY Brand;

-- BEV Vs PHEV (CAFV Program)
SELECT `Electric Vehicle Type`, COUNT(*) AS `Number of EVs`,
COUNT(CASE WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Clean Alternative Fuel Vehicle Eligible' 
              THEN 1 
          END) AS EligibleEVs,
    ROUND(
        COUNT(CASE 
                  WHEN `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Clean Alternative Fuel Vehicle Eligible' 
                  THEN 1 
              END) * 100.0 / COUNT(*), 2
    ) AS PercentageEligible
FROM dataev.electric_vehicle_population_data
GROUP BY `Electric Vehicle Type`;

-- Check if Electric Range influences the eligibility receiving the CAFV Program 
SELECT MIN(`Electric Range (Miles)`)
FROM dataev.electric_vehicle_population_data
WHERE `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Clean Alternative Fuel Vehicle Eligible';

SELECT MAX(`Electric Range (Miles)`)
FROM dataev.electric_vehicle_population_data
WHERE `Clean Alternative Fuel Vehicle (CAFV) Eligibility` = 'Not eligible due to low battery range';


-- Analysis on the EV Charging Station in the State of Washington
SELECT * 
FROM dataev.alt_fuel_stations;

-- Identifying the Number of charging stations being made over the years in the state of Washington
SELECT `Charging Station Open Year`, COUNT(*) AS `Number of Charging Stations Opened`
FROM dataev.alt_fuel_stations
GROUP BY `Charging Station Open Year`;

-- Top 5 cities have the most charging stations in the state of Washington?
SELECT City, COUNT(*) AS `Number of Available Charging Stations`
FROM dataev.alt_fuel_stations
GROUP BY CITY
ORDER BY COUNT(*) DESC
LIMIT 5;

-- The cities that have charging stations and the amount
SELECT City, COUNT(*) AS `Number of Available Charging Stations`
FROM dataev.alt_fuel_stations
GROUP BY City
ORDER BY COUNT(*) DESC;

-- Identifying the number of cities that have EV charging station infrastructure 
SELECT COUNT(DISTINCT City)
FROM dataev.alt_fuel_stations;

-- Identifying the number of cities that have less than 10 EV Charging Stations in the state of Washington
SELECT COUNT(*) AS CityCounts
FROM (SELECT City, COUNT(*) 
		FROM dataev.alt_fuel_stations
        GROUP BY City
        HAVING Count(*) < 10) AS `Charging Station Counter`;





