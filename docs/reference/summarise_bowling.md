# Summarise bowling for one season and phase of the innings

Combines the chosen phases of the innings for each bowler in a season,
keeps bowlers who have bowled enough overs, and calculates their economy
rate (runs conceded per over). Bowlers are sorted from the lowest
economy rate to the highest.

## Usage

``` r
summarise_bowling(data = wpl_bowling, season_value, phases, min_overs = 2)
```

## Arguments

- data:

  A data frame containing bowling statistics. Defaults to `wpl_bowling`.

- season_value:

  A single season label, for example `"2022/23"`. Use
  `unique(data$season)` to see the options.

- phases:

  One or more phases of the innings, taken from `levels(data$phase)`.

- min_overs:

  Minimum overs a bowler must have bowled in the chosen phases to be
  included. Defaults to 2.

## Value

A data frame with one row per bowler and team, with columns `bowler`,
`bowling_team`, `balls`, `runs_conceded`, `wickets` and `economy`. It
has zero rows if no bowler bowled enough overs.

## Examples

``` r
first_season <- sort(unique(wpl_bowling$season))[1]

# Who was cheapest in the powerplay?
summarise_bowling(
  season_value = first_season,
  phases = "Powerplay (overs 1-6)"
)
#> # A tibble: 30 × 6
#>    bowler          bowling_team              balls runs_conceded wickets economy
#>    <chr>           <chr>                     <int>         <dbl>   <int>   <dbl>
#>  1 JL Jonassen     Delhi Capitals               72            50       3    4.17
#>  2 S Ecclestone    UP Warriorz                  30            25       1    5   
#>  3 M Kapp          Delhi Capitals              132           123       8    5.59
#>  4 NR Sciver-Brunt Mumbai Indians              114           107       3    5.63
#>  5 A Capsey        Delhi Capitals               30            31       1    6.2 
#>  6 IECM Wong       Mumbai Indians               96           100       6    6.25
#>  7 HK Matthews     Mumbai Indians               54            58       6    6.44
#>  8 ML Schutt       Royal Challengers Bangal…    78            86       3    6.62
#>  9 S Pandey        Delhi Capitals               66            74       3    6.73
#> 10 RP Yadav        Delhi Capitals               24            27       2    6.75
#> # ℹ 20 more rows

# Raise the minimum to compare only the bowlers who bowled the most
summarise_bowling(
  season_value = first_season,
  phases = "Death (overs 16-20)",
  min_overs = 4
)
#> # A tibble: 17 × 6
#>    bowler          bowling_team              balls runs_conceded wickets economy
#>    <chr>           <chr>                     <int>         <dbl>   <int>   <dbl>
#>  1 HK Matthews     Mumbai Indians               42            35       5    5   
#>  2 S Ishaque       Mumbai Indians               41            39       5    5.71
#>  3 S Pandey        Delhi Capitals               48            54       3    6.75
#>  4 AC Kerr         Mumbai Indians               46            52       4    6.78
#>  5 S Ecclestone    UP Warriorz                  63            83       7    7.9 
#>  6 SR Patil        Royal Challengers Bangal…    39            53       4    8.15
#>  7 A Reddy         Delhi Capitals               24            34       1    8.5 
#>  8 NR Sciver-Brunt Mumbai Indians               30            43       4    8.6 
#>  9 A Capsey        Delhi Capitals               39            61       2    9.38
#> 10 IECM Wong       Mumbai Indians               39            62       4    9.54
#> 11 S Rana          Gujarat Giants               38            63       3    9.95
#> 12 EA Perry        Royal Challengers Bangal…    30            50       3   10   
#> 13 DB Sharma       UP Warriorz                  95           163       4   10.3 
#> 14 ML Schutt       Royal Challengers Bangal…    42            75       0   10.7 
#> 15 JL Jonassen     Delhi Capitals               84           151       3   10.8 
#> 16 A Gardner       Gujarat Giants               46            85       5   11.1 
#> 17 A Sutherland    Gujarat Giants               41           101       3   14.8 
```
