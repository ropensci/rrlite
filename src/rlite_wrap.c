#include "rlite_wrap.h"
#include <hirlite.h>

void rlite_noop(const char * ip, int port) {
  rliteContext *context = rliteConnect(ip, port);
  rliteFree(context);
}
