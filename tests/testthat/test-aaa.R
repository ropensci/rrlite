## Automatically generated from redux:tests/testthat/test-aaa.R: do not edit by hand
context("redux (basic test)")

test_that("use", {
  skip_if_no_rlite()
  r <- hirlite()
  expect_that(r$PING(), equals(redis_status("PONG")))
  key <- "redisapi-test:foo"
  expect_that(r$SET(key, "bar"), equals(redis_status("OK")))
  expect_that(r$GET(key), equals("bar"))
  r$DEL(key)
})
