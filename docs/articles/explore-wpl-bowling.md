# Exploring WPL bowling with wplbowling

## Who this is for

This package is for club coaches and cricket analysts. It helps answer
one question: **which bowlers are most effective in the powerplay,
middle overs or death overs of a Women’s Premier League (WPL) season?**

## Install

``` r
# install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-sjad0015-git")
```

## Launch the app

``` r
library(wplbowling)
run_app()
```

## Use the controls

The app has three controls:

- **Season:** which WPL season to look at.
- **Phase of the innings:** powerplay (overs 1 to 6), middle (overs 7
  to 15) or death (overs 16 to 20).
- **Minimum overs bowled:** hides bowlers who bowled only a few overs,
  so the comparison is fairer.

The chart and table show the 10 bowlers with the lowest economy rate. If
nobody has bowled enough overs, the app shows a message asking you to
lower the minimum.

## Interpret the outputs

- **Economy** is runs conceded per over. Lower is better.
- **Wickets** show whether a cheap bowler also took wickets.
- A very low economy from only a few overs can be luck. Raise the
  minimum overs to check whether the bowler still stands out.
- Switch the phase to see whether a bowler is cheap everywhere or only
  at one stage.

## Use the function directly

The app uses
[`summarise_bowling()`](https://etc5523-2026.github.io/etc5523-assignment-4-sjad0015-git/reference/summarise_bowling.md),
which you can call yourself:

``` r
library(wplbowling)

first_season <- sort(unique(wpl_bowling$season))[1]

powerplay <- summarise_bowling(
  season_value = first_season,
  phases = "Powerplay (overs 1-6)",
  min_overs = 4
)

knitr::kable(head(powerplay, 5))
```

| bowler          | bowling_team   | balls | runs_conceded | wickets | economy |
|:----------------|:---------------|------:|--------------:|--------:|--------:|
| JL Jonassen     | Delhi Capitals |    72 |            50 |       3 |    4.17 |
| S Ecclestone    | UP Warriorz    |    30 |            25 |       1 |    5.00 |
| M Kapp          | Delhi Capitals |   132 |           123 |       8 |    5.59 |
| NR Sciver-Brunt | Mumbai Indians |   114 |           107 |       3 |    5.63 |
| A Capsey        | Delhi Capitals |    30 |            31 |       1 |    6.20 |

## Limitations

Each season has only a few matches per team, so some bowlers have small
samples. Economy rate does not account for the opposition, the pitch or
the match situation.

## Data

The data come from Cricsheet (<https://cricsheet.org>), downloaded with
the `cricketdata` package and summarised in `data-raw/wpl-bowling.R`.
See `DATA_LICENSE.md` for the licence and attribution.
