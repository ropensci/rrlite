cleanup <- function() {
  files <- c("test.rld")
  file.remove(files[file.exists(files)])
}
