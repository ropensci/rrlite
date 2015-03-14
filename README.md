# rrlite

[![Build Status](https://travis-ci.org/richfitz/rrlite.png?branch=master)](https://travis-ci.org/richfitz/rrlite)
[![Coverage Status](https://coveralls.io/repos/richfitz/rrlite/badge.svg?branch=master)](https://coveralls.io/r/richfitz/rrlite?branch=master)

R interface to rlite https://github.com/seppo0010/rlite

# Usage

## High level

Really basic get/set of R objects.  For now this is called `rdb`, but that's up for change.


```r
r <- rrlite::rdb(":memory:")
r$set("foo", runif(20))
r$get("foo")
```

```
##  [1] 0.8521784 0.4338668 0.3049987 0.4831506 0.3287057 0.2530637 0.7263134
##  [8] 0.3472661 0.9710425 0.3014116 0.6545723 0.6389339 0.3895884 0.2126168
## [15] 0.5761024 0.2011597 0.4887290 0.5380709 0.7555557 0.3852459
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
db$set("foo", "bar")
```

```
## [1] "OK"
```

```r
db$get("foo")
```

```
## [1] "bar"
```

```r
db$keys("*")
```

```
## [[1]]
## [1] "foo"
```

This does not do serialisation/deserialisation, so you're on your own with getting data in and out.  Very little sanitisation of input and output is done (for arrays are left as R lists, etc).  But this provides an almost complete set of redis commands so this is the correct level for package developers who want more control over how things are stored or want to use more advanced redis features than get/set.

Get lists of commands from the [main redis documentation](redis.io/commands/) or some help via


```r
rrlite::redis_help("SET")
```

```
## Set the string value of a key
## function (key, value, ex = NULL, px = NULL, condition = NULL)
## NULL
```

```r
rrlite::redis_commands("string")
```

```
##  [1] "APPEND"      "BITCOUNT"    "BITOP"       "BITPOS"      "DECR"
##  [6] "DECRBY"      "GET"         "GETBIT"      "GETRANGE"    "GETSET"
## [11] "INCR"        "INCRBY"      "INCRBYFLOAT" "MGET"        "MSET"
## [16] "MSETNX"      "PSETEX"      "SET"         "SETBIT"      "SETEX"
## [21] "SETNX"       "SETRANGE"    "STRLEN"
```

```r
rrlite::redis_commands_groups()
```

```
##  [1] "connection"   "generic"      "hash"         "hyperloglog"
##  [5] "list"         "scripting"    "server"       "set"
##  [9] "sorted_set"   "string"       "transactions"
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
devtools::install_git("https://github.com/richfitz/rrlite", args="--recursive")
```

If installing manually, either clone the repository with the argument `--recursive` or after cloning the repository for the first time, run:

```
git submodule init
git submodule update
```

## Meta

* Please [report any issues or bugs](https://github.com/richfitz/rrlite/issues).
* License: BSD (2 clause)
* Get citation information for `rrlite` in R doing `citation(package = 'rrlite')`
