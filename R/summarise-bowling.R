
#' Summarise bowling for one season and phase of the innings
#'
#' Combines the chosen phases of the innings for each bowler in a season,
#' keeps bowlers who have bowled enough overs, and calculates their economy
#' rate (runs conceded per over). Bowlers are sorted from the lowest economy
#' rate to the highest.
#'
#' @param data A data frame containing bowling statistics. Defaults to
#'   `wpl_bowling`.
#' @param season_value A single season label, for example `"2022/23"`. Use
#'   `unique(data$season)` to see the options.
#' @param phases One or more phases of the innings, taken from
#'   `levels(data$phase)`.
#' @param min_overs Minimum overs a bowler must have bowled in the chosen
#'   phases to be included. Defaults to 2.
#'
#' @return A data frame with one row per bowler and team, with columns
#'   `bowler`, `bowling_team`, `balls`, `runs_conceded`, `wickets` and
#'   `economy`. It has zero rows if no bowler bowled enough overs.
#' @importFrom dplyr filter group_by summarise mutate arrange
#' @export
#' @examples
#' first_season <- sort(unique(wpl_bowling$season))[1]
#'
#' # Who was cheapest in the powerplay?
#' summarise_bowling(
#'   season_value = first_season,
#'   phases = "Powerplay (overs 1-6)"
#' )
#'
#' # Raise the minimum to compare only the bowlers who bowled the most
#' summarise_bowling(
#'   season_value = first_season,
#'   phases = "Death (overs 16-20)",
#'   min_overs = 4
#' )
summarise_bowling <- function(data = wpl_bowling,
                              season_value,
                              phases,
                              min_overs = 2) {
  if (!season_value %in% data$season) {
    stop("`season_value` must be one of: ",
         paste(sort(unique(data$season)), collapse = ", "),
         call. = FALSE)
  }
  
  data |>
    filter(season == season_value, phase %in% phases) |>
    group_by(bowler, bowling_team) |>
    summarise(
      balls = sum(balls),
      runs_conceded = sum(runs_conceded),
      wickets = sum(wickets),
      .groups = "drop"
    ) |>
    # Six legal balls make an over
    filter(balls >= min_overs * 6) |>
    mutate(economy = round(6 * runs_conceded / balls, 2)) |>
    arrange(economy)
}
