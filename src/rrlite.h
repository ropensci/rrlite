#include <R.h>
#include <Rinternals.h> // SEXP
#include <hirlite.h>

rliteContext* rrlite_get_context(SEXP extPtr);
SEXP rrlite_context(SEXP filename);
static void rrlite_finalize(SEXP extPtr);
SEXP rrlite_write(SEXP extPtr, SEXP command);
SEXP rrlite_read(SEXP extPtr);

// Internal use:
SEXP rrlite_get_reply(rliteContext *context);
SEXP rrlite_reply_to_sexp(rliteReply *reply);
