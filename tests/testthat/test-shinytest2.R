library(shinytest2)


test_that("{shinytest2} recording: Testing_model_and_date_select", {
  app <- AppDriver$new(name = "Testing_model_and_date_select", height = 657, width = 1065)
  app$set_inputs(`app-returnschart-modelselect` = "2")
  app$set_inputs(`app-returnschart-daterange1` = c("2006-06-01", "2023-02-28"))
  app$set_inputs(`app-returnschart-daterange1` = c("2006-06-01", "2022-01-01"))
  app$expect_values()
})
