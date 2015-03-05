context("rrlite")

test_that("loaded", {
  expect_that(x <- .C("rrlite_test"), prints_text("hello world"))
})
