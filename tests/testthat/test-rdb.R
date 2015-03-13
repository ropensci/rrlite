context("rdb")

test_that("close/reopen", {
  r <- rdb("test.rld")
  on.exit(file.remove("test.rld"))
  x <- mtcars
  expect_that(r$set("foo", x), is_null())
  expect_that(r$get("foo"), equals(x))
  expect_that(r$close(), is_true())
  expect_that(r$is_closed(), is_true())
  expect_that(r$get("foo"), throws_error("Context is not connected"))
  expect_that(r$reopen(), is_true())
  expect_that(r$reopen(), is_false())
  expect_that(r$get("foo"), equals(x))
})
