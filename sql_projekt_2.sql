-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT *
FROM t_jan_adamuska_project_sql_primary_final;


WITH base AS (
    SELECT
        year,
        category_code,
        category_name,
        avg_value,
        AVG(avg_salary) OVER (PARTITION BY year) AS total_avg_salary
    FROM t_jan_adamuska_project_sql_primary_final
    WHERE category_code IN (114201, 111301)
)
SELECT
    DISTINCT
    year,
    category_code,
    category_name,
    avg_value,
    total_avg_salary,
    total_avg_salary / avg_value AS amount
FROM base
WHERE YEAR IN (2006, 2018)
ORDER BY category_code, year;

