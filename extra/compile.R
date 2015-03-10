#!/usr/bin/env Rscript
path_R <- "../R"
source("compile_fun.R")
source(file.path(path_R, "util.R")) # vcapply, viapply

if (!file.exists("redis-doc")) {
  system("git clone https://github.com/antirez/redis-doc")
}

cmds <- read_commands()
writeLines(generate(cmds), file.path(path_R, "rlite_generated.R"))
save(cmds, file=file.path(path_R, "sysdata.rda"))
