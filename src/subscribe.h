// Automatically generated from redux:src/subscribe.h: do not edit by hand
#include "connection.h"
SEXP rrlite_rlite_subscribe(SEXP extPtr, SEXP channel, SEXP pattern,
                           SEXP list, SEXP envir);
SEXP rrlite_rlite_unsubscribe(SEXP extPtr, SEXP channel, SEXP pattern);
void rrlite_rlite_subscribe_loop(rliteContext* context,
                                int pattern, SEXP callback, SEXP envir);
