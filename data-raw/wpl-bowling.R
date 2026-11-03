# data-raw/wpl-bowling.R
# Builds the `wpl_bowling` data object.
# Source: Cricsheet (https://cricsheet.org), downloaded with the cricketdata
# package. Run this script to rebuild data/wpl_bowling.rda.

library(dplyr)

# 1. Import ----------------------------------------------------------------
wpl_bbb <- cricketdata::fetch_cricsheet(
  type = "bbb", gender = "female", competition = "wpl"
)

# 2. Prepare ---------------------------------------------------------------
# Dismissals credited to the bowler (run outs and retirements are not)
bowler_wickets <- c("bowled", "caught", "caught and bowled",
                    "lbw", "stumped", "hit wicket")

phase_levels <- c("Powerplay (overs 1-6)",
                  "Middle (overs 7-15)",
                  "Death (overs 16-20)")

wpl_bowling <- wpl_bbb |>
  # Keep the two main innings; super overs would distort the phases
  filter(innings <= 2) |>
  mutate(
    wides = coalesce(wides, 0),
    noballs = coalesce(noballs, 0),
    # A legal delivery is neither a wide nor a no-ball
    legal_ball = wides == 0 & noballs == 0,
    # Byes and leg byes are not charged to the bowler
    ball_runs = runs_off_bat + wides + noballs,
    bowler_wicket = wicket_type %in% bowler_wickets,
    phase = case_when(
      over <= 6 ~ phase_levels[1],
      over <= 15 ~ phase_levels[2],
      TRUE ~ phase_levels[3]
    )
  ) |>
  group_by(season, bowler, bowling_team, phase) |>
  summarise(
    balls = sum(legal_ball),
    runs_conceded = sum(ball_runs),
    wickets = sum(bowler_wicket),
    .groups = "drop"
  ) |>
  mutate(phase = factor(phase, levels = phase_levels)) |>
  arrange(season, bowler, phase)

# 3. Save ------------------------------------------------------------------
usethis::use_data(wpl_bowling, overwrite = TRUE)
