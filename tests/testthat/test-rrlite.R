context("rrlite")

## This will become the low-level object that we'll build things
## around:
test_that("loaded", {
  con <- rlite_context(":memory:")

  expect_that(con, is_a("rlite_context"))
  ## NOTE: name will change probably?
  expect_that(con$path, equals(":memory:"))

  expect_that(con$write(c("set", "key1", "mydata")), is_null())
  expect_that(con$read(), equals("OK"))
  expect_that(con$read(), equals(NULL))

  con$write(c("get", "key1"))
  expect_that(con$read(), equals("mydata"))
  expect_that(con$read(), equals(NULL))
})
