
box::use(
  shiny[dateRangeInput]
)

# Defining dateRangeInput2 using the code founded at:
# https://gist.github.com/micstr/49641c2767765bf0d0be716f6634a89e

dateRangeInput2 <- function(inputId, label, minview = "days", ...) {
  d <- shiny::dateRangeInput(inputId, label, ...)
  d$children[[2L]]$children[[1]]$attribs[["data-date-min-view-mode"]] <- minview
  d$children[[2L]]$children[[3]]$attribs[["data-date-min-view-mode"]] <- minview
  d
}