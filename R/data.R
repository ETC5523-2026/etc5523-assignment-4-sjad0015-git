#' Women's Premier League Bowling Data
#'
#' @source Cricsheet, https://cricsheet.org/.
#' Match data licensed under ODC-By 1.0.
#' 
#' WPL bowling by season, bowler and phase of the innings
#'
#' Ball-by-ball data from the Women's Premier League (WPL), summarised for
#' each bowler, in each season, in each phase of the innings.
#'
#' @format A tibble with 476 rows and 7 columns:
#' \describe{
#'   \item{season}{Season label as given by Cricsheet (the first WPL season
#'     is labelled "2022/23")}
#'   \item{bowler}{Bowler's name, as written by Cricsheet (initials and surname)}
#'   \item{bowling_team}{Team the bowler played for}
#'   \item{phase}{Phase of the innings, a factor: Powerplay (overs 1-6),
#'     Middle (overs 7-15) or Death (overs 16-20)}
#'   \item{balls}{Legal deliveries bowled (wides and no-balls excluded)}
#'   \item{runs_conceded}{Runs charged to the bowler: runs off the bat plus
#'     wides and no-balls. Byes and leg byes are not charged.}
#'   \item{wickets}{Dismissals credited to the bowler. Run outs and
#'     retirements are not counted.}
#' }
#' @details Super overs are excluded. The data are built by the script
#'   `data-raw/wpl-bowling.R`.
#' @source Cricsheet, <https://cricsheet.org>, downloaded with the
#'   cricketdata package. Please credit Cricsheet if you reuse these data.
#' @name wpl_bowling
#' @usage data("wpl_bowling")
"wpl_bowling"
