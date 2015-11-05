// Automatically generated from redux:src/connection.h: do not edit by hand
#include <R.h>
#include <Rinternals.h>
#include <hirlite.h>

#define CLOSED_PASS 0
#define CLOSED_WARN 1
#define CLOSED_ERROR 2

SEXP rrlite_rlite_connect(SEXP host, SEXP port);
SEXP rrlite_rlite_connect_unix(SEXP path);

SEXP rrlite_rlite_command(SEXP extPtr, SEXP cmd);

SEXP rrlite_rlite_pipeline(SEXP extPtr, SEXP list);

rliteContext* redis_get_context(SEXP extPtr, int closed_action);
