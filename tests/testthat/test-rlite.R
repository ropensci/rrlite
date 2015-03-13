context("rlite")

test_that("basic use", {
  r <- rlite()
  expect_that(r$set("foo", "bar"), equals("OK"))
  expect_that(r$get("foo"), equals("bar"))
  expect_that(r$keys("*"), equals(list("foo")))
  expect_that(r$del("foo"), equals(1L))
  expect_that(r$del("foo"), equals(0L))
  expect_that(r$keys("*"), equals(list()))
})

test_that("case insensitivity", {
  r <- rlite()
  expect_that(r$ping(), equals("PONG"))
  expect_that(r$PING(), equals("PONG"))
})

test_that("close/reopen", {
  r <- rlite("test.rld")
  on.exit(file.remove("test.rld"))
  expect_that(r$set("foo", "bar"), equals("OK"))
  expect_that(r$get("foo"), equals("bar"))
  expect_that(r$close(), is_true())
  expect_that(r$is_closed(), is_true())
  expect_that(r$get("foo"), throws_error("Context is not connected"))
  expect_that(r$reopen(), is_true())
  expect_that(r$reopen(), is_false())
  expect_that(r$get("foo"), equals("bar"))
})
