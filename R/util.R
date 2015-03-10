assert_character <- function(x, name=deparse(substitute(x))) {
  if (!is.character(x)) {
    stop(sprintf("%s must be character", name), call.=FALSE)
  }
}

assert_length <- function(x, n, name=deparse(substitute(x))) {
  if (length(x) != n) {
    stop(sprintf("%s must have %d elements", name, n), call.=FALSE)
  }
}

assert_scalar_character <- function(x, name=deparse(substitute(x))) {
  assert_scalar(x, name)
  assert_character(x, name)
}

assert_scalar <- function(x, name=deparse(substitute(x))) {
  if (length(x) != 1) {
    stop(sprintf("%s must be a scalar", name), call.=FALSE)
  }
}

assert_scalar_or_null <- function(x, name=deparse(substitute(x))) {
  if (!(is.null(x) || length(x) == 1L)) {
    stop(sprintf("%s must be a scalar or NULL", name), call.=FALSE)
  }
}

vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}

interleave <- function(a, b) {
  c(rbind(a, b))
}
