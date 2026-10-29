# Architecture and design decisions

## Bronze

Bronze keeps source values as strings where practical and records `source_file` and `loaded_at`. In this learning setup it is seeded from the sample source tables; a real pipeline could load staged CSV files with `COPY INTO`.

## Silver

Silver casts values into appropriate types, trims strings, filters null employee keys and blank names, and deduplicates by business key using `ROW_NUMBER` and `QUALIFY`. A production pipeline should write rejected data to a quarantine table instead of simply filtering it out.

## Gold

The Gold view calculates active employees and current salary metrics per department. The `CURRENT_SALARY` CTE keeps one salary record effective on the current date per employee.

## Incremental processing

The demo uses an append-only Stream because it appends a new row for every source change. `MERGE` handles new employee IDs and updates existing rows. If the upstream source mutates rows or emits deletes, use a standard Stream/CDC design and add delete handling.

## Production improvements

- Add a rejection/quarantine table and data-quality metrics.
- Add automated SQL tests and CI checks.
- Introduce schema migration/versioning conventions.
- Orchestrate and monitor jobs using Snowflake Tasks or an external orchestrator.
- Add masking policies and least-privilege grants for PII and salary data.
- Do not store secrets or real employee data in Git.
