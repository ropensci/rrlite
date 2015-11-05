// Automatically generated from redux:src/registration.c: do not edit by hand
#include "connection.h"
#include "conversions.h"
#include "subscribe.h"
#include <R_ext/Rdynload.h>

static const R_CallMethodDef callMethods[] = {
  {"Crrlite_rlite_connect",       (DL_FUNC) &rrlite_rlite_connect,        2},
  {"Crrlite_rlite_connect_unix",  (DL_FUNC) &rrlite_rlite_connect_unix,   1},

  {"Crrlite_rlite_command",       (DL_FUNC) &rrlite_rlite_command,        2},

  {"Crrlite_rlite_pipeline",      (DL_FUNC) &rrlite_rlite_pipeline,       2},

  {"Crrlite_rlite_subscribe",     (DL_FUNC) &rrlite_rlite_subscribe,      5},
  {"Crrlite_rlite_unsubscribe",   (DL_FUNC) &rrlite_rlite_unsubscribe,    3},

  {NULL,                         NULL,                                  0}
};

void R_init_rrlite(DllInfo *info) {
  R_registerRoutines(info, NULL, callMethods, NULL, NULL);
}
