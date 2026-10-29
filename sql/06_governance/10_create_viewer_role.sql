-- Optional: run with a role that is allowed to create roles and grant privileges.
CREATE ROLE IF NOT EXISTS HR_DATA_VIEWER;

GRANT USAGE ON DATABASE HR_DB TO ROLE HR_DATA_VIEWER;
GRANT USAGE ON SCHEMA HR_DB.GOLD TO ROLE HR_DATA_VIEWER;
GRANT SELECT ON VIEW HR_DB.GOLD.DEPARTMENT_SUMMARY TO ROLE HR_DATA_VIEWER;

-- Replace the placeholder with an existing Snowflake username if assigning the role:
-- GRANT ROLE HR_DATA_VIEWER TO USER YOUR_SNOWFLAKE_USERNAME;
