# LAB 2: Data Cleaning and ETL

## 1. Overview

This laboratory focuses on cleaning, validating, and transforming the NBA games dataset from the staging table into a final typed dataset using PostgreSQL.

The goal is to prepare reliable and properly typed data for analysis and dashboard development.

## 2. Dataset Information

- Dataset: Games.csv
- Source table: stg.raw_games
- Original records: 73,470
- Columns: 23
- Earliest game: November 26, 1946
- Latest game: November 5, 2026

## 3. Tools and Technologies

- Fedora Linux
- Docker Compose
- PostgreSQL 16
- SQL

## 4. ETL Process

The following steps were completed:

1. Checked the database and staging table.
2. Profiled the source data for blank values and extra spaces.
3. Inspected missing team cities and officials formatting.
4. Created the etl schema.
5. Created etl.cleaned_games from stg.raw_games.
6. Trimmed leading and trailing spaces using BTRIM.
7. Converted empty strings into NULL using NULLIF.
8. Validated required fields and unique game IDs.
9. Checked whether values were compatible with numeric and timestamp data types.
10. Created a typed intermediate table.
11. Validated scores, attendance, team IDs, and winner IDs.
12. Created etl.typed_games_final with appropriate PostgreSQL data types.

## 5. Data Cleaning Results

The cleaned dataset contains:

| Validation | Result |
|---|---:|
| Total records | 73,470 |
| Unique game IDs | 73,470 |
| Missing required fields | 0 |
| Columns with extra leading/trailing spaces | 0 |

Empty optional values were converted to NULL. Missing values were preserved rather than replaced with invented information.

## 6. Missing Optional Values

Some optional fields contain missing values:

| Column | NULL records |
|---|---:|
| home_team_city | 7 |
| away_team_city | 7 |
| game_subtype | 73,384 |
| game_label | 69,350 |
| game_sub_label | 73,128 |
| attendance | 71,887 |
| arena_name | 71,879 |
| arena_city | 71,879 |
| arena_state | 71,890 |
| officials | 71,879 |
| series_game_number | 67,647 |

The seven records with missing team cities belong to 2026 NBA All-Star events. Their original values were preserved as NULL.

## 7. Data Type Transformation

The final table is named `etl.typed_games_final`.

Important data types include:

| Column | PostgreSQL data type |
|---|---|
| game_id | BIGINT |
| game_datetime_est | TIMESTAMP |
| home_team_id | BIGINT |
| away_team_id | BIGINT |
| home_score | INTEGER |
| away_score | INTEGER |
| winner | BIGINT |
| attendance | INTEGER |
| arena_id | BIGINT |
| game_date | TIMESTAMP |

Text fields such as team names, game types, arena names, and officials remain TEXT.

The `series_game_number` column remains TEXT because its source values use different formats, including values such as `0.0` and `Game 1`. Keeping it as TEXT preserves the original information.

## 8. Data Quality Validation

### Record validation

| Check | Result |
|---|---:|
| Total final records | 73,470 |
| Unique game IDs | 73,470 |
| Missing winners | 0 |

### Score and attendance validation

| Check | Result |
|---|---:|
| Negative home scores | 0 |
| Negative away scores | 0 |
| Negative attendance values | 0 |
| Same home and away team | 0 |
| Tied-score records | 4 |

Four tied-score records were inspected and compared with the staging source. Their values were already present in the original dataset, so they were preserved without modification.

### Winner validation

| Check | Result |
|---|---:|
| Total games checked | 73,470 |
| Invalid winner IDs | 0 |
| Home winner mismatches | 0 |
| Away winner mismatches | 0 |

All winner IDs correspond to either the home team or the away team. No winner and score mismatches were found by these checks.

## 9. SQL Scripts

The following scripts were used in the project:

- `sql/01_create_schema.sql`
- `sql/02_create_staging.sql`
- `sql/03_data_profiling.sql`
- `sql/04_load_dimensions.sql`
- `sql/05_load_fact_games.sql`
- `sql/06_create_cleaned_games.sql`
- `sql/07_create_typed_games.sql`

## 10. Final ETL Result

The final typed table, `etl.typed_games_final`, contains 73,470 records with unique game IDs.

The data cleaning process removed extra whitespace, converted empty strings into NULL values, and transformed suitable fields into numeric and timestamp data types.

The final dataset is ready for the next stage of the NBA Data Warehouse project: data analysis and dashboard development.

## 11. Conclusion

Lab 2 successfully completed the data cleaning and ETL process for the NBA games dataset. The final dataset passed the required record, data type, and winner validation checks.

The original source values were preserved when missing or unusual values could not be safely corrected. The cleaned and typed dataset will serve as the basis for the next laboratory activity.
