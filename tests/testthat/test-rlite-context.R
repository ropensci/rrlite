context("rlite_context")

test_that("close context", {
  con <- rlite_context()
  con$run("PING")

  expect_that(is_null_pointer(con$ptr), is_false())
  expect_that(con$is_closed(), is_false())

  expect_that(con$close(), is_true())
  expect_that(is_null_pointer(con$ptr), is_true())
  expect_that(con$is_closed(), is_true())

  expect_that(con$run("PING"), throws_error("Context is not connected"))

  expect_that(con$close(), gives_warning("Context is not connected"))
  expect_that(suppressWarnings(con$close()), is_false())
  rm(con)
  gc() # no crash, we hope.
})

test_that("context filename", {
  con <- rlite_context()
  expect_that(.Call("rrlite_filename", con$ptr), equals(con$path))
  con$close()
  expect_that(.Call("rrlite_filename", con$ptr), equals(con$path))
  rm(con)
  gc() # no crash, we hope.
})

test_that("reopen", {
  con <- rlite_context("test.rld")
  expect_that(file.exists("test.rld"), is_true())
  on.exit(file.remove("test.rld"))
  con$run(c("SET", "foo", "bar"))
  expect_that(con$is_closed(), is_false())

  con$close()
  expect_that(con$is_closed(), is_true())

  expect_that(con$run(c("GET", "foo")),
              throws_error("Context is not connected"))
  expect_that(con$reopen(), is_true())
  expect_that(con$run(c("GET", "foo")), equals("bar"))
  expect_that(con$reopen(), is_false())
})

## From rlite/src/tests/db.c
test_that("db:keys", {
  con <- rlite_context(":memory:")

  con$write(c("set", "key1", "mydata"))
  expect_that(con$read(), equals("OK"))

  con$write(c("set", "key2", "otherdata"))
  expect_that(con$read(), equals("OK"))

  con$write(c("keys", "*"))
  expect_that(con$read(), equals(list("key1", "key2")))

  con$write(c("keys", "*1"))
  expect_that(con$read(), equals(list("key1")))
})

test_that("db:dbsize", {
  con <- rlite_context(":memory:")

  con$write(c("set", "key1", "mydata"))
  expect_that(con$read(), equals("OK"))

  con$write("dbsize")
  expect_that(con$read(), is_identical_to(1L))

  con$write(c("set", "key2", "otherdata"))
  expect_that(con$read(), equals("OK"))

  con$write("dbsize")
  expect_that(con$read(), is_identical_to(2L))
})

## test_that("db:expire", {
##   con <- rlite_context(":memory:")

##   con$write(c("set", "key1", "mydata"))
##   expect_that(con$read(), equals("OK"))

##   # expire, -1
##   # pexpire, -1
##   # expireat 1000
##   # pexpireat 1000

## })

test_that("db:rename", {
  con <- rlite_context(":memory:")

  con$write(c("set", "key1", "mydata"))
  expect_that(con$read(), equals("OK"))

  con$write(c("rename", "key1", "key2"))
  expect_that(con$read(), equals("OK"))

  con$write(c("get", "key1"))
  expect_that(con$read(), is_null())

  con$write(c("get", "key2"))
  expect_that(con$read(), equals("mydata"))
})

test_that("db:renamenx", {
  con <- rlite_context(":memory:")

  con$write(c("set", "key1", "mydata"))
  expect_that(con$read(), equals("OK"))

  con$write(c("renamenx", "key1", "key2"))
  expect_that(con$read(), is_identical_to(1L))

  con$write(c("get", "key1"))
  expect_that(con$read(), is_null())

  con$write(c("get", "key2"))
  expect_that(con$read(), equals("mydata"))

  con$write(c("set", "key1", "mydata2"))
  expect_that(con$read(), equals("OK"))

  con$write(c("renamenx", "key1", "key2"))
  expect_that(con$read(), is_identical_to(0L))

  con$write(c("get", "key1"))
  expect_that(con$read(), equals("mydata2"))

  con$write(c("get", "key2"))
  expect_that(con$read(), equals("mydata"))
})

test_that("db:ttl_pttl", {
  con <- rlite_context(":memory:")

  ## This is failing to set:
  con$write(c("setex", "key1", "5", "mydata"))
  expect_that(con$read(), equals("OK"))

  ##   con$write(c("ttl", "key1"))
  ##   expect_that(con$read(), is_identical_to(5L))

  ##   con$write(c("pttl", "key1"))
  ##   expect_that(con$read(), is_identical_to(500L))
})

test_that("db:persist", {
  con <- rlite_context(":memory:")

  con$write(c("persist", "key1"))
  expect_that(con$read(), is_identical_to(0L))

  con$write(c("setex", "key1", "5", "mydata"))
  expect_that(con$read(), equals("OK"))

  ## Also failing:
  ## con$write(c("persist", "key1"))
  ## expect_that(con$read(), is_identical_to(1L))

  ## con$write(c("persist", "key1"))
  ## expect_that(con$read(), is_identical_to(0L))

  ## con$write(c("ttl", "key1"))
  ## expect_that(con$read(), is_identical_to(-1L))
})

test_that("db:select", {
  con <- rlite_context(":memory:")

  con$write(c("set", "key1", "mydata"))
  expect_that(con$read(), equals("OK"))

  con$write(c("select", "1"))
  expect_that(con$read(), equals("OK"))

  con$write(c("exists", "key1"))
  expect_that(con$read(), is_identical_to(0L))

  con$write(c("select", "0"))
  expect_that(con$read(), equals("OK"))

  con$write(c("get", "key1"))
  expect_that(con$read(), is_identical_to("mydata"))
})

test_that("db:move", {
  con <- rlite_context(":memory:")

  con$write(c("set", "key1", "mydata"))
  expect_that(con$read(), equals("OK"))

  con$write(c("move", "key1", "1"))
  expect_that(con$read(), equals(1L))

  con$write(c("exists", "key1"))
  expect_that(con$read(), equals(0L))

  con$write(c("move", "key2", "1"))
  expect_that(con$read(), equals(0L))

  con$write(c("set", "key1", "mydata"))
  expect_that(con$read(), equals("OK"))

  con$write(c("move", "key1", "1"))
  expect_that(con$read(), equals(0L))
})

test_that("db:type", {
  con <- rlite_context(":memory:")

  expect_that(con$run(c("set", "str", "mydata")), equals("OK"))
  expect_that(con$run(c("type", "str")), equals("string"))

  expect_that(con$run(c("lpush", "list", "mydata")),
              is_identical_to(1L))
  expect_that(con$run(c("type", "list")), equals("list"))

  expect_that(con$run(c("sadd", "set", "mydata")),
              is_identical_to(1L))
  expect_that(con$run(c("type", "set")), equals("set"))

  expect_that(con$run(c("zadd", "zset", "0", "mydata")),
              is_identical_to(1L))
  expect_that(con$run(c("type", "zset")), equals("zset"))

  expect_that(con$run(c("hset", "hash", "field", "value")),
              is_identical_to(1L))
  expect_that(con$run(c("type", "hash")), equals("hash"))

  expect_that(con$run(c("type", "none")), equals("none"))
})

test_that("db:randomkey", {
  con <- rlite_context(":memory:")

  expect_that(con$run("randomkey"), is_null())

  expect_that(con$run(c("set", "key1", "mydata")), equals("OK"))

  expect_that(con$run("randomkey"), equals("key1"))
})


test_that("db:flushdb", {
  con <- rlite_context(":memory:")

  expect_that(con$run("flushdb"), equals("OK"))

  expect_that(con$run(c("set", "key1", "mydata")), equals("OK"))

  expect_that(con$run("dbsize"), is_identical_to(1L))

  expect_that(con$run("flushdb"), equals("OK"))
  expect_that(con$run("dbsize"), is_identical_to(0L))
})

test_that("db:flushdb_multidb", {
  con <- rlite_context(":memory:")

  expect_that(con$run(c("set", "key1", "mydata")), equals("OK"))
  expect_that(con$run(c("select", "1")), equals("OK"))
  expect_that(con$run(c("flushdb")), equals("OK"))
  expect_that(con$run(c("select", "0")), equals("OK"))
  expect_that(con$run(c("dbsize")), is_identical_to(1L))
})
