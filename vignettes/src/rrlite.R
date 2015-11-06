## ---
## title: "rrlite introduction"
## author: "Rich FitzJohn"
## date: "`r Sys.Date()`"
## output: rmarkdown::html_vignette
## vignette: >
##   %\VignetteIndexEntry{rrlite introduction}
##   %\VignetteEngine{knitr::rmarkdown}
##   \usepackage[utf8]{inputenc}
## ---

## What is this thing?

## - `rrlite` is an R interface to the
##   [`rlite`](https://github.com/seppo0010/rlite) library.
## - `rlite` is a self-contained, serverless, zero-configuration,
##   transactional redis-compatible database engine. `rlite` is to
##   `Redis` what SQLite is to SQL.
## - `Redis` is a *data structures* server; at the simplest level it
##   can be used as a key-value store, but it can store other data
##   types (hashes, lists, sets and more).

## `rrlite` makes it easy to use `Redis` features without having to
## install and run a server just to save bits of data (though this is
## surprisingly easy).  It can run a persistent storage to disk, or it
## can run ephemeral storage in memory.

## The package is largely generated from the
## [`redux`](https://github.com/richfitz/redux) package, so the
## documentation there is the main port of call.

## One of the use cases of
## [`rlite`](https://github.com/seppo0010/rlite) is to replace Redis
## in the stack for testing/development, but to allow swapping Redis
## in because it is compatible with Redis.  `rrlite` supports the same
## workflow; develop locally but switch to using Redis at some later
## stage (e.g., scaling a problem to work across a cluster) by using
## the [`RedisAPI`](https://github.com/ropensci/RedisAPI) package.

r1 <- rrlite::hirlite()
r1$PING()

## Then, using `Redis` (this requires a working Redis server, here
## assumed to be running locally on port 6379)
r2 <- redux::hiredis()
r2$PING()

## All the commands are the same (though rlite does not support all commands).
## It's (currently) quite difficult to tell if the database is Redis or rlite, though you can inspect the `config` member:
class(r1$config())
class(r2$config())

## So, things like this work:

r1$MSET(c("a", "b", "c"), c(1, 2, 3))
r1$MGET(c("a", "b", "c"))

r2$MSET(c("a", "b", "c"), c(1, 2, 3))
r2$MGET(c("a", "b", "c"))

## All the handling of arguments, etc will be the same.
