context("rrlite")

test_that("loaded", {
  expect_that(test_rlite_noop(":memory:", 0), is_null())
})
