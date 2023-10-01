# Module of general results.

box::use(
  htmltools[a, img],
  plotly[add_lines, layout, plot_ly, plotlyOutput, renderPlotly],
  shiny[div, isolate, moduleServer, NS,
        observeEvent, reactive, selectInput, tagList],
  lubridate[ceiling_date, days, ymd],
)

box::use(
  app/logic/gettingdata[returns_data, indic_data],
  app/logic/RangeInput[DateRangeInput2]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "components-container-inps",
      # Input to select the model which results will be ploted
      div(
        class = "component-box-inps",
        selectInput(
          inputId = ns("modelselect"),
          label = "Model:",
          choices = c("1", "2", "3")
        )
      ),
      # Filter to select the range date of the results to plot
      div(
        class = "component-box-inps",
        DateRangeInput2(
                        InputId = ns("daterange1"),
                        label = "Rango de fechas:",
                        start = "2005-07-31",
                        end = "2023-02-28",
                        min = "2005-07-31",
                        max = "2023-02-28",
                        format = "yyyy-mm",
                        minview = "months")
      ),
      # Social media info
      div(
        class = "component-box-inps",
        div(
          div(
            a(
              href = "https://www.linkedin.com/in/david-d-6257951b8",
              img(
                src = "static/linkedin.png",
                alt = "Linkedin profile",
                width = "25"
              ),
              style = "margin-right: 3.75px;"
            ),
            a(
              href = "https://github.com/davidrsch/tfm-dashboard",
              img(
                src = "static/github.png",
                alt = "Orcid profile",
                width = "25"
              ),
              style = "margin-right: 3.75px;"
            ),
            style = "margin-top: 7.5px;"
          ),
          div(
            a(
              href = "https://www.researchgate.net/profile/David-Diaz-Rodriguez",
              img(
                src = "static/Researchgate.png",
                alt = "ResearchGate profile",
                width = "25"
              ),
              style = "margin-right: 3.75px;"
            ),
            a(
              href = "https://orcid.org/0000-0002-0927-9795?lang=en",
              img(
                src = "static/orcid.png",
                alt = "Orcid profile",
                width = "25"
              ),
              style = "margin-right: 3.75px;"
            ),
            style = "margin-top: 7.5px;"
          )
        )
      )
    ),
    # UI of outputs
    div(
      class = "components-container-outs",
      # Output of returns results
      div(
        class = "component-box-outs",
        plotlyOutput(ns("returnschart"))
      ),
      # Output of indicators
      div(
        class = "component-box-outs",
        plotlyOutput(ns("indicatorschart"))
      )
    )
  )
}

#' @export
server <- function(
    id, returnsdata1, returnsdata2, returnsdata3) {
  moduleServer(id, function(input, output, session) {

    # To make output of obtained returns and indicators reactive to
    # inputs
    observeEvent(c(input$modelselect, input$daterange1), {

      # Getting start and end date from input
      startd <- ceiling_date(ymd(input$daterange1[1]), "month") - days(1)
      endd <- ceiling_date(ymd(input$daterange1[2]), "month") - days(1)

      # Getting data from main and extracting results and indicators
      data <- get(paste0("returnsdata", input$modelselect))
      datar <- returns_data(data, startd, endd)
      datai <- indic_data(data, startd, endd)

      # Generating output of portfolio returns
      output$returnschart <- renderPlotly({

        fig <- plot_ly(datar, type = "scatter", mode = "lines")
        fig <- fig |>
          # Lineas de RNA1
          # Linea de valos máximos de RNA1
          add_lines(x = ~Date, y = ~max_y, name = "RNA",
                    line = list(color = "blue"), legendgroup = "struct1") |>
          add_lines(x = ~Date, y = ~max_95, name = "max95",
                    line = list(color = "blue"), fill = "tonexty",
                    fillcolor = "rgba(18,18,255,0.2)", legendgroup = "struct1",
                    showlegend = FALSE) |>
          add_lines(x = ~Date, y = ~min_5, name = "min5",
                    line = list(color = "blue"), fill = "tonexty",
                    fillcolor = "rgba(18,18,255,0.5)", legendgroup = "struct1",
                    showlegend = FALSE) |>
          add_lines(x = ~Date, y = ~min_y, name = "min",
                    line = list(color = "blue"), fill = "tonexty",
                    fillcolor = "rgba(18,18,255,0.2)", legendgroup = "struct1",
                    showlegend = FALSE) |>
          add_lines(x = ~Date, y = ~meanPortre, name = "meanP",
                    line = list(color = "blue", dash = "dash"),
                    legendgroup = "struct1", showlegend = FALSE) |>
          add_lines(x = ~Date, y = ~IBEX, name = "IBEX",
                    line = list(color = "red")) |>
          add_lines(x = ~Date, y = ~Means, name = "Means",
                    line = list(color = "green")) |>
          layout(title = paste0("Carteras Estructura-", input$modelselect),
                 showlegend = TRUE,
                 legend = list(y = 0.5),
                 xaxis = list(title = "Fecha"),
                 yaxis = list(title = "Valores"))

        # Show the plot
        fig
      })

      # Generating output of indicators computed from obtained predictions
      output$indicatorschart <- renderPlotly({

        fig <- plot_ly(datai, type = "scatter", mode = "lines")
        fig <- fig |>
          add_lines(x = ~Date, y = ~meanmse, name = "MSE",
                    line = list(color = "blue")) |>
          add_lines(x = ~Date, y = ~meanrsqrd, name = "R2",
                    line = list(color = "green")) |>
          layout(title = paste0("Indicadores Estructura-", input$modelselect),
                 showlegend = TRUE,
                 legend = list(y = 0.5),
                 xaxis = list(title = "Fecha"),
                 yaxis = list(title = "Valores"))

        # Show the plot
        fig
      })
    })
  })
}
