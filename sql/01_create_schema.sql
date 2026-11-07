CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE IF NOT EXISTS dw.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name TEXT NOT NULL,
    day INTEGER NOT NULL,
    day_name TEXT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS dw.dim_team (
    team_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    team_id TEXT NOT NULL,
    team_city TEXT,
    team_name TEXT NOT NULL,
    UNIQUE (team_id, team_city, team_name)
);

CREATE TABLE IF NOT EXISTS dw.dim_arena (
    arena_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    arena_id TEXT UNIQUE NOT NULL,
    arena_name TEXT,
    arena_city TEXT,
    arena_state TEXT
);

CREATE TABLE IF NOT EXISTS dw.dim_game_type (
    game_type_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    game_type TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS dw.fact_game (
    game_id TEXT PRIMARY KEY,
    date_key INTEGER NOT NULL REFERENCES dw.dim_date(date_key),
    home_team_key BIGINT NOT NULL REFERENCES dw.dim_team(team_key),
    away_team_key BIGINT NOT NULL REFERENCES dw.dim_team(team_key),
    arena_key BIGINT REFERENCES dw.dim_arena(arena_key),
    game_type_key BIGINT NOT NULL REFERENCES dw.dim_game_type(game_type_key),

    home_score INTEGER NOT NULL CHECK (home_score >= 0),
    away_score INTEGER NOT NULL CHECK (away_score >= 0),
    winner_team_id TEXT NOT NULL,

    attendance INTEGER,
    series_game_number INTEGER,
    game_datetime_est TIMESTAMP,
    game_subtype TEXT,
    game_label TEXT,
    game_sub_label TEXT,
    officials TEXT
);

CREATE INDEX IF NOT EXISTS idx_fact_game_date
    ON dw.fact_game(date_key);

CREATE INDEX IF NOT EXISTS idx_fact_game_home_team
    ON dw.fact_game(home_team_key);

CREATE INDEX IF NOT EXISTS idx_fact_game_away_team
    ON dw.fact_game(away_team_key);

CREATE INDEX IF NOT EXISTS idx_fact_game_type
    ON dw.fact_game(game_type_key);

CREATE INDEX IF NOT EXISTS idx_fact_game_arena
    ON dw.fact_game(arena_key);
