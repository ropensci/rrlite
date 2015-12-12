context("config")

test_that("defaults", {
  ## TODO: It would be nice if the url rewriting happened here but
  ## that requires reimplementing a bit of the logic.
  x <- rlite_config()
  expect_that(x$host, equals(":memory:"))
  expect_that(x$port, equals(6379L)) # not used
  expect_that(x$path, is_null())
  expect_that(x$password, is_null())
  expect_that(x$db, is_null())

  expect_that(x, is_a("redis_config"))
  expect_that(x, is_a("rlite_config"))
})

test_that("redis config -> rlite config", {
  x <- RedisAPI::redis_config()
  y <- rlite_config(x)
  expect_that(x$host, equals("127.0.0.1"))
  expect_that(y$host, equals(":memory:"))

  expect_that(y, is_a("redis_config"))
  expect_that(y, is_a("rlite_config"))
})

test_that("environment", {
  on.exit(Sys.unsetenv(c("REDIS_URL", "RLITE_URL")))

  redis_url <- "redis://:secr3t@foo.com:999/2"

  Sys.setenv(REDIS_URL=redis_url)
  expect_that(rlite_config()$host, equals("foo.com"))

  Sys.setenv(RLITE_URL="redis://:secr3t@mypath:999/2")
  expect_that(rlite_config()$host, equals("mypath"))

  ## Reset this correctly on exit:
  expect_that(Sys.getenv("REDIS_URL"), equals(redis_url))

  Sys.unsetenv("REDIS_URL")
  expect_that(rlite_config()$host, equals("mypath"))
  expect_that(Sys.getenv("REDIS_URL", NA_character_), equals(NA_character_))

  Sys.unsetenv("RLITE_URL")
  expect_that(rlite_config()$host, equals(":memory:"))
})

test_that("path handling", {
  path <- tempfile()
  x <- rlite_config(path=path)
  expect_identical(x$path, path)
  expect_identical(x$scheme, "unix")
  expect_null(x$host)
  expect_null(x$port)

  ## Check that this config works correctly:
  con <- hirlite(x)
  expect_identical(con$config()$path, path)
  con$SET("foo", "bar")
  expect_identical(con$GET("foo"), "bar")
  expect_identical(hirlite(x)$GET("foo"), "bar")
})
