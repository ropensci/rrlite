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

big_fake_data <- function(nr) {
  data.frame(x1=rnorm(nr),
             x2=sample(rownames(mtcars), nr, replace=TRUE),
             x3=sample(100L, nr, replace=TRUE),
             x4=sample(c(TRUE, FALSE), nr, replace=TRUE),
             x5=rnorm(nr),
             x6=rnorm(nr),
             x7=rnorm(nr),
             x8=rnorm(nr),
             x9=rnorm(nr),
             x10=rnorm(nr))
}
