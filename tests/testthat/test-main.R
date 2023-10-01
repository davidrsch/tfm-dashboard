box::use(
  shinytest2[test_app],
  testthat[test_that],
)

test_that("Run tests", {
  test_app("../../",
           filter = "shinytest2")
})
