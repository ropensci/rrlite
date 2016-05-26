##' rlite configuration settings.  Based on the \code{redis_config}
##' function but with additional tweaks for rlite.  The differences
##' between this configuration and \code{\link{redis_config}} is that:
##'
##' \itemize{
##'
##' \item{\code{RLITE_URL} takes precendence over \code{REDIS_URL} if
##' both are present (otherwise \code{REDIS_URL} will still be used).}
##'
##' \item{A host of \code{localhost} or \code{127.0.0.1}, which is
##' \code{redis_config}'s default, will map to a filename of
##' \code{:memory:} for a transient in-memory store.}
##' }
##'
##' The \code{port} entry will be ignored, but the \code{password} and
##' \code{db} entries will be used if present.  \code{path} is
##' equivalent to \code{host}.
##'
##' @title rlite configuration
##' @param ... Arguments passed to \code{\link{redis_config}}; see
##'   that file for more information.
##' @export
rlite_config <- function(...) {
  if (Sys.getenv("RLITE_URL") != "") {
    ## Dear god what a mess:
    old <- Sys.getenv("REDIS_URL", NA_character_)
    if (is.na(old)) {
      on.exit(Sys.unsetenv("REDIS_URL"))
    } else {
      on.exit(Sys.setenv(REDIS_URL=old))
    }
    Sys.setenv(REDIS_URL=Sys.getenv("RLITE_URL"))
  }
  config <- redux::redis_config(...)
  if (!is.null(config$host) && config$host %in% c("localhost", "127.0.0.1")) {
    config$host <- ":memory:"
  }
  class(config) <- c("rlite_config", class(config))
  config
}
