#include <R.h>
#include <Rinternals.h> // SEXP
#include <hirlite.h>

// TODO: enum?
#define CLOSED_PASS 0
#define CLOSED_WARN 1
#define CLOSED_ERROR 2

rliteContext* rrlite_get_context(SEXP extPtr, int closed_action);
SEXP rrlite_context(SEXP filename);
static void rrlite_finalize(SEXP extPtr);
SEXP rrlite_write(SEXP extPtr, SEXP command);
SEXP rrlite_read(SEXP extPtr);

// Internal use:
SEXP rrlite_get_reply(rliteContext *context);
SEXP rrlite_reply_to_sexp(rliteReply *reply);
