-- Step 3: Run once to populate the source-style HR tables.
INSERT INTO HR_DB.HR_SCHEMA.DEPARTMENTS
    (department_id, department_name, location, updated_at)
VALUES
    (10, 'Engineering', 'Pune', CURRENT_TIMESTAMP()),
    (20, 'Human Resources', 'Mumbai', CURRENT_TIMESTAMP()),
    (30, 'Analytics', 'Bengaluru', CURRENT_TIMESTAMP());

INSERT INTO HR_DB.HR_SCHEMA.EMPLOYEES
    (employee_id, first_name, last_name, email, hire_date, job_title,
     department_id, manager_id, is_active, source_updated_at)
VALUES
    (1001, 'Alex',  'Johnson', 'alex@example.com',  '2020-01-15', 'Engineering Manager', 10, NULL, TRUE, CURRENT_TIMESTAMP()),
    (1002, 'John',  'Doe',     'john@example.com',  '2021-03-22', 'Software Engineer',   10, 1001, TRUE, CURRENT_TIMESTAMP()),
    (1003, 'Jane',  'Smith',   'jane@example.com',  '2022-07-10', 'HR Specialist',       20, NULL, TRUE, CURRENT_TIMESTAMP()),
    (1004, 'Priya', 'Shah',    'priya@example.com', '2023-02-12', 'Data Analyst',        30, 1001, TRUE, CURRENT_TIMESTAMP());

INSERT INTO HR_DB.HR_SCHEMA.SALARIES
    (employee_id, salary_amount, effective_from, effective_to, updated_at)
VALUES
    (1001, 115000, '2025-01-01', NULL,         CURRENT_TIMESTAMP()),
    (1002,  65000, '2024-01-01', '2024-12-31', CURRENT_TIMESTAMP()),
    (1002,  75000, '2025-01-01', NULL,         CURRENT_TIMESTAMP()),
    (1003,  62000, '2025-01-01', NULL,         CURRENT_TIMESTAMP()),
    (1004,  85000, '2025-01-01', NULL,         CURRENT_TIMESTAMP());
