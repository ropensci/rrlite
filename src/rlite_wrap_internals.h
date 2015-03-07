#include <Rinternals.h>
#include <hirlite.h>
SEXP reply_to_sexp(rliteReply *reply);
int sexp_to_args(SEXP command, char** argv, size_t* alen);
