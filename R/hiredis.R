## NOTE: The actual code is in hiredis_generated.R and is automatically
## generated.

## This allows the case to be insensitive.  It might make more sense
## to allow this to be turned on or off if it's going to be a resource
## drain?
##
## NOTE: Using `tolower()` (not `toupper()`) as the canonical name
## to match rlite itself and to make it easier to work with R6
## classes.
##' @export
`$.hiredis` <- function(x, name) {
  x[[tolower(name)]]
}
