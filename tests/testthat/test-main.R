box::use(
  shinytest2[test_app],
  testthat[...],
)

test_that("App works", {
  test_app("../../")
})
