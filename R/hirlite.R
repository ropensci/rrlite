##' Create an interface to rlite, with a generated interface to all
##' rlite commands (using \code{Redux}).
##'
##' @title Interface to rlite
##' @param ... Named configuration options passed to
##'   \code{\link{redis_config}}, used to create the environment
##'   (notable keys include \code{host}, \code{port}, and the
##'   environment variable \code{REDIS_URL}).  In addition to the
##'   \code{Redux} treatment of the configuration, \code{RLITE_URL}
##'   takes precendence over \code{REDIS_URL}, and a host of
##'   \code{localhost} or \code{127.0.0.1} will be treated as an
##'   in-memory database (\code{:memory:}).
##'
##' @export
##' @examples
##' r <- hirlite()
##' r$PING()
##' r$SET("foo", "bar")
##' r$GET("foo")
hirlite <- function(...) {
  config <- rlite_config(...)
  con <- rlite_connection(config)
  redux::redis_api(con)
}

##' @export
##' @rdname hirlite
rlite_available <- function(...) {
  !inherits(try(hirlite(...), silent=TRUE), "try-error")
}
