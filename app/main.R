
box::use(
  shiny[bootstrapPage, div, h1, modalDialog,
        moduleServer, NS, showModal],
)

box::use(
  app/view/modelselect,
  app/view/welcome,
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  bootstrapPage(
    # Title
    h1(title),
    # Loading UI from "modelselect" module
    modelselect$ui(ns("returnschart"))
  )
}

# Loadng data
load("./app/static/results.Rdata")

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Loading server from "welcome" module to display welcome message
    welcome$server("message")

    # Loading server from "modelselect" module to displau returns and
    # indicators outputs
    modelselect$server(
                       "returnschart",
                       returnsdata1 = resultscnnlstmssing1,
                       returnsdata2 = resultscnnlstmssing2,
                       returnsdata3 = resultscnnlstmssing3)
  })
}
