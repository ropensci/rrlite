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
##' r$list()
##' r$del("foo")
##' r$list()
rdb <- function(path=":memory:") {
  rdb_generator$new(path)
}

rdb_generator <- R6::R6Class(
  "rdb",
  public=list(
    rlite=NULL,

    initialize=function(path) {
      self$rlite <- rlite(path)
    },

    set=function(key, value) {
      ok <- self$rlite$set(key, object_to_string(value))
      if (ok != "OK") {
        stop("Error setting key")
      }
      invisible(NULL)
    },

    get=function(key) {
      string_to_object(self$rlite$get(key))
    },

    list=function(pattern=NULL) {
      if (is.null(pattern)) {
        pattern <- "*"
      }
      as.character(unlist(self$rlite$keys(pattern)))
    },

    del=function(key) {
      invisible(self$rlite$del(key) == 1L)
    }
  ))

object_to_string <- function(x) {
  rawToChar(serialize(x, NULL, TRUE))
}
string_to_object <- function(s) {
  unserialize(charToRaw(s))
}
