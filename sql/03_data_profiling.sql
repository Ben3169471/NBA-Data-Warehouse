\echo '========== TOTAL RECORDS =========='
SELECT COUNT(*) AS total_games
FROM stg.raw_games;

\echo '========== DATE RANGE =========='
SELECT
    MIN(game_date::TIMESTAMP)::DATE AS earliest_game,
    MAX(game_date::TIMESTAMP)::DATE AS latest_game
FROM stg.raw_games
WHERE NULLIF(TRIM(game_date), '') IS NOT NULL;

\echo '========== DUPLICATE GAME IDS =========='
SELECT COUNT(*) AS duplicate_game_ids
FROM (
    SELECT game_id
    FROM stg.raw_games
    GROUP BY game_id
    HAVING COUNT(*) > 1
) duplicates;

\echo '========== MISSING CORE FIELDS =========='
SELECT
    COUNT(*) FILTER (WHERE NULLIF(TRIM(game_id), '') IS NULL) AS missing_game_ids,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(game_date), '') IS NULL) AS missing_game_dates,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(home_team_id), '') IS NULL) AS missing_home_team_ids,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(away_team_id), '') IS NULL) AS missing_away_team_ids,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(home_score), '') IS NULL) AS missing_home_scores,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(away_score), '') IS NULL) AS missing_away_scores,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(winner), '') IS NULL) AS missing_winners
FROM stg.raw_games;

\echo '========== GAME TYPES =========='
SELECT game_type, COUNT(*) AS total_games
FROM stg.raw_games
GROUP BY game_type
ORDER BY total_games DESC;

\echo '========== INVALID OR NEGATIVE SCORES =========='
SELECT COUNT(*) AS invalid_scores
FROM stg.raw_games
WHERE
    NULLIF(TRIM(home_score), '') IS NULL
    OR NULLIF(TRIM(away_score), '') IS NULL
    OR home_score !~ '^\d+$'
    OR away_score !~ '^\d+$'
    OR home_score::INTEGER < 0
    OR away_score::INTEGER < 0;

\echo '========== SAME HOME AND AWAY TEAM =========='
SELECT COUNT(*) AS same_team_games
FROM stg.raw_games
WHERE home_team_id = away_team_id;

\echo '========== OPTIONAL MISSING VALUES =========='
SELECT
    COUNT(*) FILTER (WHERE NULLIF(TRIM(game_subtype), '') IS NULL) AS missing_subtypes,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(game_label), '') IS NULL) AS missing_labels,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(attendance), '') IS NULL) AS missing_attendance,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(arena_name), '') IS NULL) AS missing_arena_names,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(officials), '') IS NULL) AS missing_officials
FROM stg.raw_games;
