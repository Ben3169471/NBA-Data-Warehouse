-- LAB 2: Create final typed NBA games table
-- Source: etl.cleaned_games
-- Expected records: 73,470

CREATE TABLE etl.typed_games_final AS
SELECT
    game_id::BIGINT AS game_id,
    game_datetime_est::TIMESTAMP AS game_datetime_est,
    home_team_city,
    home_team_name,
    home_team_id::BIGINT AS home_team_id,
    away_team_city,
    away_team_name,
    away_team_id::BIGINT AS away_team_id,
    home_score::INTEGER AS home_score,
    away_score::INTEGER AS away_score,
    winner::BIGINT AS winner,
    game_type,
    game_subtype,
    game_label,
    game_sub_label,
    series_game_number,
    attendance::INTEGER AS attendance,
    arena_id::BIGINT AS arena_id,
    arena_name,
    arena_city,
    arena_state,
    officials,
    game_date::TIMESTAMP AS game_date
FROM etl.cleaned_games;
