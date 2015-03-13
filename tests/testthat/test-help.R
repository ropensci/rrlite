context("help")

## This will become the low-level object that we'll build things
## around:
test_that("help", {
  str <- cmds$SET$summary
  expect_that(redis_help("SET"), prints_text(str))
  expect_that(redis_help("set"), prints_text(str))
  expect_that(redis_help("nosuch"),
              throws_error("Command 'NOSUCH' not valid"))
})

test_that("commands", {
  cmds_all <- redis_commands()
  cmds_string <- redis_commands("string")
  cmds_nosuch <- redis_commands("nosuch")
  expect_that(cmds_all, is_a("character"))
  expect_that(cmds_all, equals(names(cmds)))
  expect_that(all(cmds_string %in% cmds_all), is_true())
  expect_that(length(cmds_string) < length(cmds_all), is_true())
  expect_that(cmds_nosuch, is_identical_to(character(0)))

  groups <- redis_commands_groups()
  expect_that(groups, is_a("character"))
  expect_that(length(groups), equals(11L))
  expect_that(redis_commands(groups),
              is_identical_to(redis_commands()))
  expect_that(sort(redis_commands(c("string", "hash"))),
              equals(sort(union(cmds_string,
                                redis_commands("hash")))))
})
