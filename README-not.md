# rrlite

[![Build Status](https://travis-ci.org/ropensci/rrlite.png?branch=master)](https://travis-ci.org/ropensci/rrlite)
[![Coverage Status](https://coveralls.io/repos/ropensci/rrlite/badge.svg?branch=master)](https://coveralls.io/r/ropensci/rrlite?branch=master)
[![Status at rOpenSci software peer-review](https://badges.ropensci.org/6_status.svg)](https://github.com/ropensci/onboarding/issues/6)



R interface to [rlite](https://github.com/seppo0010/rlite).  rlite is a "self-contained, serverless, zero-configuration, transactional redis-compatible database engine. rlite is to Redis what SQLite is to SQL.  And `Redis` is a *data structures* server; at the simplest level it can be used as a key-value store, but it can store other data types (hashes, lists, sets and more).

This package is designed to follow exactly the same interface as [redux](https://github.com/richfitz/redux).

# Usage

See [`redux`](https://github.com/richfitz/redux) for more details.

The main function here is `rrlite::hirlite` that creates a `redis_api` object that exposes the full Redis API.


```r
con <- rrlite::hirlite()
```


```r
con
```

```
## <redis_api>
##   Redis commands:
##     APPEND: function
##     AUTH: function
##     BGREWRITEAOF: function
##     BGSAVE: function
##     ...
##     ZSCORE: function
##     ZUNIONSTORE: function
##   Other public methods:
##     clone: function
##     command: function
##     config: function
##     initialize: function
##     pipeline: function
##     reconnect: function
##     subscribe: function
##     type: function
```

This object has all the same methods as the corresponding object created by `redux::hiredis()` but operating on a rlite database.  The default database uses the magic path `:memory:` but persistent on-disk storage is possible (see `?rlite_config`).

All the usual Redis-type things work:


```r
con$SET("mykey", "mydata")
```

```
## [Redis: OK]
```

```r
con$GET("mykey")
```

```
## [1] "mydata"
```

As with redux, commands are vectorised:


```r
con$MSET(c("a", "b", "c"), c(1, 2, 3))
```

```
## [Redis: OK]
```

```r
con$MGET(c("a", "b", "c"))
```

```
## [[1]]
## [1] "1"
##
## [[2]]
## [1] "2"
##
## [[3]]
## [1] "3"
```

# Approach

This package aims to be a drop-in self-contained replacement for `redux` without requiring  `Redis` server.  Therefore almost the entire package (and tests) is automaticaly generated from `redux`.  The only installed files not generated are:

* R/hirlite.R (because documentation)
* src/subscribe.c (just a stub)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rrlite/issues).
* License: GPL
* Get citation information for `rrlite` in R by doing `citation(package = 'rrlite')`

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
