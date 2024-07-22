-- ==================================================
-- SETTING UP THE DATABASE
-- ==================================================

-- Setting the working database
USE world_happiness;

-- ==================================================
-- BASIC QUERIES
-- ==================================================

-- Selecting all the data from table
SELECT c.name AS country_name, hi.year, hi.ladder_score, hi.logged_gdp_per_capita, hi.social_support, hi.freedom_to_choose
FROM happiness_indicators AS hi
LEFT JOIN countries AS c
ON hi.country_id = c.id
ORDER BY country_name, year;

-- ==================================================
-- Hypotheses
-- ==================================================

-- ==================================================
-- 1 Freedom to choose and Happiness: 
-- **Hypothesis**: Greater personal freedom and lower levels of corruption are associated with higher happiness scores.
-- **Rationale**: Freedom to make life choices and live without oppression or corruption can significantly impact personal satisfaction and happiness.

WITH stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(freedom_to_choose) AS sum_x,
        SUM(ladder_score) AS sum_y,
        SUM(freedom_to_choose * ladder_score) AS sum_xy,
        SUM(freedom_to_choose * freedom_to_choose) AS sum_x2,
        SUM(ladder_score * ladder_score) AS sum_y2
    FROM 
        happiness_indicators
    WHERE 
        year = 2021
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
FROM 
    stats;

WITH stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(freedom_to_choose) AS sum_x,
        SUM(ladder_score) AS sum_y,
        SUM(freedom_to_choose * ladder_score) AS sum_xy,
        SUM(freedom_to_choose * freedom_to_choose) AS sum_x2,
        SUM(ladder_score * ladder_score) AS sum_y2
    FROM 
        happiness_indicators
    WHERE 
        year = 2023
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
FROM 
    stats;

-- Combined view of the top and bottom 10 countries for each year
-- Top and Bottom 10 for 2021
(SELECT 
    'Top 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.freedom_to_choose
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2021
ORDER BY 
    hi.ladder_score DESC
LIMIT 10)
UNION ALL
(SELECT 
    'Bottom 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.freedom_to_choose
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2021
ORDER BY 
    hi.ladder_score ASC
LIMIT 10);

-- Top and Bottom 10 for 2023
(SELECT 
    'Top 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score,  
    hi.freedom_to_choose
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2023
ORDER BY 
    hi.ladder_score DESC
LIMIT 10)
UNION ALL
(SELECT 
    'Bottom 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.freedom_to_choose
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2023
ORDER BY 
    hi.ladder_score ASC
LIMIT 10);

-- ==================================================

-- 2. Social Factors
-- **Hypothesis**: Countries with high social support and strong community ties show consistently high happiness scores.
-- **Rationale**: Stronger connection with family and community enhance emotional well-being.

WITH stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(social_support) AS sum_x,
        SUM(ladder_score) AS sum_y,
        SUM(social_support * ladder_score) AS sum_xy,
        SUM(social_support * social_support) AS sum_x2,
        SUM(ladder_score * ladder_score) AS sum_y2
    FROM 
        happiness_indicators
    WHERE 
        year = 2021
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
FROM 
    stats;

WITH stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(social_support) AS sum_x,
        SUM(ladder_score) AS sum_y,
        SUM(social_support * ladder_score) AS sum_xy,
        SUM(social_support * social_support) AS sum_x2,
        SUM(ladder_score * ladder_score) AS sum_y2
    FROM 
        happiness_indicators
    WHERE 
        year = 2023
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
FROM 
    stats;
    
-- Combined view of the top and bottom 10 countries for each year
-- Top and Bottom 10 for 2021
(SELECT 
    'Top 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.social_support
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2021
ORDER BY 
    hi.ladder_score DESC
LIMIT 10)
UNION ALL
(SELECT 
    'Bottom 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.social_support
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2021
ORDER BY 
    hi.ladder_score ASC
LIMIT 10);

-- Top and Bottom 10 for 2023
(SELECT 
    'Top 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score,  
    hi.social_support
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2023
ORDER BY 
    hi.ladder_score DESC
LIMIT 10)
UNION ALL
(SELECT 
    'Bottom 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.social_support
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2023
ORDER BY 
    hi.ladder_score ASC
LIMIT 10);


-- ==================================================

-- 3. Economic / GDP Factors
-- **Hypothesis**: Countries with higher GDP per capita have higher happiness scores.
-- **Rationale**: Economic stability provides better living conditions, education, and healthcare which contribute to overall higher levels of happiness.

WITH stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(logged_gdp_per_capita) AS sum_x,
        SUM(ladder_score) AS sum_y,
        SUM(logged_gdp_per_capita * ladder_score) AS sum_xy,
        SUM(logged_gdp_per_capita * logged_gdp_per_capita) AS sum_x2,
        SUM(ladder_score * ladder_score) AS sum_y2
    FROM 
        happiness_indicators
    WHERE 
        year = 2021
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
FROM 
    stats;

WITH stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(logged_gdp_per_capita) AS sum_x,
        SUM(ladder_score) AS sum_y,
        SUM(logged_gdp_per_capita * ladder_score) AS sum_xy,
        SUM(logged_gdp_per_capita * logged_gdp_per_capita) AS sum_x2,
        SUM(ladder_score * ladder_score) AS sum_y2
    FROM 
        happiness_indicators
    WHERE 
        year = 2023
)
SELECT 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)) AS correlation
FROM 
    stats;

-- Top and Bottom 10 for 2021
(SELECT 
    'Top 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score,  
    hi.logged_gdp_per_capita
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2021
ORDER BY 
    hi.ladder_score DESC
LIMIT 10)
UNION ALL
(SELECT 
    'Bottom 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.logged_gdp_per_capita
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2021
ORDER BY 
    hi.ladder_score ASC
LIMIT 10);

-- Top and Bottom 10 for 2023
(SELECT 
    'Top 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score,  
    hi.logged_gdp_per_capita
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2023
ORDER BY 
    hi.ladder_score DESC
LIMIT 10)
UNION ALL
(SELECT 
    'Bottom 10' AS category, 
    c.name AS country_name, 
    hi.ladder_score, 
    hi.logged_gdp_per_capita
FROM 
    happiness_indicators hi
JOIN 
    countries c ON hi.country_id = c.id
WHERE 
    hi.year = 2023
ORDER BY 
    hi.ladder_score ASC
LIMIT 10);

select * from countries;
select * from happiness_indicators;