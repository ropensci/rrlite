context("rcpp_redis")

test_that("connection", {
  con <- rcpp_redis()
  expect_that(con$run("PING"), equals("PONG"))
})
