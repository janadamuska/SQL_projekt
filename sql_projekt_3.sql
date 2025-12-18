-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- srovnání mezi roky

WITH base AS (
    SELECT DISTINCT
        year,
        category_code,
        category_name,
        avg_value
    FROM t_jan_adamuska_project_sql_primary_final
),
lagged AS (
    SELECT
        year,
        category_code,
        category_name,
        avg_value,
        LAG(avg_value) OVER (
            PARTITION BY category_code
            ORDER BY year
        ) AS prev_year
    FROM base
)
SELECT
    year,
    category_code,
    category_name,
    avg_value,
    prev_year,
    ROUND( (((avg_value - prev_year) / NULLIF(prev_year, 0)) * 100)::numeric, 2 ) AS pct_change
FROM lagged;


-- první a poslední rok

WITH base AS (
    SELECT DISTINCT
        year,
        category_code,
        category_name,
        avg_value
    FROM t_jan_adamuska_project_sql_primary_final
    WHERE YEAR IN (2006, 2018)
),
lagged AS (
    SELECT
        year,
        category_code,
        category_name,
        avg_value,
        LAG(avg_value) OVER (
            PARTITION BY category_code
            ORDER BY year
        ) AS prev_year
    FROM base
)
SELECT
    year,
    category_code,
    category_name,
    avg_value,
    prev_year,
    ROUND( (((avg_value - prev_year) / NULLIF(prev_year, 0)) * 100)::numeric, 2 ) AS pct_change
FROM lagged;


