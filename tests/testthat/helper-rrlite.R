cleanup <- function() {
  files <- c("test.rld")
  file.remove(files[file.exists(files)])
}

skip_if_no_redis <- function() {
  if (redis_available()) {
    return()
  }
  skip("Redis or RcppRedis are not available")
}
