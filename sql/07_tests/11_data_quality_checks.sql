-- Run before and after the incremental demonstration.
SELECT 'SOURCE_EMPLOYEES' AS check_name, COUNT(*) AS row_count
FROM HR_DB.HR_SCHEMA.EMPLOYEES
UNION ALL
SELECT 'BRONZE_EMPLOYEES_RAW', COUNT(*)
FROM HR_DB.BRONZE.EMPLOYEES_RAW
UNION ALL
SELECT 'SILVER_EMPLOYEES', COUNT(*)
FROM HR_DB.SILVER.EMPLOYEES;

-- Duplicate employee IDs should return no rows.
SELECT employee_id, COUNT(*) AS record_count
FROM HR_DB.SILVER.EMPLOYEES
GROUP BY employee_id
HAVING COUNT(*) > 1;

-- Unmatched non-null department IDs should return no rows for the sample data.
SELECT e.employee_id, e.department_id
FROM HR_DB.SILVER.EMPLOYEES e
LEFT JOIN HR_DB.SILVER.DEPARTMENTS d
    ON e.department_id = d.department_id
WHERE e.department_id IS NOT NULL
  AND d.department_id IS NULL;

-- Gold metrics.
SELECT *
FROM HR_DB.GOLD.DEPARTMENT_SUMMARY
ORDER BY department_id;
