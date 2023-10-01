#Module to define the welcome message

box::use(
  shiny[modalDialog, moduleServer, NS, showModal],
  htmltools[div, img, h1, p]
)


#' @export
server <- function(id) {

  moduleServer(id, function(input, output, session) {

    # Defining welcome message
    welcome <- modalDialog(
      title = div(
        div(
          img(src = "static/udclogo.png",
              alt = "UDC logo",
              height = "50"),
          img(src = "static/feelogo.png",
              alt = "FEE logo",
              height = "50")
        ),
        div(
          h1("Trabajo Final de Máster")
        ),
        style = "text-align: center;"
      ),
      div(
        p(
          "Este dashboard es parte del proyecto presentado como Trabajo Final de Máster en la 
          Facultad de Economía y Empresas de la Universidad de A Coruña para la obtención del 
          titúlo de Máster Universitario en Banca y Finanzas."),
        p(
          'El proyecto se titula "Aplicación de redes neuronales artificiales y programación 
          cuadrática en la gestión de carteras". El objetivo del trabajo se examina el potencial 
          de la combinación de las redes neuronales convolucionales y LSTM para mejorar la 
          previsión de series de tiempo y en el proceso de composición de carteras, se aplica la 
          programación cuadrática como una técnica eficiente para lograr una distribución óptima 
          de activos financieros. En conclusión, el enfoque de combinar redes neuronales 
          artificiales y programación cuadrática muestra promesa en la gestión de carteras 
          financieras, pero es necesario un estudio más profundo y exhaustivo para determinar su 
          eficiencia óptima. Este trabajo sienta las bases para futuras investigaciones, 
          destacando la importancia de utilizar datos actualizados y configurar adecuadamente los 
          modelos para lograr una gestión de carteras más informada y efectiva en un entorno 
          financiero en constante evolución.')
      ),
      easyClose = TRUE,
      footer = div("Creado por: David Díaz Rodríguez", style = "text-align:center;")
    )

    # Showing welcome message
    showModal(welcome)

  })
}
