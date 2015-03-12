##' Create an \code{rlite_context} object
##' @title Create an rlite_context object
##' @param path Path to a persistent object or the magic string
##' \code{":memory:"} for an in-memory database.
##' @export
##' @importFrom R6 R6Class
##' @examples
##' r <- rlite_context()
##' r$run(c("SET", "foo", "bar"))
##' r$run(c("GET", "foo"))
rlite_context <- function(path=":memory:") {
  rlite_context_generator$new(path)
}

##' @importFrom R6 R6Class
rlite_context_generator <-
  R6::R6Class(
    "rlite_context",
    public=list(
      path=character(0),
      ptr=NULL, # eventually this becomes private.

      initialize=function(path) {
        self$path <- path
        self$ptr <- .Call("rrlite_context", path)
      },

      write=function(command) {
        .Call("rrlite_write", self$ptr, command)
      },

      read=function() {
        .Call("rrlite_read", self$ptr)
      },

      run=function(command) {
        ## TODO: ensure we always read()?
        ## TODO: Run this via .Call by not using append?
        self$write(command)
        self$read()
      }
    ))
