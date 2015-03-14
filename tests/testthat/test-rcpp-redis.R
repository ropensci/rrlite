context("rlite + RcppRedis")

test_that("connection", {
  con <- redis_context()
  expect_that(con$run("PING"), equals("PONG"))
})

test_that("rlite(rcpp)", {
  r <- hiredis()
  expect_that(r$PING(), equals("PONG"))
  key <- "rlite-test:foo"
  expect_that(r$SET(key, "bar"), equals("OK"))
  expect_that(r$GET(key), equals("bar"))
  expect_that(r$close(), throws_error("not yet implemented"))
  expect_that(r$context, is_a("redis_context"))
  expect_that(r$context$context, is_a("Rcpp_Redis"))
})

test_that("rdb(rcpp)", {
  db <- rdb(hiredis=hiredis())
  key <- "rlite-test:d"
  db$set(key, mtcars)
  expect_that(db$get(key), equals(mtcars))
  expect_that(db$hiredis, is_a("hiredis"))
  expect_that(db$hiredis$context, is_a("redis_context"))
  expect_that(db$hiredis$context$context, is_a("Rcpp_Redis"))
})
