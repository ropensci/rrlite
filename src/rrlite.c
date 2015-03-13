#include "rrlite.h"

#define PORT 0

// TODO:
//  - rlite_generic_connect
//  - rlite_connect
//  - rlite_connect_unix
//  - rlite_is_connected
//  - rlite_disconnect (requires having a real object)
//  - rlite_set_timeout
//  - rlite_fileno

static void rrlite_finalize(SEXP extPtr);

SEXP is_null_pointer(SEXP extPtr) {
  return ScalarLogical(R_ExternalPtrAddr(extPtr) == NULL);
}

rliteContext* rrlite_get_context(SEXP extPtr, int closed_action) {
  void *context = NULL;
  if (extPtr != R_NilValue) {
    context = (rliteContext*)R_ExternalPtrAddr(extPtr);
  }
  if (!context) {
    if (closed_action == CLOSED_WARN) {
      warning("Context is not connected");
    } else if (closed_action == CLOSED_ERROR) {
      error("Context is not connected");
    }
  }
  return context;
}

SEXP rrlite_context(SEXP filename) {
  const char * filename_c = CHAR(STRING_ELT(filename, 0));
  rliteContext *context = rliteConnect(filename_c, PORT);
  SEXP extPtr;
  PROTECT(extPtr = R_MakeExternalPtr(context, filename, R_NilValue));
  R_RegisterCFinalizer(extPtr, rrlite_finalize);
  UNPROTECT(1);
  return extPtr;
}

static void rrlite_finalize(SEXP extPtr) {
  rliteContext *context = rrlite_get_context(extPtr, CLOSED_PASS);
  if (context) {
    rliteFree(context);
  }
}

SEXP rrlite_close(SEXP extPtr) {
  rliteContext *context = rrlite_get_context(extPtr, CLOSED_WARN);
  int was_open = 0;
  if (context) {
    was_open = 1;
    rliteFree(context);
    R_ClearExternalPtr(extPtr);
  }
  return ScalarLogical(was_open);
}

SEXP rrlite_write(SEXP extPtr, SEXP command) {
  rliteContext *context = rrlite_get_context(extPtr, CLOSED_ERROR);
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
    argv[i] = (char*)R_alloc(argvlen[i] + 1, sizeof(char));
    strcpy(argv[i], cmd_r);
  }

  rliteAppendCommandArgv(context, argc, argv, argvlen);

  return R_NilValue;
}

SEXP rrlite_read(SEXP extPtr) {
  return rrlite_get_reply(rrlite_get_context(extPtr, CLOSED_ERROR));
}

SEXP rrlite_filename(SEXP extPtr) {
  return R_ExternalPtrTag(extPtr);
}

// TODO: I'd like to return a list of length 2: the data and the
// context I think.
SEXP rrlite_get_reply(rliteContext *context) {
  void *reply = NULL;
  /* Try to read pending replies */
  if (rliteGetReply(context, &reply) == RLITE_ERR) {
    /* Protocol error */
    error("error reading reply");
    return R_NilValue;
  }

  /* Set reply object */
  if (reply) {
    return rrlite_reply_to_sexp(reply);
  } else {
    return R_NilValue;
  }
}

// This is directly modified from rlite.c
// TODO: Is it worth returning this as a list of length 2, so that the
// class is added to the output?  This needs doing carefully for the
// recursive case.
SEXP rrlite_reply_to_sexp(rliteReply *reply) {
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
      SET_VECTOR_ELT(v, i, rrlite_reply_to_sexp(reply->element[i]));
    }
    UNPROTECT(1);
    return v;
  }
  return R_NilValue;
}
