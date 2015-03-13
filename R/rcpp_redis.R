##' Interface to RcppRedis.  This is the drop in replacement for
##' \code{\link{rlite_context}}
##' @title Interface to RcppRedis
##' @param host Hostname (default is the localhost)
##' @param port Port to connect on
##' @export
rcpp_redis <- function(host="127.0.0.1", port=6379) {
  rcpp_redis_generator$new(host, port)
}

##' @importFrom R6 R6Class
rcpp_redis_generator <- R6::R6Class(
  "rcpp_redis",
  public=list(
    context=NULL,

    initialize=function(host, port) {
      require(RcppRedis)
      self$context <- new(RcppRedis::Redis, host, port)
    },

    ## This is an extremely thin wrapper:
    run=function(command) {
      self$context$execv(command)
    },

    ## Bits of interface that are not created yet, but might be relied
    ## on:
    close=function() {
      stop("$close() is not yet implemented")
    },
    is_closed=function() {
      stop("$is_closed() is not yet implemented")
    },
    reopen=function() {
      stop("$reopen() is not yet implemented")
    },
    write=function() {
      stop("$write() is not yet implemented")
    },
    read=function() {
      stop("$read() is not yet implemented")
    }
  ))
