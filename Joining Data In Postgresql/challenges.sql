-- In this exercise, you'll need to get the country names and other 2015 data in the economies table
-- and the countries table for Central American countries with an official language.
SELECT DISTINCT name, total_investment, imports
  -- From table (with alias)
  FROM economies AS e
    -- Join with table (with alias)
    LEFT JOIN countries AS c
      -- Match on code
      ON (e.code = c.code
      -- and code in Subquery
        AND c.code IN (
          SELECT l.code
          FROM languages AS l
          WHERE official = 'true'
        )
        )
  -- Where region and year are correct
  WHERE region = 'Central America' AND year = 2015
ORDER BY name;


-- Let's calculate the average fertility rate for each region in 2015.
SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
  -- From left table
  FROM countries AS c
    -- Join to right table
    INNER JOIN populations AS p
      -- Match on join condition
      ON c.code = p.country_code
  -- Where specific records matching some condition
  WHERE year = 2015
-- Group appropriately
GROUP BY region, continent
-- Order appropriately
ORDER BY avg_fert_rate;

-- Let's determine the top 10 capital cities in Europe and the Americas in terms of
-- a calculated percentage using city_proper_pop and metroarea_pop in cities
SELECT name, country_code,city_proper_pop, metroarea_pop,
      -- Calculate city_perc
      city_proper_pop / metroarea_pop * 100 AS city_perc
  FROM cities
  WHERE name IN
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe' OR continent LIKE '% America')
    )
  -- exclude records with missing data on metro area population
  AND metroarea_pop IS NOT NULL
-- Order appropriately
ORDER BY city_perc DESC
-- Limit amount
LIMIT 10;