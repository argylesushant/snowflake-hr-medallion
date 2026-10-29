-- Step 6: Initial Silver build from Bronze.
-- This file uses CREATE OR REPLACE and is intended for the initial build only.
-- Do not rerun it after incremental processing starts, or it will rebuild Silver from Bronze.

CREATE OR REPLACE TABLE HR_DB.SILVER.EMPLOYEES AS
SELECT
    TRY_TO_NUMBER(employee_id_raw)::NUMBER(10,0) AS employee_id,
    NULLIF(TRIM(first_name_raw), '') AS first_name,
    NULLIF(TRIM(last_name_raw), '') AS last_name,
    NULLIF(TRIM(email_raw), '') AS email,
    TRY_TO_DATE(hire_date_raw) AS hire_date,
    NULLIF(TRIM(job_title_raw), '') AS job_title,
    TRY_TO_NUMBER(department_id_raw)::NUMBER(10,0) AS department_id,
    TRY_TO_NUMBER(manager_id_raw)::NUMBER(10,0) AS manager_id,
    COALESCE(TRY_TO_BOOLEAN(is_active_raw), TRUE) AS is_active,
    COALESCE(
        TRY_TO_TIMESTAMP_NTZ(source_updated_at_raw),
        loaded_at::TIMESTAMP_NTZ
    ) AS source_updated_at,
    source_file,
    loaded_at
FROM HR_DB.BRONZE.EMPLOYEES_RAW
WHERE TRY_TO_NUMBER(employee_id_raw) IS NOT NULL
  AND NULLIF(TRIM(first_name_raw), '') IS NOT NULL
  AND NULLIF(TRIM(last_name_raw), '') IS NOT NULL
QUALIFY ROW_NUMBER() OVER
(
    PARTITION BY TRY_TO_NUMBER(employee_id_raw)
    ORDER BY
        COALESCE(TRY_TO_TIMESTAMP_NTZ(source_updated_at_raw), loaded_at::TIMESTAMP_NTZ) DESC,
        loaded_at DESC
) = 1;

CREATE OR REPLACE TABLE HR_DB.SILVER.DEPARTMENTS AS
SELECT
    TRY_TO_NUMBER(department_id_raw)::NUMBER(10,0) AS department_id,
    NULLIF(TRIM(department_name_raw), '') AS department_name,
    NULLIF(TRIM(location_raw), '') AS location,
    COALESCE(TRY_TO_TIMESTAMP_NTZ(updated_at_raw), loaded_at::TIMESTAMP_NTZ) AS updated_at,
    source_file,
    loaded_at
FROM HR_DB.BRONZE.DEPARTMENTS_RAW
WHERE TRY_TO_NUMBER(department_id_raw) IS NOT NULL
  AND NULLIF(TRIM(department_name_raw), '') IS NOT NULL
QUALIFY ROW_NUMBER() OVER
(
    PARTITION BY TRY_TO_NUMBER(department_id_raw)
    ORDER BY
        COALESCE(TRY_TO_TIMESTAMP_NTZ(updated_at_raw), loaded_at::TIMESTAMP_NTZ) DESC,
        loaded_at DESC
) = 1;

CREATE OR REPLACE TABLE HR_DB.SILVER.SALARIES AS
SELECT
    TRY_TO_NUMBER(salary_id_raw)::NUMBER(10,0) AS salary_id,
    TRY_TO_NUMBER(employee_id_raw)::NUMBER(10,0) AS employee_id,
    TRY_TO_DECIMAL(salary_amount_raw, 12, 2) AS salary_amount,
    TRY_TO_DATE(effective_from_raw) AS effective_from,
    TRY_TO_DATE(effective_to_raw) AS effective_to,
    COALESCE(TRY_TO_TIMESTAMP_NTZ(updated_at_raw), loaded_at::TIMESTAMP_NTZ) AS updated_at,
    source_file,
    loaded_at
FROM HR_DB.BRONZE.SALARIES_RAW
WHERE TRY_TO_NUMBER(salary_id_raw) IS NOT NULL
  AND TRY_TO_NUMBER(employee_id_raw) IS NOT NULL
  AND TRY_TO_DECIMAL(salary_amount_raw, 12, 2) IS NOT NULL
  AND TRY_TO_DATE(effective_from_raw) IS NOT NULL
QUALIFY ROW_NUMBER() OVER
(
    PARTITION BY TRY_TO_NUMBER(salary_id_raw)
    ORDER BY
        COALESCE(TRY_TO_TIMESTAMP_NTZ(updated_at_raw), loaded_at::TIMESTAMP_NTZ) DESC,
        loaded_at DESC
) = 1;
