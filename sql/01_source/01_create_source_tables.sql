-- Step 2: Create small source-style HR tables for practice.
CREATE TABLE IF NOT EXISTS HR_DB.HR_SCHEMA.DEPARTMENTS
(
    department_id   NUMBER(10,0),
    department_name VARCHAR(100),
    location        VARCHAR(100),
    updated_at      TIMESTAMP_NTZ
);

CREATE TABLE IF NOT EXISTS HR_DB.HR_SCHEMA.EMPLOYEES
(
    employee_id       NUMBER(10,0),
    first_name        VARCHAR(100),
    last_name         VARCHAR(100),
    email             VARCHAR(200),
    hire_date         DATE,
    job_title         VARCHAR(100),
    department_id     NUMBER(10,0),
    manager_id        NUMBER(10,0),
    is_active         BOOLEAN,
    source_updated_at TIMESTAMP_NTZ
);

CREATE TABLE IF NOT EXISTS HR_DB.HR_SCHEMA.SALARIES
(
    salary_id      NUMBER(10,0) AUTOINCREMENT START 1 INCREMENT 1,
    employee_id    NUMBER(10,0),
    salary_amount  NUMBER(12,2),
    effective_from DATE,
    effective_to   DATE,
    updated_at     TIMESTAMP_NTZ
);
