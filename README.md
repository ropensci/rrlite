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
r$list()
```

This always serialises/deserialises R objects, so is most similar to things like [RcppRedis](https://github.com/eddelbuettel/rcppredis) and [rredis](http://cran.r-project.org/web/packages/rredis/index.html).  It provides only four commands at present: `get`, `set`, `list` and `del`.

## Redis level

Provides a reasonably complete interface to raw redis commands:

```r
redis_commands("string")
db <- rrlite::rlite(":memory:")
db$set("foo", "bar")
db$get("foo")
db$keys("*")
```

This does not do serialisation/deserialisation, so you're on your own with getting data in and out.  Very little sanitisation of input and output is done (for arrays are left as R lists, etc).  But this provides an almost complete set of redis commands so this is the correct level for package developers who want more control over how things are stored or want to use more advanced redis features than get/set.

## Low level

```r
con <- rlite_context(":memory:")
con$run(c("set", "foo", "bar"))
```

All commands supported by `rlite`, with no error checking.

Asynchronous support via

```
con$write(c("set", "foo", "bar"))
con$read()
```

# Installation

To install, after cloning the repo the first time, run:

```
git submodule init
git submodule update
```

(from the command line)

```
./bootstrap.sh
```

which will clone the current version of rlite.  There are no releases to point at yet, so this is going to be a moving target for a while.  I'll modify the script to keep to current soon.  See [this related issue](https://github.com/richfitz/rrlite/issues/1) for jqr.

## Meta

* Please [report any issues or bugs](https://github.com/richfitz/rrlite/issues).
* License: BSD (2 clause)
* Get citation information for `rrlite` in R doing `citation(package = 'rrlite')`
