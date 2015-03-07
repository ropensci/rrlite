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
      }
    ))

rlite_context <- function(path) {
  rlite_context_generator$new(path)
}
