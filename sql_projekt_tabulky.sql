-- CREATE TABLE (PRIMARY)


CREATE TABLE t_jan_adamuska_project_SQL_primary_final AS
WITH payroll AS (
  SELECT
      cp.payroll_year,
      cp.industry_branch_code,
      cpib.name AS industry_name,
      AVG(cp.value) AS avg_salary
  FROM czechia_payroll AS cp
  JOIN czechia_payroll_industry_branch AS cpib
    ON cp.industry_branch_code = cpib.code
  WHERE cp.value_type_code = 5958
  GROUP BY
      cp.payroll_year,
      cp.industry_branch_code,
      cpib.name
),
prices AS (
  SELECT
      EXTRACT(YEAR FROM cpr.date_from)::int AS year,
      cpr.category_code,
      cpc.name AS category_name,
      AVG(cpr.value) AS avg_value
  FROM czechia_price AS cpr
  JOIN czechia_price_category AS cpc
    ON cpr.category_code = cpc.code
  GROUP BY
      EXTRACT(YEAR FROM cpr.date_from),
      cpr.category_code,
      cpc.name
),
economies AS (
  SELECT
      e.year,
      e.gdp
  FROM economies AS e
  WHERE e.country = 'Czech Republic'
)
SELECT
    p.payroll_year AS year,
    p.industry_branch_code,
    p.industry_name,
    p.avg_salary,
    pr.category_code,
    pr.category_name,
    pr.avg_value,
    econ.gdp AS cz_gdp
FROM payroll AS p
JOIN prices AS pr
  ON pr.year = p.payroll_year
LEFT JOIN economies AS econ
  ON econ.year = p.payroll_year
ORDER BY
    p.industry_branch_code,
    p.payroll_year,
    pr.category_code;


SELECT * 
FROM t_jan_adamuska_project_SQL_primary_final;


-- CREATE TABLE (SECONDARY)

CREATE TABLE t_jan_adamuska_project_SQL_secondary_final AS(
SELECT
	e.country,
	e."year",
	e. gdp,
	e.population,
	e.gini FROM economies AS e
INNER JOIN countries AS c 
ON e.country = c.country
AND c.continent = 'Europe'
WHERE "year" between 2006 and 2018
ORDER BY country, "year"
);

SELECT *
FROM t_jan_adamuska_project_SQL_secondary_final;
