#' Launch the WPL bowling app
#'
#' Opens the interactive WPL bowling application.
#'
#' @return Launches a Shiny application.
#' @export
run_app <- function() {
  
  app_dir <- system.file(
    "app",
    package = "wplbowling"
  )
  
  if (app_dir == "") {
    stop("Application files not found. Reinstall the package.")
  }
  
  shiny::runApp(app_dir)
  
}
