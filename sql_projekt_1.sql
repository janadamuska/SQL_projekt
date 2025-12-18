-- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

CREATE OR REPLACE VIEW v_salary_trends AS 
WITH s AS (
    SELECT
        industry_name,
        industry_branch_code,
        year,
        avg_salary,
        LAG(avg_salary) OVER (
            PARTITION BY industry_branch_code
            ORDER BY year
        ) AS prev_salary
    FROM t_jan_adamuska_project_SQL_primary_final
)
SELECT DISTINCT ON (industry_branch_code, year)
    industry_name,
    industry_branch_code,
    year,
    avg_salary,
    CASE 
        WHEN prev_salary IS NULL THEN 'zacatek'
        WHEN avg_salary > prev_salary THEN 'roste'
        WHEN avg_salary < prev_salary THEN 'klesa'
        ELSE 'stejne'
    END AS trend
FROM s
ORDER BY industry_branch_code, year, avg_salary DESC;

SELECT *
FROM v_salary_trends
WHERE trend = 'klesa'
ORDER BY industry_name , year;



