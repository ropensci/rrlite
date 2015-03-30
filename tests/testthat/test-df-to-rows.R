context("df_to_rows")

test_that("Round trip a data.frame disassembly", {
  x <- mtcars
  obj <- df_disassemble(x)
  cmp <- df_reassemble(obj$names, obj$rownames, obj$rows, obj$levels)
  expect_that(cmp, is_identical_to(x))
})

test_that("Speed", {
  ## Create a really large data.frame to work with, same size as
  ## diamonds with mixed types.

  nr <- 50000
  d <- big_fake_data(nr)

  for (len in c(10, 100, 1000, 10000, nr)) {
    dd <- d[seq_len(len),]
    t1 <- system.time(split(dd, seq_len(nrow(dd))))[[1]]
    t2 <- system.time(df_disassemble(dd))[[1]]
    expect_that(t2 < t1 + 0.003, is_true())
    if (t1 > 0.1) {
      break
    }
  }
})
