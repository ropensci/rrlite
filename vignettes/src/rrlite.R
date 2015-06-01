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

## - `rrlite` is an R interface to the [`rlite`](https://github.com/seppo0010/rlite) library.
## - `rlite` is a self-contained, serverless, zero-configuration, transactional redis-compatible database engine. `rlite` is to `Redis` what SQLite is to SQL.
## - `Redis` is a *data structures* server; at the simplest level it can be used as a key-value store, but it can store other data types (hashes, lists, sets and more).

## `rrlite` makes it easy to use `Redis` features without having to install and run a server just to save bits of data.  It can run a persistent storage to disk, or it can run ephemeral storage in memory.  The package will be mostly useful to package developers who need to store reasonable amounts of data, or for people developing HPC applications where the amount of data needed to be addressed is more than can be fit into memory.

library(RedisAPI)
library(rrlite)

## # Interfaces

## There are three levels of interface built into the package, with the idea that these provide different levels of abstraction to build off.

## * Highest level `rdb`: This is an example of what one might build on top of `rrlite`.  It provides a very simple key/value store for saving and restoring any R object that can be serialised.
## * Medium level `rlite`: This is the main interface.  It provdes access to `r length(ls(hirlite())) - 1L` `Redis` commands as a set of user-friendly R functions that do basic error checking.  This is the level that new applications would be build from, and `rdb` is built on top of `rlite`.
## * Lowest level `rlite_context`: This is direct access to the `rlite` library; commands are passed unchecked, and this can work in an asynchronous mode.  The `rlite` interface is built on top of this level.

## One of the use cases of [`rlite`](https://github.com/seppo0010/rlite) is to replace Redis in the stack for testing/development, but to allow swapping Redis in because it is compatible with Redis.  `rrlite` supports the same workflow; develop locally but switch to using Redis at some later stage (e.g., scaling a problem to work across a cluster) by using the [`RedisAPI`](https://github.com/ropensci/RedisAPI) package.

r1 <- rrlite::hirlite()
r1$PING()

## Then, using `Redis` (this requires a working Redis server, here assumed to be running locally on port)

r2 <- RedisAPI::hiredis()
r2$PING()

## All the commands are the same; in fact the only way of telling if you have an `rlite` or an `Redis` based interface (currently) is to inspect the `type` member:

r1$type # rrlite
r2$type # RcppRedis

## So, things like this work:

r1$MSET(c("a", "b", "c"), c(1, 2, 3))
r1$MGET(c("a", "b", "c"))

r2$MSET(c("a", "b", "c"), c(1, 2, 3))
r2$MGET(c("a", "b", "c"))

## All the handling of arguments, etc should be the same (though note they will differ from the user-friendly interface available in RcppRedis).

## You can also create rdb databases, in memory:

r <- RedisAPI::rdb(rrlite::hirlite)
r$set("cars", mtcars)
head(r$get("cars"))

## or persistently to disk:

r <- RedisAPI::rdb(rrlite::hirlite, "tmp.rdb")
r$set("cars", mtcars)
head(r$get("cars"))
file.exists("tmp.rdb")

## ## Low level interface

## Probably best not to use this unless you really need to, but this provides the most complete interface to `rlite` with the least amount of checking.  If complete speed is the aim then working via this interface and doing just the checking that you want might be the best bet.

con <- rrlite::rlite_context(":memory:")
con$run(c("SET", "foo", "bar"))
con$run(c("GET", "foo"))

## You can run asynchronously

con$write(c("set", "foo", "bar"))
con$read()

## but you're responsible for making sure there are no pending replies by matching every `write`  call with a `read` call.  This might be useful for blocking operations.

##+ echo=FALSE, results="hide"
rm(r)
gc()
file.remove("tmp.rdb")
