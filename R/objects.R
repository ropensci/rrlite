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

  names <- unlist(db$lrange(keys$names, 0, -1))
  rownames <- unlist(db$lrange(keys$rownames, 0, -1))
  levels <- string_to_object(db$get(keys$levels))
  rows <- lapply(db$lrange(keys$rows, 0, -1), string_to_object)
  at <- string_to_object(db$get(keys$attributes))

  ret <- df_reassemble(names, rownames, rows, levels)
  for (i in names(at)) {
    attr(ret, i) <- at[[i]]
  }
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
##
## TODO: When serialising by cells if we only have atomic types we can
## avoid serialisation entirely; serialise only columns that are not
## one of int/real/str and make a set of flags indicating which should
## be done?
##' @export
to_redis.data.frame <- function(object, key, db, ...) {
  mode <- "rows"

  keys <- keys.data.frame(key)
  dat <- df_disassemble(object)

  ## Possibly worth cleaning out all keys that are possible.
  db$set(keys$type, "data.frame")
  db$set(keys$mode, mode)

  preclean <- c(keys$rownames, keys$names, if (mode == "rows") keys$rows)
  db$del(preclean)

  db$rpush(keys$rownames, dat$rownames)
  db$rpush(keys$names,    dat$names)
  db$mset(keys$levels,    object_to_string(dat$levels))

  ## This bit specific for rows:
  if (mode == "rows") {
    db$rpush(keys$rows, vcapply(dat$rows, object_to_string))
  } else if (mode == "cells") {
    browser()
  } else if (mode == "single") {
    db$set(keys$rows, object_to_string(object))
  }

  ## } else if (mode == "cells") {
  ##   for (i in seq_along(keys$rows)) {
  ##     x <- vcapply(object[i,], object_to_string, USE.NAMES=FALSE)
  ##     db$hmset(keys$rows[[i]], dat$names, x)
  ##   }
  ## } else {

  # }

  at <- attributes(object)
  at$names <- at$row.names <- NULL # already stored
  ## Should do this with a list?
  db$set(keys$attributes, object_to_string(at))
  invisible(NULL)
}

keys.data.frame <- function(key) {
  list(mode=sprintf("%s:mode", key),
       rows=sprintf("%s:rows", key),
       rownames=sprintf("%s:rownames", key),
       names=sprintf("%s:names", key),
       type=sprintf("%s:type", key),
       levels=sprintf("%s:levels", key),
       attributes=sprintf("%s:attributes", key))
}

df_disassemble <- function(x) {
  names <- names(x)
  rownames <- rownames(x)

  ## de-factor:
  i <- vlapply(x, is.factor)
  levels <- lapply(x[i], levels)
  x[i] <- lapply(x[i], as.integer)

  ## prepare for split:
  x <- unname(x)
  rownames(x) <- NULL
  rows <- df_to_rows(x)

  list(names=names, rownames=rownames, rows=rows, levels=levels)
}

## TODO: Not transitive for all factor types; we'd need to deal with
## *all* elements of factor.  So that's not ideal.  But should work
## reasonably well for now.
##   * ordered comes from is.ordered
##   * labels might differ from levels (WTF?)
##   * exclude, nmax: not our problem
## Safer might be to warn & drop the factor?
df_reassemble <- function(names, rownames, rows, levels) {
  f <- function(x) {
    structure(x, names=names, class="data.frame", row.names=1L)
  }
  rows <- lapply(rows, f)
  df <- do.call("rbind", rows, quote=TRUE)
  attr(df, "row.names") <- rownames

  ## re-factor:
  for (i in names(levels)) {
    df[[i]] <- factor(df[[i]], levels[[i]])
  }
  df
}
