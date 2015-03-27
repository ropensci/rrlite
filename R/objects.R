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
  keys$rows <- sprintf("%s:rows:%s", key, rownames)
  at <- string_to_object(db$get(keys$attributes))
  at$row.names <- rownames
  at$names <- nms

  ## TODO: This is not OK: we should be indexing.
  d <- lapply(keys$rows, db$hgetall)

  i <- seq(2, length.out=length(nms), by=2)
  f <- function(x) {
    structure(lapply(x[i], string_to_object), names=x[-i])[nms]
  }
  dd <- lapply(d, f)

  ## TODO: This is a total hack: should create appropriate zero-row
  ## data.frame to use.
  ## TODO: Won't deal with the zero length case.
  dd[[1]] <- as.data.frame(dd[[1]])
  ret <- do.call("rbind", dd)

  attributes(ret) <- at
  attr(ret, "row.names") <- rownames
  ret
}

##' @export
to_redis.data.frame <- function(object, key, db, ...) {
  keys <- keys.data.frame(key, object)

  db$set(keys$type, "data.frame")

  nms <- names(object)

  ## This is slow because of the cost of the [i,] operation (50% of
  ## the time) and then a bit because of the redis op (50%).
  ## Serialisation is cheap.
  for (i in seq_along(keys$rows)) {
    ## This operation is likely to be slow: use Rcpp's serialise.
    x <- vcapply(object[i,], object_to_string, USE.NAMES=FALSE)
    db$hmset(keys$rows[[i]], nms, x)
  }

  db$del(c(keys$rownames, keys$names))
  db$rpush(keys$rownames, rownames(object))
  db$rpush(keys$names,    nms)

  at <- attributes(object)
  at$names <- at$row.names <- NULL # already stored
  ## Should do this with a list?
  db$set(keys$attributes, object_to_string(at))
  invisible(NULL)
}

keys.data.frame <- function(key, object=NULL) {
  list(rows=sprintf("%s:rows:%s", key, rownames(object)),
       rownames=sprintf("%s:rownames", key),
       names=sprintf("%s:names", key),
       type=sprintf("%s:type", key),
       attributes=sprintf("%s:attributes", key))
}
