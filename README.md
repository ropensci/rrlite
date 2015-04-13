# rrlite

[![Build Status](https://travis-ci.org/ropensci/rrlite.png?branch=master)](https://travis-ci.org/ropensci/rrlite)
[![Coverage Status](https://coveralls.io/repos/ropensci/rrlite/badge.svg?branch=master)](https://coveralls.io/r/ropensci/rrlite?branch=master)

R interface to rlite https://github.com/seppo0010/rlite

# Usage

## High level

Really basic get/set of R objects.  For now this is called `rdb`, but that's up for change.


```r
r <- RedisAPI::rdb(rrlite::hirlite)
r$set("foo", runif(20))
r$get("foo")
```

```
##  [1] 0.78390876 0.20506067 0.52435516 0.08032271 0.59842613 0.55835891
##  [7] 0.63068016 0.42993257 0.69701444 0.81063080 0.87672640 0.30630597
## [13] 0.17545979 0.76347071 0.60290470 0.80497685 0.11347877 0.01921442
## [19] 0.26370165 0.88997782
```

```r
r$keys()
```

```
## [1] "foo"
```

This always serialises/deserialises R objects, so is most similar to things like [RcppRedis](https://github.com/eddelbuettel/rcppredis) and [rredis](http://cran.r-project.org/web/packages/rredis/index.html).  It provides only four commands at present: `get`, `set`, `list` and `del`.

## Redis level

Provides a reasonably complete interface to raw redis commands:


```r
db <- rrlite::hirlite(":memory:")
db$SET("foo", "bar")
```

```
## [1] "OK"
```

```r
db$GET("foo")
```

```
## [1] "bar"
```

```r
db$KEYS("*")
```

```
## [[1]]
## [1] "foo"
```

This does not do serialisation/deserialisation, so you're on your own with getting data in and out.  Very little sanitisation of input and output is done (for arrays are left as R lists, etc).  But this provides an almost complete set of redis commands so this is the correct level for package developers who want more control over how things are stored or want to use more advanced redis features than get/set.

Get lists of commands from the [main redis documentation](redis.io/commands/) or some help via


```r
RedisAPI::redis_help("SET")
```

```
## Set the string value of a key
## NULL
```

```r
RedisAPI::redis_commands("string")
```

```
##  [1] "APPEND"      "BITCOUNT"    "BITOP"       "BITPOS"      "DECR"
##  [6] "DECRBY"      "GET"         "GETBIT"      "GETRANGE"    "GETSET"
## [11] "INCR"        "INCRBY"      "INCRBYFLOAT" "MGET"        "MSET"
## [16] "MSETNX"      "PSETEX"      "SET"         "SETBIT"      "SETEX"
## [21] "SETNX"       "SETRANGE"    "STRLEN"
```

```r
RedisAPI::redis_commands_groups()
```

```
##  [1] "connection"   "generic"      "hash"         "hyperloglog"
##  [5] "list"         "pubsub"       "scripting"    "server"
##  [9] "set"          "sorted_set"   "string"       "transactions"
```

## Low level


```r
con <- rrlite::rlite_context(":memory:")
con$run(c("set", "foo", "bar"))
```

```
## [1] "OK"
```

All commands supported by `rlite`, with no error checking.

Asynchronous support via

```
con$write(c("set", "foo", "bar"))
con$read()
```

# Installation

Because the source currently contains a submodule, the usual approach with `devtools::install_github` does not work, but this does:

```
devtools::install_github("ropensci/RedisAPI")
devtools::install_git("https://github.com/ropensci/rrlite", args="--recursive")
```

If installing manually, either clone the repository with the argument `--recursive` or after cloning the repository for the first time, run:

```
git submodule init
git submodule update
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rrlite/issues).
* License: BSD (2 clause)
* Get citation information for `rrlite` in R doing `citation(package = 'rrlite')`

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
