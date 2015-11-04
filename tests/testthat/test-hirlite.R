context("hirlite")

test_that("basic use", {
  r <- hirlite()
  expect_that(r$SET("foo", "bar"), is_OK())
  expect_that(r$GET("foo"), equals("bar"))
  expect_that(r$KEYS("*"), equals(list("foo")))
  expect_that(r$DEL("foo"), equals(1L))
  expect_that(r$DEL("foo"), equals(0L))
  expect_that(r$KEYS("*"), equals(list()))
})
