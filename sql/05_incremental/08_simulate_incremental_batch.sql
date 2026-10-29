-- Step 9: Simulate a newly arrived incremental employee record.
INSERT INTO HR_DB.BRONZE.EMPLOYEES_RAW
(
    employee_id_raw, first_name_raw, last_name_raw, email_raw, hire_date_raw,
    job_title_raw, department_id_raw, manager_id_raw, is_active_raw,
    source_updated_at_raw, source_file, loaded_at
)
SELECT
    '1005', 'Rahul', 'Patil', 'rahul@example.com', '2026-01-15',
    'Data Engineer', '30', '1004', 'TRUE',
    TO_VARCHAR(CURRENT_TIMESTAMP()::TIMESTAMP_NTZ, 'YYYY-MM-DD HH24:MI:SS'),
    'incremental_batch_001.csv', CURRENT_TIMESTAMP();

-- Inspect unconsumed changes before running the MERGE.
SELECT * FROM HR_DB.BRONZE.EMPLOYEES_RAW_STREAM;
