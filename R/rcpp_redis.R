##' Interface to RcppRedis.  This is the drop in replacement for
##' \code{\link{rlite_context}}
##' @title Interface to RcppRedis
##' @param host Hostname (default is the localhost)
##' @param port Port to connect on (default is Redis' default of 6379)
##' @export
##' @examples
##' # Only run if RcppRedis is installed and if a Redis server is running
##' if (redis_available()) {
##' con <- redis_context()
##' con$run("PING")
##' r <- hiredis()
##' r$PING
##' }
redis_context <- function(host="127.0.0.1", port=6379) {
  redis_context_generator$new(host, port)
}

##' @export
##' @rdname redis_context
hiredis <- function(host="127.0.0.1", port=6379) {
  hiredis_generator$new(redis_context(host, port))
}

##' @export
##' @rdname redis_context
##' @param ... Arguments passed from \code{redis_available} to
##' \code{redis_context}
redis_available <- function(...) {
  ## This will throw if Redis is not running or if the RcppRedis
  ## package is not installed
  !inherits(con <- try(redis_context(...), silent=TRUE), "try-error")
}

##' @importFrom R6 R6Class
redis_context_generator <- R6::R6Class(
  "redis_context",
  public=list(
    context=NULL,

    initialize=function(host, port) {
      require("RcppRedis", character.only=TRUE, quietly=TRUE)
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
