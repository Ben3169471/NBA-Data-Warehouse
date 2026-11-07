-- LOAD NBA GAME FACTS
INSERT INTO dw.fact_game (
    game_id,
    date_key,
    home_team_key,
    away_team_key,
    arena_key,
    game_type_key,
    home_score,
    away_score,
    winner_team_id,
    attendance,
    series_game_number,
    game_datetime_est,
    game_subtype,
    game_label,
    game_sub_label,
    officials
)
SELECT
    TRIM(r.game_id),
    d.date_key,
    ht.team_key,
    at.team_key,
    ar.arena_key,
    gt.game_type_key,
    TRIM(r.home_score)::INTEGER,
    TRIM(r.away_score)::INTEGER,
    NULLIF(TRIM(r.winner), ''),
    CASE
        WHEN TRIM(r.attendance) ~ '^[0-9]+$'
        THEN TRIM(r.attendance)::INTEGER
        ELSE NULL
    END,
    CASE
        WHEN TRIM(r.series_game_number) ~ '^[0-9]+$'
        THEN TRIM(r.series_game_number)::INTEGER
        ELSE NULL
    END,
    NULLIF(TRIM(r.game_datetime_est), '')::TIMESTAMP,
    NULLIF(TRIM(r.game_subtype), ''),
    NULLIF(TRIM(r.game_label), ''),
    NULLIF(TRIM(r.game_sub_label), ''),
    NULLIF(TRIM(r.officials), '')
FROM stg.raw_games r
JOIN dw.dim_date d
    ON d.full_date = r.game_date::TIMESTAMP::DATE
JOIN dw.dim_team ht
    ON ht.team_id = TRIM(r.home_team_id)
    AND ht.team_city IS NOT DISTINCT FROM
        NULLIF(TRIM(r.home_team_city), '')
    AND ht.team_name = COALESCE(
        NULLIF(TRIM(r.home_team_name), ''),
        'Unknown'
    )
JOIN dw.dim_team at
    ON at.team_id = TRIM(r.away_team_id)
    AND at.team_city IS NOT DISTINCT FROM
        NULLIF(TRIM(r.away_team_city), '')
    AND at.team_name = COALESCE(
        NULLIF(TRIM(r.away_team_name), ''),
        'Unknown'
    )
LEFT JOIN dw.dim_arena ar
    ON ar.arena_id = NULLIF(TRIM(r.arena_id), '')
JOIN dw.dim_game_type gt
    ON gt.game_type = TRIM(r.game_type)
ON CONFLICT (game_id) DO NOTHING;
