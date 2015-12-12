#!/usr/bin/env Rscript

## generated interface from redux.

## Most of the files are generated:

## R/
##   - connection.R
##   - hirlite.R [no, need some custom docs]
##   - rlite.R
##
## src/
##  - connection.c
##  - connection.h
##  - src/conversions.c
##  - src/conversions.h
##  - src/registration.c
##  - src/subscribe.h
##  - src/subscribe.c [no, stub only]
##
## tests/testthat/
##  - helper-common.R
##  - helper-rrlite.R [no, custom helpers]
##  - test-aaa.R
##  - test-config.R [no, custom configuration treatment]
##  - test-interface.R
##  - test-objects.R
##  - test-rlite.R
##  - test-tools.R

## Globals, for now at least:
path_redux <- "~/Documents/src/redux"
change_path <- c(redis="rlite", redux="rrlite")

tr <- function(str, change) {
  from <- names(change)
  to <- unname(change)
  for (i in seq_along(change)) {
    str <- gsub(from[[i]], to[[i]], str, perl=TRUE)
  }
  str
}

translate <- function(src, change, dir, comment) {
  header <- sprintf("%s Automatically generated from %s: do not edit by hand",
                    comment, paste0("redux:", file.path(dir, src)))
  dest <- file.path(dir, tr(basename(src), change_path))
  str <- readLines(file.path(path_redux, dir, src))
  str <- tr(str, change)
  writeLines(c(header, str), dest)
}

## C code:
files_c <- c("connection.c",
             "connection.h",
             "conversions.c",
             "conversions.h",
             "registration.c",
             "subscribe.h")
change_c <- c("hiredis\\.h"="hirlite.h",
              "redisReply"="rliteReply",
              "REDIS_REPLY"="RLITE_REPLY",
              "redisFree"="rliteFree",
              "redisConnect"="rliteConnect",
              "redisContext"="rliteContext",
              "redisCommandArgv"="rliteCommandArgv",
              "redisAppendCommandArgv"="rliteAppendCommandArgv",
              "redisGetReply"="rliteGetReply",
              "freeReplyObject"="rliteFreeReplyObject",
              "redux_redis"="rrlite_rlite",
              "init_redux"="init_rrlite")
for (i in files_c) {
  translate(i, change_c, "src", "//")
}

## tests (R code):
## Slightly different complicated changes for the tests
change_r <- c("redux_redis"="rrlite_rlite",
              "(?<! <- \")redis_connect"="rlite_connect",
              "redis_command"="rlite_command",
              "redis_pipeline"="rlite_pipeline",
              '"hiredis"'='"rlite"',
              "127\\.0\\.0\\.1"=":memory:",
              "hiredis"="hirlite",
              "skip_if_no_redis"="skip_if_no_rlite",
              "redis_available"="rlite_available",
              "useDynLib redux"="useDynLib rrlite",
              "Redis connection"="rlite connection",
              "RedisAPI::redis_config"="rlite_config",
              "redis_config"="rlite_config",
              '"redux"'='"rrlite"')

files_t <- c("helper-common.R",
             "test-aaa.R",
             "test-connection.R",
             "test-interface.R",
             "test-redis.R",
             "test-tools.R")
for (i in files_t) {
  translate(i, change_r, "tests/testthat", "##")
}

files_r <- c("connection.R", "redis.R")
for (i in files_r) {
  translate(i, change_r, "R", "##")
}
