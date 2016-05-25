## Automatically generated from redux:tests/testthat/test-aaa.R: do not edit by hand
context("redux (basic test)")

test_that("use", {
  skip_if_no_rlite()
  r <- hirlite()
  expect_equal(r$PING(), redis_status("PONG"))
  key <- "redisapi-test:foo"
  expect_equal(r$SET(key, "bar"), redis_status("OK"))
  expect_equal(r$GET(key), "bar")
  r$DEL(key)
})
