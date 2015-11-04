cleanup <- function() {
  files <- c("test.rld")
  file.remove(files[file.exists(files)])
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

## For compatibility with redux:
skip_if_no_rlite <- function() {
  return()
}

skip_if_no_scan <- function(r) {
  if (!inherits(try(r$SCAN(1, COUNT=1), silent=TRUE), "try-error")) {
    return()
  }
  skip("SCAN not implemented")
}

rand_str <- function(len=8, prefix="") {
  paste0(prefix,
         paste(sample(c(LETTERS, letters, 0:9), len), collapse=""))
}
