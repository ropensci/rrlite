## Automatically generated from redux:tests/testthat/helper-common.R: do not edit by hand
## Helpers that will be used by both redux and rrlite (possibly after
## translation).
skip_if_no_rlite <- function() {
  if (rlite_available()) {
    return()
  }
  skip("Redis is not available")
}

skip_if_no_scan <- function(r) {
  if (!inherits(try(r$SCAN(1, COUNT=1), silent=TRUE), "try-error")) {
    return()
  }
  skip("SCAN not implemented")
}

skip_if_no_info <- function(r) {
  if (!inherits(try(r$INFO(), silent=TRUE), "try-error")) {
    return()
  }
  skip("INFO not implemented")
}

skip_if_no_time <- function(r) {
  if (!inherits(try(r$TIME(), silent=TRUE), "try-error")) {
    return()
  }
  skip("TIME not implemented")
}

redis_status <- function(x) {
  class(x) <- "redis_status"
  x
}

is_OK <- function() {
  function(x) {
    expectation(identical(x, redis_status("OK")),
                paste0("redis status is not OK"),
                paste0("redis status is OK"))
  }
}

rand_str <- function(len=8, prefix="") {
  paste0(prefix,
         paste(sample(c(LETTERS, letters, 0:9), len), collapse=""))
}

mixed_fake_data <- function(nr) {
  str <- sample(rownames(mtcars), nr, replace=TRUE)
  data.frame(x_logical=(runif(nr) < .3),
             x_numeric=rnorm(nr),
             x_integer=as.integer(rpois(nr, 2)),
             x_character=str,
             x_factor=factor(str),
             stringsAsFactors=FALSE)
}

vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}