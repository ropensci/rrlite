#include "rlite_wrap.h"
#include "rlite_wrap_internals.h"
#include <hirlite.h>
#include <R.h>
#include <Rinternals.h>

#define PORT 0

// From rlite/test/add.c
int populateArgvlen(char *argv[], size_t argvlen[]) {
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

SEXP rlite_test_db(const char * filename) {
  rliteContext *context = rliteConnect(filename, 0);

  rliteReply* reply;
  size_t argvlen[100];
  SEXP ret;

  {
    char* argv[100] = {"set", "key1", "mydata", NULL};
    reply = rliteCommandArgv(context, populateArgvlen(argv, argvlen), argv, argvlen);

    // reply, string, strlen
    // EXPECT_STATUS(reply, "OK", 2);
    Rprintf("OK?: %s\n", reply->str);
    PROTECT(ret = reply_to_sexp(reply));
    rliteFreeReplyObject(reply);
  }

  {
    char* argv[100] = {"set", "key2", "otherdata", NULL};
    reply = rliteCommandArgv(context, populateArgvlen(argv, argvlen), argv, argvlen);
    // EXPECT_STATUS(reply, "OK", 2);
    Rprintf("OK?: %s\n", reply->str);
    rliteFreeReplyObject(reply);
  }

  {
    char* argv[100] = {"keys", "*", NULL};
    reply = rliteCommandArgv(context, populateArgvlen(argv, argvlen), argv, argvlen);
  /*   EXPECT_LEN(reply, 2); */
  /*   EXPECT_STR(reply->element[0], "key1", 4); */
  /*   EXPECT_STR(reply->element[1], "key2", 4); */
    rliteFreeReplyObject(reply);
  }

  {
    char* argv[100] = {"keys", "*1", NULL};
    reply = rliteCommandArgv(context, populateArgvlen(argv, argvlen), argv, argvlen);
  /*   EXPECT_LEN(reply, 1); */
  /*   EXPECT_STR(reply->element[0], "key1", 4); */
    rliteFreeReplyObject(reply);
  }

  rliteFree(context);
  UNPROTECT(1);
  return ret;
}

// TODO: here and elsewhere swap "filename" for some more generic
// container of data for a database.
//   - filename (or :memory:)
//   - pointer, which might be NULL or invalid if the connection is
//     stale (testing that is hard, but we get NULL on rds
//     save/load).
// Store *that* in a reference class.
SEXP rlite_write(const char* filename, SEXP command) {
  rliteContext *context = rliteConnect(filename, 0);
  int argc = LENGTH(command);
  // R-exts: All of these memory allocation routines do their own
  // error-checking, so the programmer may assume that they will raise
  // an error and not return if the memory cannot be allocated.
  char** argv = (char**)R_alloc(argc, sizeof(char*));
  size_t* argvlen = (size_t*)R_alloc(argc, sizeof(size_t));
  if (!context) {
    error("context failure\n");
  }
  for (int i = 0; i < argc; ++i) {
    const char* cmd_r = CHAR(STRING_ELT(command, i));
    argvlen[i] = strlen(cmd_r);
    argv[i] = (char*)R_alloc(argc, sizeof(char));
    strcpy(argv[i], cmd_r);
  }

  rliteAppendCommandArgv(context, argc, argv, argvlen);
  rliteFree(context);

  return R_NilValue;
}

SEXP rlite_get_reply(rliteContext *context) {
  void *reply = NULL;
  /* Try to read pending replies */
  if (rliteGetReply(context, &reply) == RLITE_ERR) {
    /* Protocol error */
    // this *really* should flag an error - see note in reply_to_value
    // about what should really happen here.
    error("error reading reply");
    return R_NilValue;
  }

  /* Set reply object */
  if (reply) {
    return reply_to_sexp(reply);
  } else {
    return R_NilValue;
  }
}

SEXP rlite_read(const char* filename) {
  rliteContext *context = rliteConnect(filename, PORT);
  // TODO: here, and elsewhere, run
  // if (!context) {
  //   ... handle failure to connect.
  // }
  SEXP ret;
  PROTECT(ret = rlite_get_reply(context));
  rliteFree(context);
  UNPROTECT(1);
  return ret;
}

// TODO:
//  - parent_context_raise (throw and clean-up context)
//  - rlite_generic_connect
//  - rlite_connect
//  - rlite_connect_unix
//  - rlite_is_connected
//  - rlite_disconnect (requires having a real object)
//  - rlite_set_timeout
//  - rlite_fileno
