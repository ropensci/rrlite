context("df_to_rows")

test_that("Speed", {
  ## Create a really large data.frame to work with, same size as
  ## diamonds with mixed types.

  nr <- 50000
  d <- data.frame(x1=rnorm(nr),
                  x2=sample(rownames(mtcars), nr, replace=TRUE),
                  x3=sample(100L, nr, replace=TRUE),
                  x4=sample(c(TRUE, FALSE), nr, replace=TRUE),
                  x5=rnorm(nr),
                  x6=rnorm(nr),
                  x7=rnorm(nr),
                  x8=rnorm(nr),
                  x9=rnorm(nr),
                  x10=rnorm(nr))

  for (len in c(10, 100, 1000, 10000, nr)) {
    dd <- d[seq_len(len),]
    t1 <- system.time(split(dd, seq_len(nrow(dd))))[[1]]
    t2 <- system.time(df_to_rows(dd))[[1]]
    expect_that(t2 < t1 + 0.003, is_true())
    if (t1 > 0.1) {
      break
    }
  }
})
