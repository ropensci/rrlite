context("Objects")

test_that("Save data.frame", {
  d <- mtcars
  db <- hirlite()
  key <- "mtcars"

  to_redis(d, key, db)
  keys <- unlist(db$keys("*"))

  expect_that("mtcars:rownames"   %in% keys, is_true())
  expect_that("mtcars:names"      %in% keys, is_true())
  expect_that("mtcars:attributes" %in% keys, is_true())

  d2 <- from_redis(key, db)
  expect_that(d2, equals(d))
})
