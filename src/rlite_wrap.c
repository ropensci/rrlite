#include "rlite_wrap.h"
#include <hirlite.h>
#include <R.h>

// From rlite/test/add.c
static int populateArgvlen(char *argv[], size_t argvlen[]) {
  int i;
  for (i = 0; argv[i] != NULL; i++) {
    argvlen[i] = strlen(argv[i]);
  }
  return i;
}

void rlite_noop(const char * ip, int port) {
  rliteContext *context = rliteConnect(ip, port);
  rliteFree(context);
}

// This is taken from the tests.  It's really not pretty.
void rlite_test_add(const char *ip) {
  rliteContext *context = rliteConnect(ip, 0);
  rliteReply* reply;

  char* argv[100] = {"sadd", "myset", "member1", "member2",
                     "anothermember", "member1", NULL};
  size_t argvlen[100];
  int len = populateArgvlen(argv, argvlen);

  reply = rliteCommandArgv(context, len, argv, argvlen);
  if (reply->type != RLITE_REPLY_INTEGER) {
    Rprintf("Expected reply to be INTEGER, got %d instead on line %d\n",
            reply->type, __LINE__);
  }

  if (reply->integer != 3) {
    Rprintf("Expected reply to be %d, got %lld instead on line %d\n",
            3, reply->integer, __LINE__);
  }
  rliteFreeReplyObject(reply);

  rliteFree(context);
}
