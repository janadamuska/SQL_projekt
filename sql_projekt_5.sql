-- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

SELECT *
FROM t_jan_adamuska_project_sql_primary_final;


WITH base as(
SELECT 
	year ,
	AVG(avg_salary ) AS total_avg_salary,
	AVG(avg_value ) AS total_avg_value,
	cz_gdp
FROM t_jan_adamuska_project_sql_primary_final
GROUP BY year, cz_gdp
),
lagged AS (
    SELECT
        year,
        total_avg_salary,
		LAG(total_avg_salary) OVER (ORDER BY YEAR) AS prev_salary,
        total_avg_value,
        LAG(total_avg_value)  OVER (ORDER BY YEAR) AS prev_value,
        cz_gdp,
        LAG(cz_gdp) OVER (ORDER BY YEAR) AS prev_gdp 
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
    cz_gdp,
    ROUND((((cz_gdp - prev_gdp) / NULLIF(prev_gdp, 0)) *100)::NUMERIC, 2) AS gdp_pct_change
FROM lagged
ORDER BY year;