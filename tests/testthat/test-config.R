context("config")

test_that("defaults", {
  ## TODO: It would be nice if the url rewriting happened here but
  ## that requires reimplementing a bit of the logic.
  x <- rlite_config()
  expect_equal(x$host, ":memory:")
  expect_equal(x$port, 6379L) # not used
  expect_null(x$path)
  expect_null(x$password)
  expect_null(x$db)

  expect_is(x, "redis_config")
  expect_is(x, "rlite_config")
})

test_that("redis config -> rlite config", {
  x <- RedisAPI::redis_config()
  y <- rlite_config(x)
  expect_equal(x$host, "127.0.0.1")
  expect_equal(y$host, ":memory:")

  expect_is(y, "redis_config")
  expect_is(y, "rlite_config")
})

test_that("environment", {
  on.exit(Sys.unsetenv(c("REDIS_URL", "RLITE_URL")))

  redis_url <- "redis://:secr3t@foo.com:999/2"

  Sys.setenv(REDIS_URL=redis_url)
  expect_equal(rlite_config()$host, "foo.com")

  Sys.setenv(RLITE_URL="redis://:secr3t@mypath:999/2")
  expect_equal(rlite_config()$host, "mypath")

  ## Reset this correctly on exit:
  expect_equal(Sys.getenv("REDIS_URL"), redis_url)

  Sys.unsetenv("REDIS_URL")
  expect_equal(rlite_config()$host, "mypath")
  expect_equal(Sys.getenv("REDIS_URL", NA_character_), NA_character_)

  Sys.unsetenv("RLITE_URL")
  expect_equal(rlite_config()$host, ":memory:")
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
