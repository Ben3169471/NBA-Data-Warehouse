-- 1. LOAD DATE DIMENSION
INSERT INTO dw.dim_date (
    date_key, full_date, year, quarter,
    month, month_name, day, day_name, is_weekend
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER,
    d::DATE,
    EXTRACT(YEAR FROM d)::INTEGER,
    EXTRACT(QUARTER FROM d)::INTEGER,
    EXTRACT(MONTH FROM d)::INTEGER,
    TO_CHAR(d, 'FMMonth'),
    EXTRACT(DAY FROM d)::INTEGER,
    TO_CHAR(d, 'FMDay'),
    EXTRACT(ISODOW FROM d) IN (6, 7)
FROM GENERATE_SERIES(
    (SELECT MIN(game_date::TIMESTAMP)::DATE FROM stg.raw_games),
    (SELECT MAX(game_date::TIMESTAMP)::DATE FROM stg.raw_games),
    INTERVAL '1 day'
) AS d
ON CONFLICT (date_key) DO NOTHING;


-- 2. LOAD HOME TEAM DIMENSION
INSERT INTO dw.dim_team (team_id, team_city, team_name)
SELECT DISTINCT
    TRIM(home_team_id),
    NULLIF(TRIM(home_team_city), ''),
    COALESCE(NULLIF(TRIM(home_team_name), ''), 'Unknown')
FROM stg.raw_games
WHERE NULLIF(TRIM(home_team_id), '') IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM dw.dim_team t
    WHERE t.team_id = TRIM(stg.raw_games.home_team_id)
      AND t.team_city IS NOT DISTINCT FROM
          NULLIF(TRIM(stg.raw_games.home_team_city), '')
      AND t.team_name = COALESCE(
          NULLIF(TRIM(stg.raw_games.home_team_name), ''),
          'Unknown'
      )
);


-- 3. LOAD AWAY TEAM DIMENSION
INSERT INTO dw.dim_team (team_id, team_city, team_name)
SELECT DISTINCT
    TRIM(away_team_id),
    NULLIF(TRIM(away_team_city), ''),
    COALESCE(NULLIF(TRIM(away_team_name), ''), 'Unknown')
FROM stg.raw_games
WHERE NULLIF(TRIM(away_team_id), '') IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM dw.dim_team t
    WHERE t.team_id = TRIM(stg.raw_games.away_team_id)
      AND t.team_city IS NOT DISTINCT FROM
          NULLIF(TRIM(stg.raw_games.away_team_city), '')
      AND t.team_name = COALESCE(
          NULLIF(TRIM(stg.raw_games.away_team_name), ''),
          'Unknown'
      )
);


-- 4. LOAD ARENA DIMENSION
INSERT INTO dw.dim_arena (
    arena_id, arena_name, arena_city, arena_state
)
SELECT DISTINCT ON (TRIM(arena_id))
    TRIM(arena_id),
    NULLIF(TRIM(arena_name), ''),
    NULLIF(TRIM(arena_city), ''),
    NULLIF(TRIM(arena_state), '')
FROM stg.raw_games
WHERE NULLIF(TRIM(arena_id), '') IS NOT NULL
ORDER BY
    TRIM(arena_id),
    (NULLIF(TRIM(arena_name), '') IS NOT NULL) DESC
ON CONFLICT (arena_id) DO NOTHING;


-- 5. LOAD GAME TYPE DIMENSION
INSERT INTO dw.dim_game_type (game_type)
SELECT DISTINCT TRIM(game_type)
FROM stg.raw_games
WHERE NULLIF(TRIM(game_type), '') IS NOT NULL
ON CONFLICT (game_type) DO NOTHING;
