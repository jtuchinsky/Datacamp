-- Let's try to figure out which countries had high average life expectancies (at the country level) in 2015.
-- 1.  Select average life_expectancy from populations
select avg(life_expectancy)
  -- From populations
  from populations
-- Where year is 2015
where year = 2015
-- 2. Select only countries with life_expectancy > 1.15 * AVG
select *
  -- From populations
  from populations
-- Where life_expectancy is greater than
where life_expectancy > 1.15 *
  -- 1.15 * subquery
  (
   select avg(life_expectancy)
   from populations
   where year = 2015
  )
and year = 2015;

-- Get the urban area population for only capital cities.
select name, country_code, urbanarea_pop
  from cities
-- Where city name in the field of capital cities
where name in
  (select capital
   from countries)
order by urbanarea_pop desc;

-- Select the top nine countries in terms of number of cities appearing in the cities table
select countries.name as country, count(*) as cities_num
  from cities
    inner join countries
    on countries.code = cities.country_code
group by country
order by cities_num desc, country
limit 9;

-- Let's achieve the same result using subqueries
select name as country,
  (select count(name)
   from cities
   where countries.code = cities.country_code) as cities_num
from countries
order by cities_num desc, country
limit 9;

-- SUBQUERY INSIDE FROM
-- Let's determine the number of languages spoken for each country, identified by the country's local name
-- (Note this may be different than the name field and is stored in the local_name field.)
-- 1. Begin by determining for each country code how many languages are listed in the languages table
select code, count(*) as lang_num
from languages
group by code;

-- 2. Include the previous query (aliased as subquery) as a subquery in the FROM clause of a new query.
select countries.local_name, subquery.lang_num
from countries,
  	-- Subquery (alias as subquery)
  	(select code, count(*) as lang_num
        from languages
        group by code
    ) as subquery
where countries.code = subquery.code
order by subquery.lang_num desc;

-- ADVANCED SUBQUERY
-- For each of the six continents listed in 2015, identify which country had the maximum inflation rate
-- (and how high it was) using multiple subqueries.
-- 1. Let's get inflation rates for each country
select name, continent, inflation_rate
  from countries
  	-- Join to economies
  	inner join economies
    -- Match on code
    on countries.code = economies.code
-- Where year is 2015
where year = 2015;

-- 2. Select the maximum inflation rate in 2015 AS max_inf grouped by continent
--    using the previous step's query as a subquery in the FROM clause.
select max(inflation_rate) as max_inf
  -- Subquery using FROM (alias as subquery)
  from (select name, continent, inflation_rate
        from countries
  	    inner join economies
        using (code)
        where year = 2015
    ) as subquery
-- Group by continent
group by continent;

-- Now it's time to append your second query to your first query using AND and IN to obtain
-- the name of the country, its continent, and the maximum inflation rate for each continent in 2015.
select name, continent, inflation_rate
  -- From countries
  from countries
	-- Join to economies
	inner join economies
	-- Match on code
	on countries.code = economies.code
  -- Where year is 2015
  where year = 2015
    -- And inflation rate in subquery (alias as subquery)
    and inflation_rate in (
        select max(inflation_rate) as max_inf
        from (
             select name, continent, inflation_rate
             from countries
             inner join economies
             on countries.code = economies.code
             where year = 2015) as subquery
      -- Group by continent
        group by continent);

-- Use a subquery to get 2015 economic data for countries that do not have
-- gov_form of 'Constitutional Monarchy' or 'Republic' in their gov_form.
SELECT code, inflation_rate, unemployment_rate
  -- From economies
  FROM economies
  -- Where year is 2015 and code is not in
  WHERE year = 2015 AND code NOT IN
  	-- Subquery
  	(SELECT code
  	 FROM countries
  	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
-- Order by inflation rate
ORDER BY inflation_rate;