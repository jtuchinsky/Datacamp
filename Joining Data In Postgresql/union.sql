-- Select fields from 2010 table
select *
  -- From 2010 table
  from economies2010
	-- Set theory clause
	union
-- Select fields from 2015 table
select *
  -- From 2015 table
  from economies2015
-- Order by code and year
order by code, year;

-- UNION can also be used to determine all occurrences of a field across multiple tables.
-- Try out this exercise with no starter code.
-- Determine all (non-duplicated) country codes in either the cities or the currencies table.
-- The result should be a table with only one field called country_code
-- Select field
select country_code
  -- From cities
  from cities
	-- Set theory clause
	union
-- Select field
select code as country_code
  -- From currencies
  from currencies
-- Order by country_code
order by country_code;

-- As you saw, duplicates were removed from the previous two exercises by using UNION.
-- To include duplicates, you can use UNION ALL.

-- Determine all combinations (include duplicates) of country code and year that exist
--   in either the economies or the populations tables. Order by code then year.
-- Select fields
select code, year
  -- From economies
  from economies
	-- Set theory clause
	union all
-- Select fields
select country_code, year
  -- From populations
  from populations
-- Order by code, year
order by code, year;

-- Now, let's look at the records in common for country code and year for
-- the economies and populations tables.

-- Select fields
select code, year
  -- From economies
  from economies
	-- Set theory clause
	intersect
-- Select fields
select country_code, year
  -- From populations
  from populations
-- Order by code and year
order by code, year;

-- As you think about major world cities and their corresponding country,
-- you may ask which countries also have a city with the same name as their country name?
-- Select fields
select name
  -- From countries
  from cities
	-- Set theory clause
	intersect
-- Select fields
select name
  -- From cities
  from countries;

-- Get the names of cities in cities which are not noted as capital cities in countries as a single field result.
-- Note that there are some countries in the world that are not included in the countries table, which will result in
-- some cities not being labeled as capital cities when in fact they are.
-- Select field
SELECT name
  -- From cities
  FROM cities
	-- Set theory clause
	EXCEPT
-- Select field
SELECT capital
  -- From countries
  FROM countries
-- Order by result
ORDER BY name;

-- Now you will complete the previous query in reverse!
-- Determine the names of capital cities that are not listed in the cities table.
-- Select field
select capital
  -- From countries
  FROM countries
	-- Set theory clause
	EXCEPT
-- Select field
SELECT name
  -- From cities
  FROM cities
-- Order by ascending capital
ORDER BY capital;

-- Identify languages spoken in the Middle East
-- 1. Select countries from the Midle East
SELECT code
  -- From countries
  FROM countries
-- Where region is Middle East
WHERE region = 'Middle East';
-- 2. Select unique languages
SELECT DISTINCT name
  -- From languages
  FROM languages
-- Order by name
ORDER BY name;
-- 3. Combine previous two queries into one query
-- Select distinct fields
SELECT DISTINCT name
  -- From languages
  FROM languages
-- Where in statement
WHERE code IN
  -- Subquery
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
-- Order by name
ORDER BY name;

-- Our goal is to identify the currencies used in Oceanian countries
-- 1. Begin by determining the number of countries in countries that are listed in Oceania
SELECT COUNT(code)
  FROM countries
-- Where continent is Oceania
WHERE continent = 'Oceania';
-- 2. Build an inner join to to get the different currencies used in the countries of Oceania
SELECT c1.code, c1.name, c2.basic_unit AS currency
  -- From countries (alias as c1)
  FROM countries AS c1
  	-- Join with currencies (alias as c2)
  	INNER JOIN currencies AS c2
    -- Match on code
    USING(code)
-- Where continent is Oceania
WHERE continent = 'Oceania';
-- 3. Note that not all countries in Oceania were listed in the resulting inner join with currencies.
--    Use an anti-join to determine which countries were not included!
SELECT code, name
FROM countries
WHERE continent = 'Oceania'
  AND code NOT IN (
    SELECT code
    FROM currencies
  )

-- Identify the country codes that are included in either economies or currencies but not in populations
-- and find the cities from such countries
-- Select the city name
SELECT name
  -- Alias the table where city name resides
  FROM cities AS c1
  -- Choose only records matching the result of multiple set theory clauses
  WHERE country_code IN
(
    -- Select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- Get all additional (unique) values of the field from currencies AS c2
    UNION
    SELECT c2.code
    FROM currencies AS c2
    -- Exclude those appearing in populations AS p
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);