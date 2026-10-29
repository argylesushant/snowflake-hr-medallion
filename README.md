# Snowflake HR Medallion Data Platform

A learning project that models a small HR source system in Snowflake and demonstrates Bronze, Silver, and Gold layers, incremental processing with a Snowflake Stream and `MERGE`, basic data-quality checks, and least-privilege access to a Gold reporting view.

## Architecture

```text
Source HR tables (HR_DB.HR_SCHEMA)
            |
            | initial seed (or a real file load with COPY INTO)
            v
Bronze raw tables (HR_DB.BRONZE)
            |
            | validate types, reject invalid keys/names, deduplicate
            v
Silver tables (HR_DB.SILVER)
            |
            | current salary + department metrics
            v
Gold view (HR_DB.GOLD.DEPARTMENT_SUMMARY)
```

## Prerequisites

- A Snowflake account and a worksheet/Workspace with a warehouse selected.
- A role that can create the database/schemas/tables and, for the governance script, create roles and grant privileges. Some accounts require an administrator to perform the role/integration steps.
- Git installed locally if you want to publish this project to GitHub from the terminal.

## SQL run order

Open the files in Snowsight and execute them in this order. Use a single worksheet/session or fully qualified object names as provided.

1. `sql/00_setup/00_create_database_schemas.sql`
2. `sql/01_source/01_create_source_tables.sql`
3. `sql/01_source/02_insert_sample_data.sql` — run this only once for the initial dataset.
4. `sql/02_bronze/03_create_bronze_tables.sql`
5. `sql/02_bronze/04_seed_bronze_from_source.sql` — run once for the initial Bronze seed.
6. `sql/03_silver/05_build_silver_initial.sql` — creates/rebuilds Silver from the initial Bronze snapshot. Do not rerun after starting incremental processing, because it replaces the Silver tables.
7. `sql/04_gold/06_create_department_summary_view.sql`
8. `sql/05_incremental/07_create_employee_stream.sql` — create the Stream after the initial Bronze load and Silver build.
9. `sql/07_tests/11_data_quality_checks.sql` — inspect the baseline results.
10. `sql/05_incremental/08_simulate_incremental_batch.sql` — inserts one new employee into Bronze to simulate a new batch.
11. `sql/05_incremental/09_merge_employee_stream_to_silver.sql` — merges the new employee into Silver.
12. Run `sql/07_tests/11_data_quality_checks.sql` again and query the Gold view.
13. `sql/06_governance/10_create_viewer_role.sql` is optional and may require elevated privileges.

## Expected results

- Initial source employees: 4.
- After initial Bronze seeding: 4 raw employee rows.
- After the incremental demo insert and merge: 5 employees in Silver.
- The Gold view returns 3 departments; after the incremental demo, Analytics has 2 active employees.

## Notes and safety

- `HR_SCHEMA` is a sample source dataset for this exercise. Real systems would usually ingest from an application/database or files delivered to a stage.
- The three data layers are separate schemas: `BRONZE`, `SILVER`, and `GOLD`.
- The initial Silver script uses `CREATE OR REPLACE TABLE ... AS SELECT`; it is for the first build only. For ongoing processing, use the incremental `MERGE` script.
- The incremental Stream is `APPEND_ONLY = TRUE` and therefore assumes changes arrive as inserted batch rows. If the upstream source updates or deletes rows in place and you need to capture those operations, design a standard Stream/CDC approach and implement delete handling.
- This is a training project, not a complete production deployment framework. Add a quarantine table for rejected records, stronger tests, orchestration, monitoring, and migration management before production use.
- Never commit account passwords, private keys, tokens, personal employee data, or Snowflake connection files to GitHub.

## Useful queries

```sql
SELECT * FROM HR_DB.SILVER.EMPLOYEES ORDER BY employee_id;
SELECT * FROM HR_DB.GOLD.DEPARTMENT_SUMMARY ORDER BY department_id;
SELECT * FROM HR_DB.BRONZE.EMPLOYEES_RAW_STREAM;
```

## Local Git / GitHub quick start

From PowerShell in this folder:

```powershell
git init -b main
git add .
git commit -m "Initial Snowflake HR medallion project"
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/snowflake-hr-medallion.git
git push -u origin main
```

Create the empty repository on GitHub first and replace `YOUR_GITHUB_USERNAME` with your account name. Do not initialize the GitHub repository with a README if you use these exact commands.

## Optional: connect the GitHub repo to Snowflake

After pushing the project to GitHub, see the step-by-step instructions in the accompanying chat response. Native Snowflake Git integration needs an API integration and a Git repository clone, and may require elevated privileges. A clone can fetch files from GitHub; SQL files can then be executed from the clone with `EXECUTE IMMEDIATE FROM` after reviewing them.
