#include "connection.h"
#include "conversions.h"
#include <R_ext/Rdynload.h>

static const R_CallMethodDef callMethods[] = {
  {"Crrlite_rlite_connect",       (DL_FUNC) &rrlite_rlite_connect,        2},
  {"Crrlite_rlite_connect_unix",  (DL_FUNC) &rrlite_rlite_connect_unix,   1},

  {"Crrlite_rlite_command",       (DL_FUNC) &rrlite_rlite_command,        2},

  {"Crrlite_rlite_pipeline",      (DL_FUNC) &rrlite_rlite_pipeline,       2},

  {NULL,                          NULL,                                   0}
};

void R_init_rrlite(DllInfo *info) {
  R_registerRoutines(info, NULL, callMethods, NULL, NULL);
}
