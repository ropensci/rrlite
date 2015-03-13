context("rcpp_redis")

test_that("connection", {
  con <- rcpp_redis()
  expect_that(con$run("PING"), equals("PONG"))
})

test_that("rlite(rcpp)", {
  r <- rlite(context=rcpp_redis())
  expect_that(r$PING(), equals("PONG"))
  expect_that(r$SET("foo", "bar"), equals("OK"))
  expect_that(r$GET("foo"), equals("bar"))
  expect_that(r$close(), throws_error("not yet implemented"))
})
