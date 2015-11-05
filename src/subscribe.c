#include "subscribe.h"

SEXP rrlite_rlite_subscribe(SEXP extPtr, SEXP channel, SEXP pattern,
                           SEXP callback, SEXP envir) {
  error("subscribe() is not supported with this interface");
  return R_NilValue;
}

SEXP rrlite_rlite_unsubscribe(SEXP extPtr, SEXP channel, SEXP pattern) {
  // Because this function will be called in an on.exit it should not
  // throw.
  return R_NilValue;
}
