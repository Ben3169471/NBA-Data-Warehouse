# NBA Data Warehouse

A PostgreSQL-based data warehouse project for organizing historical NBA game records.

## Project Overview

This project uses a Star Schema design and an ETL process to transform raw NBA game records into structured data for analysis.

## Technology Stack

- PostgreSQL 16
- Docker Compose
- SQL
- Fedora Linux

## Data Warehouse Schema

### Fact Table
- `dw.fact_game`

### Dimension Tables
- `dw.dim_date`
- `dw.dim_team`
- `dw.dim_arena`
- `dw.dim_game_type`

### Supporting Schemas
- `stg` - Raw staging data
- `etl` - Cleaned and transformed data
- `dw` - Data warehouse tables

## Dataset Summary

| Metric | Result |
|---|---:|
| Total games | 73,470 |
| First game date | 1946-11-26 |
| Last game date | 2026-11-05 |
| Teams | 71 |
| Arenas | 276 |
| Game types | 8 |
| Date dimension rows | 29,200 |

## ETL Pipeline

1. Load raw records into staging.
2. Profile the source data.
3. Clean and normalize values.
4. Transform data types.
5. Load dimension tables.
6. Load the fact table.
7. Validate records and data quality.

## Data Quality Summary

- Total fact rows: 73,470
- Unique game IDs: 73,470
- Duplicate game IDs: 0
- Missing checked critical fields: 0
- Invalid negative scores: 0
- Missing attendance values: 71,887

Attendance averages use only records with available attendance values.

## Documentation

- Lab 1: `docs/LAB_1_DOCUMENTATION.md`
- Lab 2: `docs/LAB_2_DOCUMENTATION.md`
- Project report: `docs/reports/NBA_DW_Summary.html`
- Star Schema: `docs/diagrams/star_schema.svg`
- ETL Pipeline: `docs/diagrams/etl_pipeline.svg`

## Conclusion

This project organizes historical NBA game records into a structured PostgreSQL data warehouse for querying and analysis.
