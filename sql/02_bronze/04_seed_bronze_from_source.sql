-- Step 5: One-time initial seed from the sample source tables into Bronze.
-- Do not run this repeatedly unless you intentionally want duplicate raw batches.
INSERT INTO HR_DB.BRONZE.EMPLOYEES_RAW
(
    employee_id_raw, first_name_raw, last_name_raw, email_raw, hire_date_raw,
    job_title_raw, department_id_raw, manager_id_raw, is_active_raw,
    source_updated_at_raw, source_file
)
SELECT
    employee_id::VARCHAR, first_name, last_name, email, hire_date::VARCHAR,
    job_title, department_id::VARCHAR, manager_id::VARCHAR, is_active::VARCHAR,
    TO_VARCHAR(source_updated_at, 'YYYY-MM-DD HH24:MI:SS'),
    'HR_SCHEMA.EMPLOYEES'
FROM HR_DB.HR_SCHEMA.EMPLOYEES;

INSERT INTO HR_DB.BRONZE.DEPARTMENTS_RAW
(
    department_id_raw, department_name_raw, location_raw, updated_at_raw, source_file
)
SELECT
    department_id::VARCHAR, department_name, location,
    TO_VARCHAR(updated_at, 'YYYY-MM-DD HH24:MI:SS'),
    'HR_SCHEMA.DEPARTMENTS'
FROM HR_DB.HR_SCHEMA.DEPARTMENTS;

INSERT INTO HR_DB.BRONZE.SALARIES_RAW
(
    salary_id_raw, employee_id_raw, salary_amount_raw, effective_from_raw,
    effective_to_raw, updated_at_raw, source_file
)
SELECT
    salary_id::VARCHAR, employee_id::VARCHAR, salary_amount::VARCHAR,
    effective_from::VARCHAR, effective_to::VARCHAR,
    TO_VARCHAR(updated_at, 'YYYY-MM-DD HH24:MI:SS'),
    'HR_SCHEMA.SALARIES'
FROM HR_DB.HR_SCHEMA.SALARIES;
