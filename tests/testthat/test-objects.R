context("Objects")

test_that("Save data.frame", {
  d <- mtcars
  db <- hirlite()
  key <- "mtcars"
  mode <- "rows"

  to_redis(d, key, db, mode)
  keys <- unlist(db$keys("*"))

  expect_that(db$get("mtcars:mode"), is_identical_to(mode))
  expect_that(unlist(db$lrange("mtcars:names", 0, -1)),
              is_identical_to(names(d)))
  expect_that(unlist(db$lrange("mtcars:rownames", 0, -1)),
              is_identical_to(rownames(d)))

  expect_that("mtcars:attributes" %in% keys, is_true())

  d2 <- from_redis(key, db)
  expect_that(d2, equals(d))

  ## Painfully slow example -- currently 76% of the time is in
  ## df_to_rows (4.0 of 5.76s).  Redis calls cost us 1.2s, 21%).
  ## data(diamonds, package="ggplot2")
  ## Rprof()
  ## to_redis(diamonds[1:10000,], "diamonds", db)
  ## Rprof(NULL)
})

## Sweet: this actually looks faster with Redis than rlite.  I'd guess
## that this is because Redis doesn't write immediately to disk.  The
## cost is almost entirely incurred by the database splitting.
test_that("Save data.frame to Redis server", {
  d <- mtcars
  db <- hiredis()
  key <- "mtcars"
  to_redis(d, key, db, mode)
  d2 <- from_redis(key, db)
  expect_that(d2, equals(d))
})

test_that("data.frame to rows", {
  x <- mtcars
  xx <- df_to_rows(x)
  expect_that(unname(as.list(x[3,])),
              is_identical_to(xx[[3]]))

  ## This is pretty good: 0.07s
  ## data("diamonds", package="ggplot2")
  ## system.time(df_to_rows(diamonds))
})
