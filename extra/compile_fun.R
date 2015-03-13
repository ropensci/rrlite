indent <- function(x, n=2) {
  indent <- paste0(rep_len(" ", n), collapse="")
  paste0(indent, x)
}

reindent <- function(x, n) {
  vcapply(strsplit(x, "\n", fixed=TRUE),
          function(x) paste(indent(x, n), collapse="\n"))
}

viapply <- function(X, FUN, ...) {
  vapply(X, FUN, integer(1), ...)
}
dquote <- function(x) {
  sprintf('"%s"', x)
}

hirlite_cmd <- function(name, args) {
  paired <- viapply(args$name, length) > 1L
  if (any(paired)) {
    if (sum(paired) > 1L || length(args$name[[which(paired)]]) > 2L) {
      stop("This bit is not dealt with")
    }
  }

  ## Prefer "command" over "name" if it's given.
  if ("command" %in% names(args)) {
    command <- tolower(args$command)
    i <- !is.na(command)
    j <- i & !paired
    args$name_orig <- args$name
    args$name[j] <- command[j]
    j <- which(i & paired)
    if (length(j) > 0L) {
      args$name[[j]] <- paste(command[[j]], args$name[[j]], sep="_")
    }
  }

  ## need to be same length, share optional status.
  if (any(paired)) {
    if (sum(paired) > 1L) {
      stop()
    }
    if (length(args$name[[which(paired)]]) > 2L) {
      stop()
    }
    args1 <- args[!paired, , drop=FALSE]

    ## Lots of assumptions here:
    args2 <- args[rep(which(paired), 2L), ]
    args2$name <- args$name[[which(paired)]]
    args2$type <- args$type[[which(paired)]]

    args3 <- rbind(args1, args2)
    ## Reorder:
    args3 <- args3[match(unlist(args$name), args3$name), ]
    rownames(args3) <- NULL
    pair_from <- args$name[[which(paired)]][[1L]]
    pair_to   <- args$name[[which(paired)]][-1L]
    args3$paired <- ""
    args3$paired[match(pair_to, args3$name)] <- pair_from

    args3$name <- unlist(args3$name)

    args <- args3
  }

  ## At this point we should have no duplicates
  if (any(duplicated(args$name))) {
    stop("duplicate names")
  }
  args$name <- gsub("-", "_", args$name, fixed=TRUE)
  if (any(grepl("[^A-Za-z0-9._]", args$name))) {
    stop("invalid names")
  }

  multiple <- args$multiple
  if (is.null(multiple)) {
    multiple <- rep_len(FALSE, nrow(args))
  } else {
    multiple <- multiple & !is.na(multiple)
  }
  optional <- args$optional
  if (is.null(optional)) {
    optional <- rep_len(FALSE, nrow(args))
  } else {
    optional <- optional & !is.na(optional)
  }

  arg <- args$name
  arg[optional] <- paste0(arg[optional], "=NULL")
  fn_args <- paste(c(character(0), arg), collapse=", ")

  check <- sprintf("assert_scalar%s(%s)",
                   ifelse(optional, "_or_null", ""),
                   args$name)[!multiple]

  is_paired <- args$paired != ""
  paired <- sprintf("assert_length(%s, length(%s))",
                    args$name, args$paired)[is_paired]

  ## Here we can't use c() to pull args together but have to use rbind
  ## for the paired ones.  This bit of hackery depends crucially on
  ## the single pair rule.
  if (any(is_paired & multiple)) {
    pair <- sprintf("%s <- interleave(%s, %s)",
                    pair_from, pair_from, pair_to)
    vars <- setdiff(args$name, pair_to)
  } else {
    pair <- NULL
    vars <- args$name
  }

  run <- sprintf("self$context$run(c(%s))",
                 paste(c(dquote(name), vars), collapse=", "))

  ## TODO: Need to deal with enums?

  fn_body <- paste(indent(c(check, pair, run)), collapse="\n")
  fmt <- "%s=function(%s) {\n%s\n}"
  sprintf(fmt, tolower(name), fn_args, fn_body)
}

read_commands <- function() {
  cmds <- jsonlite::fromJSON("redis-doc/commands.json")
  cmds_ok <- jsonlite::fromJSON("supported.json")
  cmds <- cmds[sort(cmds_ok)]

  ## Now, go through and get the extra doc:
  ## for (i in names(cmds)) {
  ##   p <- sprintf("redis-doc/commands/%s.md", tolower(i))
  ##   if (file.exists(p)) {
  ##     cmds[[i]]$description <- paste(readLines(p), collapse="\n")
  ##   }
  ## }
  cmds
}

generate <- function(cmds) {
  template <- '## Automatically generated: do not edit by hand
rlite_generator <- R6::R6Class(
  "rlite",
  public=list(
    context=NULL,
{{{methods}}},
    initialize=function(context) {
      self$context <- context
    },
    close=function() {
      self$context$close()
    },
    is_closed=function() {
      self$context$is_closed()
    },
    reopen=function() {
      self$context$reopen()
    }))'

  args <- lapply(cmds, function(x) as.data.frame(x$arguments))
  dat <- vcapply(names(args), function(x) hirlite_cmd(x, args[[x]]),
                 USE.NAMES=FALSE)
  str <- paste(reindent(dat, 4), collapse=",\n")
  whisker::whisker.render(template, list(methods=str))
}
