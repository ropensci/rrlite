context("rlite")

test_that("connection", {
  ptr <- rlite_connect_unix(":memory:")
  ## Dangerous raw pointer:
  expect_that(ptr, is_a("externalptr"))
  ## Check for no crash:
  rm(ptr)
  gc()
})

test_that("simple commands", {
  ptr <- rlite_connect_unix(":memory:")

  ans <- rlite_command(ptr, list("PING"))
  expect_that(ans, is_a("redis_status"))
  expect_that(print(ans), prints_text("[Redis: PONG]", fixed=TRUE))
  expect_that(as.character(ans), is_identical_to("PONG"))

  expect_that(rlite_command(ptr, "PING"),
              is_identical_to(ans))
  expect_that(rlite_command(ptr, list("PING", character(0))),
              is_identical_to(ans))

  ## Various invalid commands; some of these need more consistent
  ## errors I think.  Importantly though, none crash.
  expect_that(rlite_command(ptr, NULL),
              throws_error("Invalid type"))
  expect_that(rlite_command(ptr, 1L),
              throws_error("Invalid type"))
  expect_that(rlite_command(ptr, list()),
              throws_error("argument list cannot be empty"))
  expect_that(rlite_command(ptr, list(1L)),
              throws_error("Redis command must be a non-empty character"))
  expect_that(rlite_command(ptr, character(0)),
              throws_error("Redis command must be a non-empty character"))
  expect_that(rlite_command(ptr, list(character(0))),
              throws_error("Redis command must be a non-empty character"))
})

test_that("commands with arguments", {
  ptr <- rlite_connect_unix(":memory:")

  expect_that(rlite_command(ptr, list("SET", "foo", "1")), is_OK())
  expect_that(rlite_command(ptr, list("SET", "foo", "1")), is_OK())

  expect_that(rlite_command(ptr, list("GET", "foo")), equals("1"))
})

test_that("commands with NULL arguments", {
  ptr <- rlite_connect_unix(":memory:")

  expect_that(rlite_command(ptr, list("SET", "foo", "1", NULL)), is_OK())
  expect_that(rlite_command(ptr, list("SET", "foo", NULL, "1", NULL)),
              is_OK())
  expect_that(rlite_command(ptr, list("SET", NULL, "foo", NULL, "1", NULL)),
              is_OK())
})

test_that("missing values are NULL", {
  ptr <- rlite_connect_unix(":memory:")
  key <- rand_str(prefix="redux_")
  expect_that(rlite_command(ptr, list("GET", key)),
              is_null())
})

test_that("Errors are converted", {
  ptr <- rlite_connect_unix(":memory:")
  key <- rand_str(prefix="redux_")
  on.exit(rlite_command(ptr, c("DEL", key)))
  ## Conversion to integer:
  expect_that(rlite_command(ptr, c("LPUSH", key, "a", "b", "c")),
              is_identical_to(3L))
  expect_that(rlite_command(ptr, c("HGET", key, 1)),
              throws_error("WRONGTYPE"))
})

## Warning; this pipeline approach is liable to change because we'll
## need to do it slightly differently perhaps.  The main api approach
## would be a *general* codeblock that added commands to a buffer and
## then executed them.  To get that to work we'll need support a
## growing list or pushing them directly into Redis' buffer and
## keeping them protected appropriately.  So for now the automatically
## balanced approach is easiest.
test_that("Pipelining", {
  ptr <- rlite_connect_unix(":memory:")
  key <- rand_str(prefix="redux_")
  cmd <- list(list("SET", key, "1"), list("GET", key))
  on.exit(rlite_command(ptr, c("DEL", key)))

  x <- rlite_pipeline(ptr, cmd)
  expect_that(length(x), equals(2))
  expect_that(x[[1]], is_OK())
  expect_that(x[[2]], equals("1"))

  ## A pipeline with an error:
  cmd <- list(c("HGET", key, "a"), c("INCR", key))
  y <- rlite_pipeline(ptr, cmd)
  expect_that(length(x), equals(2))
  expect_that(y[[1]], is_a("redis_error"))
  expect_that(y[[1]], matches("^WRONGTYPE"))
  ## This still ran:
  expect_that(y[[2]], is_identical_to(2L))
})

## Storing binary data:
test_that("Binary data", {
  ptr <- rlite_connect_unix(":memory:")
  data <- serialize(1:5, NULL)
  key <- rand_str(prefix="redux_")
  expect_that(rlite_command(ptr, list("SET", key, data)),
              is_OK())
  x <- rlite_command(ptr, list("GET", key))
  expect_that(x, is_a("raw"))
  expect_that(x, equals(data))

  key2 <- rand_str(prefix="redux_")
  ok <- rlite_command(ptr, list("MSET", key, "1", key2, data))
  expect_that(ok, is_OK())

  res <- rlite_command(ptr, list("MGET", key, key2))
  expect_that(res, equals(list("1", data)))

  expect_that(rlite_command(ptr, c("DEL", key, key2)), equals(2L))
})

test_that("Lists of binary data", {
  ptr <- rlite_connect_unix(":memory:")
  data <- serialize(1:5, NULL)
  key1 <- rand_str(prefix="redux_")
  key2 <- rand_str(prefix="redux_")
  cmd <- list("MSET", list(key1, data, key2, data))

  ok <- rlite_command(ptr, list("MSET", list(key1, data, key2, data)))
  expect_that(ok, is_OK())
  res <- rlite_command(ptr, list("MGET", key1, key2))
  expect_that(res, equals(list(data, data)))

  ## But throw an error on a list of lists of lists:
  expect_that(
    rlite_command(ptr, list("MSET", list(key1, data, key2, list(data)))),
    throws_error("Nested list element"))
  expect_that(
    rlite_command(ptr, list("MSET", list(list(key1), data, key2, data))),
    throws_error("Nested list element"))
})

test_that("socket connection", {
  skip("not relevant")
  redis_server <- Sys.which("redis-server")
  if (redis_server == "") {
    skip("didn't find redis server")
  }
  logfile <- tempfile("redis_")
  socket <- tempfile("socket_")
  system2(redis_server, c("--port", 0, "--unixsocket", socket),
          wait=FALSE, stdout=logfile, stderr=logfile)
  Sys.sleep(.1)

  ptr_sock <- redis_connect_unix(socket)
  ptr_tcp  <- rlite_connect_unix(":memory:")
  cmp <- redis_status("PONG")
  expect_that(rlite_command(ptr_sock, list("PING")), equals(cmp))
  expect_that(rlite_command(ptr_tcp,  list("PING")), equals(cmp))

  expect_that(rlite_command(ptr_sock, "SHUTDOWN"),
              throws_error("Failure communicating with the Redis server"))
  expect_that(file.exists(socket), is_false())
})

test_that("pointer commands are safe", {
  expect_that(rlite_command(NULL, "PING"),
              throws_error("Expected an external pointer"))
  expect_that(rlite_command(list(), "PING"),
              throws_error("Expected an external pointer"))
  ptr <- rlite_connect_unix(":memory:")
  expect_that(rlite_command(list(ptr), "PING"),
              throws_error("Expected an external pointer"))

  expect_that(rlite_command(ptr, "PING"),
              equals(redis_status("PONG")))

  ptr_null <- unserialize(serialize(ptr, NULL))
  expect_that(rlite_command(ptr_null, "PING"),
              throws_error("Context is not connected"))
})
