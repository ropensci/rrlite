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
  expect_that(db$llen("mtcars:rows"), equals(nrow(d)))
  expect_that(string_to_object(db$get("mtcars:levels")),
              equals(empty_named_list()))
  expect_that(string_to_object(db$get("mtcars:attributes")),
              equals(list(class="data.frame")))

  d2 <- from_redis(key, db)
  expect_that(d2, equals(d))

  ## This takes 0.8/1.2s; a good chunk of that is spent in serialize
  ## (24%), but most is spent in the redis command.  Instruments
  ## suggests that rlite's `delCommand` is 50% of the time here.
  ## d <- big_fake_data(10000)
  ## Rprof()
  ## for (i in 1:5) to_redis(d, "fake", db)
  ## Rprof(NULL)

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
