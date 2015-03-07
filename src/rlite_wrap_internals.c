// Bits for doing data wrangling.  Not very nice!
#include "rlite_wrap_internals.h"

// This is directly modified from rlite.c
SEXP reply_to_sexp(rliteReply *reply) {
  if (reply->type == RLITE_REPLY_STATUS || reply->type == RLITE_REPLY_STRING) {
    return mkString(reply->str);
  }
  if (reply->type == RLITE_REPLY_NIL) {
    return R_NilValue;
  }
  if (reply->type == RLITE_REPLY_INTEGER) {
    // TODO: may overflow; could use double for more space?
    return ScalarInteger(reply->integer);
  }
  if (reply->type == RLITE_REPLY_ERROR) {
    // TODO: This is going to make things unsafe to use from C++,
    // because of the longjmp problem.  Defer worrying about that
    // until it turns out that's actually how we're going to drive
    // things.
    //
    // Other options are to return something that evaluates to an
    // error (e.g. an object with an error class).
    error(reply->str);
    return R_NilValue;
  }
  if (reply->type == RLITE_REPLY_ARRAY) {
    SEXP v;
    size_t i;
    PROTECT(v = allocVector(VECSXP, reply->elements));
    for (i = 0; i < reply->elements; ++i) {
      SET_VECTOR_ELT(v, i, reply_to_sexp(reply->element[i]));
    }
    UNPROTECT(1);
    return v;
  }
  return R_NilValue;
}
