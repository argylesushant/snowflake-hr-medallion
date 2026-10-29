-- Step 7: Gold reporting view. Salary values are restricted to currently effective records.
CREATE OR REPLACE VIEW HR_DB.GOLD.DEPARTMENT_SUMMARY AS
WITH CURRENT_SALARY AS
(
    SELECT employee_id, salary_amount, effective_from, updated_at, salary_id
    FROM HR_DB.SILVER.SALARIES
    WHERE effective_from <= CURRENT_DATE()
      AND (effective_to IS NULL OR effective_to >= CURRENT_DATE())
    QUALIFY ROW_NUMBER() OVER
    (
        PARTITION BY employee_id
        ORDER BY effective_from DESC, updated_at DESC, salary_id DESC
    ) = 1
)
SELECT
    d.department_id,
    d.department_name,
    COALESCE(COUNT_IF(e.is_active = TRUE), 0) AS active_employee_count,
    ROUND(AVG(IFF(e.is_active = TRUE, s.salary_amount, NULL)), 2) AS average_active_salary,
    MAX(IFF(e.is_active = TRUE, s.salary_amount, NULL)) AS maximum_active_salary
FROM HR_DB.SILVER.DEPARTMENTS d
LEFT JOIN HR_DB.SILVER.EMPLOYEES e
    ON d.department_id = e.department_id
LEFT JOIN CURRENT_SALARY s
    ON e.employee_id = s.employee_id
GROUP BY d.department_id, d.department_name;
