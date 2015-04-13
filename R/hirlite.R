##' Create an hirlite object
##' @title Create an hirlite object
##' @param path Path to a persistent object or the magic string
##' \code{":memory:"} for an in-memory database.
##' @export
##' @importFrom R6 R6Class
##' @importFrom RedisAPI redis_api
##' @examples
##' r <- hirlite()
##' r$SET("foo", "bar")
##' r$GET("foo")
hirlite <- function(path=":memory:") {
  redis_api(rlite_context(path))
}
