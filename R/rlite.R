##' Create an rlite object
##' @title Create an rlite object
##' @param path Path to a persistent object or the magic string
##' \code{":memory:"} for an in-memory database.
##' @export
##' @importFrom R6 R6Class
##' @examples
##' r <- rlite()
##' r$SET("foo", "bar")
##' r$GET("foo")
rlite <- function(path=":memory:") {
  rlite_generator$new(path)
}

## NOTE: The actual code is in rlite_generated.R and is automatically
## generated.

## This allows the case to be insensitive.  It might make more sense
## to allow this to be turned on or off if it's going to be a resource
## drain?
##
## NOTE: Using `tolower()` (not `toupper()`) as the canonical name
## to match rlite itself and to make it easier to work with R6
## classes.
##' @export
`$.rlite` <- function(x, name) {
  x[[tolower(name)]]
}
