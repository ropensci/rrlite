## Automatically generated from redux:R/redis.R: do not edit by hand
## These are the low-level commands for interfacing with Redis;
## creating pointers and interacting with them directly happens in
## this file and this file only.  Nothing here should be directly used
## from user code; see the functions in connection.R for what to use.
rlite_connect <- function(config) {
  if (config$scheme == "redis") {
    ptr <- rlite_connect_tcp(config$host, config$port)
  } else {
    ptr <- rlite_connect_unix(config$path)
  }
  if (!is.null(config$password)) {
    rlite_command(ptr, c("AUTH", config$password))
  }
  if (!is.null(config$db)) {
    rlite_command(ptr, c("SELECT", config$db))
  }
  ptr
}

rlite_connect_tcp <- function(host, port) {
  .Call(Crrlite_rlite_connect, host, as.integer(port))
}

rlite_connect_unix <- function(path) {
  .Call(Crrlite_rlite_connect_unix, path)
}

rlite_command <- function(ptr, command) {
  .Call(Crrlite_rlite_command, ptr, command)
}

rlite_pipeline <- function(ptr, list) {
  .Call(Crrlite_rlite_pipeline, ptr, list)
}

redis_subscribe <- function(ptr, channel, pattern, callback, envir) {
  ## This actually needs to depend on the sort of error.  Don't
  ## respond based on
  ##   _redis connection errors_
  ## because those we should just not go any further on.  But to get
  ## that working I'd need to work out how to raise classed errors
  ## from C, and that's going to require some decent toxiproxy testing
  ## too.
  ##
  ## Also, while we check all over the show that pattern needs to be a
  ## scalar logical, we don't want to trigger the on.exit call if the
  ## failure was due to the pattern being incorrect (this is actually
  ## slightly worse than failures in general (say callback not a
  ## function) because incorrect access of a NULL could crash R).
  ##
  ## What would be ideal would be to write something into an
  ## environment (even the one passed in) saying that subscription had
  ## started and then switching on that.  But that's a big hassle for
  ## a difficult corner case.
  on.exit(.Call(Crrlite_rlite_unsubscribe, ptr, channel, pattern))
  .Call(Crrlite_rlite_subscribe, ptr, channel, pattern, callback, envir)
  invisible()
}
