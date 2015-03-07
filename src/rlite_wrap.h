// I can't directly include the Rcpp code because of either C99
// features that the compiler grumbles about or function pointers.
//
// Pushing the handle to the database to be stored as a pointer on the
// C++/R side (via XPtr<rliteContext>) requires some type erasure if
// we can't include all of hirlite.h in C++ code.
//
// For now we'll just open and close the database each time, which
// might suffer a performance cost, but should also simplify the code.
//
// Without providing a handle though, it's not possible to create
// persistent memory databases.  That's not great, but whatever for
// now; getting things in and out is the main aim.
#include <Rinternals.h> // SEXP

#ifdef __cplusplus
extern "C" {
#endif

  void rlite_noop(const char * ip, int port);
  // void rlite_add(const char * ip);
  void rlite_test_add(const char * ip);
  // void rlite_test_write(const char * ip);
  SEXP rlite_test_db(const char * filename);

  SEXP rlite_read(const char* filename);
  SEXP rlite_write(const char* filename, SEXP command);

#ifdef __cplusplus
} // closing brace for extern "C"
#endif
