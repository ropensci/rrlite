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

##' Parse information returned by \code{INFO}
##' @title Parse Redis INFO
##' @param x character string
##' @export
parse_redis_info <- function(x) {
  xx <- strsplit(x, "\r\n", fixed=TRUE)[[1]]
  xx <- strsplit(xx, ":")
  xx <- xx[viapply(xx, length) == 2L]
  keys <- setNames(vcapply(xx, "[[", 2),
                   vcapply(xx, "[[", 1))
  keys <- strsplit(keys, ",", fixed=TRUE)
  keys$redis_version <- numeric_version(keys$redis_version)
  keys
}
