##' Create an rdb object
##' @title Create an rdb object
##' @param path to a persistent object or the magic string
##' \code{":memory:"} for an in-memory database.
##' @param hiredis Alternative hiredis object implementation
##' @export
##' @importFrom R6 R6Class
##' @examples
##' r <- rdb()
##' r$set("foo", runif(10))
##' r$get("foo")
##' r$keys()
##' r$del("foo")
##' r$keys()
rdb <- function(path=":memory:", hiredis=NULL) {
  if (is.null(hiredis)) {
    hiredis <- hirlite(path)
  }
  rdb_generator$new(hiredis)
}

rdb_generator <- R6::R6Class(
  "rdb",
  public=list(
    hiredis=NULL,

    initialize=function(hiredis) {
      self$hiredis <- hiredis
    },

    set=function(key, value) {
      ok <- self$hiredis$set(key, object_to_string(value))
      if (ok != "OK") {
        stop("Error setting key")
      }
      invisible(NULL)
    },

    get=function(key) {
      ret <- self$hiredis$get(key)
      if (is.null(ret)) ret else string_to_object(ret)
    },

    keys=function(pattern=NULL) {
      if (is.null(pattern)) {
        pattern <- "*"
      }
      as.character(unlist(self$hiredis$keys(pattern)))
    },

    del=function(key) {
      invisible(self$hiredis$del(key) == 1L)
    },

    ## I wonder if these are better dealt with using S3 methods?
    close=function() {
      self$hiredis$close()
    },
    is_closed=function() {
      self$hiredis$is_closed()
    },
    reopen=function() {
      self$hiredis$reopen()
    }
  ))
