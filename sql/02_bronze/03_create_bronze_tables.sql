-- Step 4: Raw Bronze tables. Values are retained as strings where practical.
CREATE TABLE IF NOT EXISTS HR_DB.BRONZE.EMPLOYEES_RAW
(
    employee_id_raw       VARCHAR,
    first_name_raw        VARCHAR,
    last_name_raw         VARCHAR,
    email_raw             VARCHAR,
    hire_date_raw         VARCHAR,
    job_title_raw         VARCHAR,
    department_id_raw     VARCHAR,
    manager_id_raw        VARCHAR,
    is_active_raw         VARCHAR,
    source_updated_at_raw VARCHAR,
    source_file           VARCHAR,
    loaded_at             TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS HR_DB.BRONZE.DEPARTMENTS_RAW
(
    department_id_raw   VARCHAR,
    department_name_raw VARCHAR,
    location_raw        VARCHAR,
    updated_at_raw      VARCHAR,
    source_file         VARCHAR,
    loaded_at           TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE IF NOT EXISTS HR_DB.BRONZE.SALARIES_RAW
(
    salary_id_raw      VARCHAR,
    employee_id_raw    VARCHAR,
    salary_amount_raw  VARCHAR,
    effective_from_raw VARCHAR,
    effective_to_raw   VARCHAR,
    updated_at_raw     VARCHAR,
    source_file        VARCHAR,
    loaded_at          TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
