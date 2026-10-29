-- Step 10: Upsert appended Stream records into Silver.
-- Run after 08_simulate_incremental_batch.sql.
MERGE INTO HR_DB.SILVER.EMPLOYEES AS T
USING
(
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
        COALESCE(TRY_TO_TIMESTAMP_NTZ(source_updated_at_raw), loaded_at::TIMESTAMP_NTZ) AS source_updated_at,
        source_file,
        loaded_at
    FROM HR_DB.BRONZE.EMPLOYEES_RAW_STREAM
    WHERE TRY_TO_NUMBER(employee_id_raw) IS NOT NULL
      AND NULLIF(TRIM(first_name_raw), '') IS NOT NULL
      AND NULLIF(TRIM(last_name_raw), '') IS NOT NULL
    QUALIFY ROW_NUMBER() OVER
    (
        PARTITION BY TRY_TO_NUMBER(employee_id_raw)
        ORDER BY
            COALESCE(TRY_TO_TIMESTAMP_NTZ(source_updated_at_raw), loaded_at::TIMESTAMP_NTZ) DESC,
            loaded_at DESC
    ) = 1
) AS S
ON T.employee_id = S.employee_id
WHEN MATCHED AND S.source_updated_at >= T.source_updated_at THEN
    UPDATE SET
        T.first_name = S.first_name,
        T.last_name = S.last_name,
        T.email = S.email,
        T.hire_date = S.hire_date,
        T.job_title = S.job_title,
        T.department_id = S.department_id,
        T.manager_id = S.manager_id,
        T.is_active = S.is_active,
        T.source_updated_at = S.source_updated_at,
        T.source_file = S.source_file,
        T.loaded_at = S.loaded_at
WHEN NOT MATCHED THEN
    INSERT
    (
        employee_id, first_name, last_name, email, hire_date, job_title,
        department_id, manager_id, is_active, source_updated_at, source_file, loaded_at
    )
    VALUES
    (
        S.employee_id, S.first_name, S.last_name, S.email, S.hire_date, S.job_title,
        S.department_id, S.manager_id, S.is_active, S.source_updated_at, S.source_file, S.loaded_at
    );
