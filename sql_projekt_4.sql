-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?


SELECT *
FROM t_jan_adamuska_project_sql_primary_final;



WITH base AS (
    SELECT
        year,
        AVG(avg_salary) AS total_avg_salary,
        AVG(avg_value)  AS total_avg_value
    FROM t_jan_adamuska_project_sql_primary_final
    GROUP BY year
),
lagged AS (
    SELECT
        year,
        total_avg_salary,
        LAG(total_avg_salary) OVER (ORDER BY year) AS prev_salary,
        total_avg_value,
        LAG(total_avg_value) OVER (ORDER BY year) AS prev_value
    FROM base
)
SELECT
    year,
    total_avg_salary,
    prev_salary,
    ROUND((((total_avg_salary - prev_salary) / NULLIF(prev_salary, 0)) * 100)::numeric, 2) AS salary_pct_change,
    total_avg_value,
    prev_value,
    ROUND((((total_avg_value  - prev_value)  / NULLIF(prev_value,  0)) * 100)::numeric, 2) AS value_pct_change,
    ROUND(((total_avg_value - prev_value) / NULLIF(prev_value, 0) * 100 - (total_avg_salary - prev_salary) / NULLIF(prev_salary, 0) * 100)::numeric, 2) AS diff_pct
FROM lagged
ORDER BY year;





