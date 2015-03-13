##' Create an rlite object
##' @title Create an rlite object
##' @param path to a persistent object or the magic string
##' \code{":memory:"} for an in-memory database.
##' @export
##' @importFrom R6 R6Class
##' @examples
##' r <- rdb()
##' r$set("foo", runif(10))
##' r$get("foo")
##' r$keys()
##' r$del("foo")
##' r$keys()
rdb <- function(path=":memory:", context=NULL) {
  rdb_generator$new(rlite(path, context))
}

rdb_generator <- R6::R6Class(
  "rdb",
  public=list(
    rlite=NULL,

    initialize=function(rlite) {
      self$rlite <- rlite
    },

    set=function(key, value) {
      ok <- self$rlite$set(key, object_to_string(value))
      if (ok != "OK") {
        stop("Error setting key")
      }
      invisible(NULL)
    },

    get=function(key) {
      ret <- self$rlite$get(key)
      if (is.null(ret)) ret else string_to_object(ret)
    },

    keys=function(pattern=NULL) {
      if (is.null(pattern)) {
        pattern <- "*"
      }
      as.character(unlist(self$rlite$keys(pattern)))
    },

    del=function(key) {
      invisible(self$rlite$del(key) == 1L)
    },

    ## I wonder if these are better dealt with using S3 methods?
    close=function() {
      self$rlite$close()
    },
    is_closed=function() {
      self$rlite$is_closed()
    },
    reopen=function() {
      self$rlite$reopen()
    }
  ))
