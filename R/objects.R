##' Support for writing and reading R objects (currently data.frames)
##' to a redis instance.
##' @title Read/write R objects to Redis
##' @param object An R object (must be a data.frame at present)
##' @param key The key to store it in
##' @param db The database to store it in
##' @param ... Additional arguments to methods
##' @export
to_redis <- function(object, key, db, ...) {
  UseMethod("to_redis")
}

##' @export
##' @rdname to_redis
from_redis <- function(key, db, ...) {
  type <- db$get(sprintf("%s:type", key))
  f <- switch(type,
              data.frame=from_redis.data.frame,
              stop("Unknown type: ", type))
  f(key, db, ...)
}

from_redis.data.frame <- function(key, db, ...) {
  keys <- keys.data.frame(key)

  nms <- unlist(db$lrange(keys$names, 0, -1))
  rownames <- unlist(db$lrange(keys$rownames, 0, -1))

  ## Ugly because the mangle happens in two places: should pull this
  ## from the db when key is NULL.
  keys$rows <- sprintf(keys$rows, seq_along(rownames))
  at <- string_to_object(db$get(keys$attributes))
  at$row.names <- rownames
  at$names <- nms

  ## NOTE: element/cell wise:
  ## TODO: This is not OK: we should be indexing. (NOTE: I have
  ## forgotten what this comment is about...)
  ## d <- lapply(keys$rows, db$hgetall)
  ## TODO: This is a total hack: should create appropriate zero-row
  ## data.frame to use.
  ## TODO: Won't deal with the zero length case.
  ## dd[[1]] <- as.data.frame(dd[[1]])
  ## ret <- do.call("rbind", dd)

  f <- function(x) {
    setNames(string_to_object(x), nms)
  }
  dat <- lapply(db$mget(keys$rows), f)
  ## NOTE: May not be optimal...
  ret <- do.call("rbind", dat, quote=TRUE)

  attributes(ret) <- at
  attr(ret, "row.names") <- rownames
  ret
}

## This needs some options: do we serialise against:
##   - cells (most expensive, most accessible)
##   - rows (decent trade-off)
##   - blocks of rows (could be good for streaming)
##   - entire object (least expensive, least accessible)
## In some ways, caching lookups *as we use them* could do this really
## well: so store in tree like blobs?
##
## TODO: Dirk mentioned some way of getting binary data in and out.
## That's easy enough.
##' @export
to_redis.data.frame <- function(object, key, db, ...) {
  mode <- "rows" # hard coded for now.
  ## Potential ideas:
  mode <- match.arg(mode, c("rows", "cells", "cols", "single"))

  ## It begins.
  keys <- keys.data.frame(key, object, mode)

  db$set(keys$type, "data.frame")
  db$set(keys$mode, mode)

  nms <- names(object)

  db$del(c(keys$rownames, keys$names))
  db$rpush(keys$rownames, rownames(object))
  db$rpush(keys$names,    nms)

  ## This is slow because of the cost of the [i,] operation (50% of
  ## the time) and then a bit because of the redis op (50%).
  ## Serialisation is cheap.

  if (mode == "rows") {
    ## TODO: data.frame-to-rows function needed that very efficiently
    ## creates a list from a data.frame.
    object_rows <- df_to_rows_serialized(object)
    db$mset(keys$rows, object_rows)

    ## TODO: Should be indexable?
    db$mset(keys$levels, object_to_string(attr(object_rows, "levels")))
  } else if (mode == "cells") {
    for (i in seq_along(keys$rows)) {
      x <- vcapply(object[i,], object_to_string, USE.NAMES=FALSE)
      db$hmset(keys$rows[[i]], nms, x)
    }
  } else {
    stop("not yet implemented")
  }

  at <- attributes(object)
  at$names <- at$row.names <- NULL # already stored
  ## Should do this with a list?
  db$set(keys$attributes, object_to_string(at))
  invisible(NULL)
}

keys.data.frame <- function(key, object=NULL, mode=NULL) {
  if (is.null(object)) {
    rows <- sprintf("%s:rows:%%d", key)
  } else {
    rows <- sprintf("%s:rows:%d", key, seq_len(nrow(object)))
  }

  list(mode=sprintf("%s:mode", key),
       rows=rows,
       rownames=sprintf("%s:rownames", key),
       names=sprintf("%s:names", key),
       type=sprintf("%s:type", key),
       levels=sprintf("%s:levels", key),
       attributes=sprintf("%s:attributes", key))
}

## Stupid utility function that later on I'll swap out for something
## faster.  On diamonds, this takes absolutely for ages (0.2s/1000
## rows).  Can save a little under 50% of that by unfactoring things.
##
## Unfactoring makes sense anyway because the factor bits should be
## stored at the metadata level, so we'd want factors gone.
##
## TODO: a split()-based approach allows for chunked streaming and
## reading potentially.
df_to_rows_serialized <- function(x, unfactor=TRUE) {
  i <- vlapply(x, is.factor)
  lvls <- lapply(x[i], levels)
  x[i] <- lapply(x[i], as.integer)
  x <- unname(x)
  rownames(x) <- NULL
  ## This doesn't work because it breaks types:
  ## ret <- unname(apply(x, 1, object_to_string))
  x_rows <- unname(split(x, seq_len(nrow(x))))
  ret <- vcapply(x_rows, object_to_string)
  attr(ret, "levels") <- lvls
  ret
}

df_to_rows <- function(x) {
  i <- vlapply(x, is.factor)
  lvls <- lapply(x[i], levels)
  x[i] <- lapply(x[i], as.integer)
  x <- unname(x)
  rownames(x) <- NULL
  ## Might be better to serialise as a list, really.  This is totally
  ## going into C++ at some point, if there's a chance that the
  ## Rcpp::DataFrame object does this any better.
  ret <- unname(split(x, seq_len(nrow(x))))
  attr(ret, "levels") <- lvls
  ret
}
