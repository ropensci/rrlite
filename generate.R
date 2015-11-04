#!/usr/bin/env Rscript

## generated interface from redux.
path_redux <- "~/Documents/src/redux"

## Connections need:
##   hiredis.h -> hirlite.h
##   redisReply -> rliteReply
##   REDIS_REPLY -> RLITE_REPLY
##   redisContext -> rliteContext
##   redisCommandArgv -> rliteCommandArgv

files <- c(paste0("connection.", c("c", "h")),
           paste0("conversions.", c("c", "h")))

change <- c("hiredis.h"="hirlite.h",
            "redisReply"="rliteReply",
            "REDIS_REPLY"="RLITE_REPLY",
            "redisFree"="rliteFree",
            "redisConnect"="rliteConnect",
            "redisContext"="rliteContext",
            "redisCommandArgv"="rliteCommandArgv",
            "redisAppendCommandArgv"="rliteAppendCommandArgv",
            "redisGetReply"="rliteGetReply",
            "freeReplyObject"="rliteFreeReplyObject",
            "redux_redis"="rrlite_rlite")

tr <- function(src) {
  header <- sprintf("// Automatically generated from %s: do not edit by hand",
                    paste0("redux:", file.path("src", src)))
  dest <- file.path("src", basename(src))
  str <- readLines(src)
  from <- names(change)
  to <- unname(change)
  for (i in seq_along(change)) {
    str <- gsub(from[[i]], to[[i]], str, fixed=TRUE)
  }
  writeLines(str, dest)
}

for (i in file.path(path_redux, "src", files)) {
  tr(i)
}
