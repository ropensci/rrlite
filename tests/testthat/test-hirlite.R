context("hirlite")

test_that("basic use", {
  r <- hirlite()
  expect_that(r$SET("foo", "bar"), equals("OK"))
  expect_that(r$GET("foo"), equals("bar"))
  expect_that(r$KEYS("*"), equals(list("foo")))
  expect_that(r$DEL("foo"), equals(1L))
  expect_that(r$DEL("foo"), equals(0L))
  expect_that(r$KEYS("*"), equals(list()))
})

test_that("creation", {
  con <- rrlite::rlite_context()
  obj <- RedisAPI::redis_api(con$run)
  expect_that(obj, is_a("redis_api"))
  expect_that(obj$type, equals("rrlite"))
  expect_that(obj$host, equals(":memory:"))
  expect_that(obj$port, equals(NULL))
  expect_that(obj$PING(), equals("PONG"))
})
