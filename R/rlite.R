## These are the low-level commands for interfacing with Redis;
## creating pointers and interacting with them directly happens in
## this file and this file only.  Nothing here should be directly used
## from user code; see the functions in connection.R for what to use.
rlite_connect <- function(config) {
  to <- if (config$scheme == "redis") config$host else config$path
  ptr <- rlite_connect_unix(to)
  ## TODO: This pair could move into RedisAPI as
  if (!is.null(config$password)) {
    rlite_command(ptr, c("AUTH", config$password))
  }
  if (!is.null(config$db)) {
    rlite_command(ptr, c("SELECT", config$db))
  }
  ptr
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
