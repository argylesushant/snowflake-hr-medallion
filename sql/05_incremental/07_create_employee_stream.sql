-- Step 8: Create after initial Bronze seeding and initial Silver build.
-- APPEND_ONLY is appropriate for this demo because each source change arrives as a new inserted row.
CREATE STREAM IF NOT EXISTS HR_DB.BRONZE.EMPLOYEES_RAW_STREAM
    ON TABLE HR_DB.BRONZE.EMPLOYEES_RAW
    APPEND_ONLY = TRUE;
