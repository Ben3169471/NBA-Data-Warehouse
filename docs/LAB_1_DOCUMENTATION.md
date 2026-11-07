# LAB 1: NBA STAR SCHEMA DEVELOPMENT

## 1. Project Overview

The NBA Data Warehouse is a PostgreSQL-based data warehouse project
designed to store, organize, and analyze historical NBA game records.

The project uses a star schema design consisting of one fact table
and four dimension tables.

## 2. Project Objectives

- Import NBA game records into PostgreSQL.
- Create a staging table for raw CSV data.
- Perform initial data profiling.
- Build dimension and fact tables.
- Load game records into the data warehouse.
- Validate the completeness and relationships of the data.

## 3. Dataset Information

Dataset file: Games.csv

Total game records: 73,470

Date coverage:
- Earliest game: November 26, 1946
- Latest game: November 5, 2026

The dataset contains information about:
- Game dates and game IDs
- Home and away teams
- Scores and winners
- Game types
- Arenas and locations
- Attendance
- Officials

## 4. Database Technology

- Database: PostgreSQL
- PostgreSQL version: 16
- Containerization: Docker Compose
- Database name: nba_dw
- Database user: nba_user

## 5. Data Warehouse Schema

Schema name: dw

### Dimension Tables

1. dim_date
   Stores calendar information such as date, year, month,
   quarter, and day.

2. dim_team
   Stores historical NBA team profiles, including team IDs,
   cities, and team names.

3. dim_arena
   Stores arena IDs, names, cities, and states.

4. dim_game_type
   Stores the different types of NBA games.

### Fact Table

fact_game

Stores NBA game records, including:
- Game ID
- Date key
- Home team key
- Away team key
- Arena key
- Game type key
- Home and away scores
- Winner team ID
- Attendance
- Other game information

## 6. Staging Table

Table: stg.raw_games

The staging table temporarily stores the original CSV records
before they are loaded into the data warehouse.

Total imported records: 73,470

## 7. Data Profiling Results

| Data Check | Result |
|---|---:|
| Total game records | 73,470 |
| Duplicate game IDs | 0 |
| Missing core fields | 0 |
| Invalid scores | 0 |
| Games with the same home and away team | 0 |
| Historical team profiles | 71 |
| Arenas | 276 |
| Game types | 8 |

## 8. Data Loading Results

The data was loaded from the staging table into the dimension
tables and fact table.

| Table | Loaded Records |
|---|---:|
| dim_date | 29,200 |
| dim_team | 71 |
| dim_arena | 276 |
| dim_game_type | 8 |
| fact_game | 73,470 |

## 9. Attendance Data

| Attendance Information | Records |
|---|---:|
| Total games | 73,470 |
| Games with attendance | 1,583 |
| Missing attendance | 71,887 |
| Minimum recorded attendance | 0 |
| Maximum recorded attendance | 22,093 |

Missing attendance values are stored as NULL rather than
being automatically changed to zero.

## 10. Relationship Validation

The fact table was checked against its required dimension tables.

| Validation | Missing Records |
|---|---:|
| Date relationship | 0 |
| Home team relationship | 0 |
| Away team relationship | 0 |
| Game type relationship | 0 |

All 73,470 fact records passed these relationship checks.

## 11. SQL Scripts

The following SQL scripts were created:

- 01_create_schema.sql
- 02_create_staging.sql
- 03_data_profiling.sql
- 04_load_dimensions.sql
- 05_load_fact_games.sql

## 12. Conclusion

Lab 1 successfully established the NBA Data Warehouse
using PostgreSQL and a star schema design.

The database contains 73,470 NBA game records, four dimension
tables, and one fact table.

Initial data profiling, loading, and relationship validation
were completed successfully.

The completed data warehouse will serve as the foundation
for Lab 2: NBA Data Cleaning and ETL, followed by Lab 3:
NBA Data Analysis and Visualization using Tableau.
