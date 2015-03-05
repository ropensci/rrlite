#ifdef __cplusplus
extern "C" {
#endif

// I can't directly include the Rcpp code because of either C99
// features that the compiler grumbles about or function pointers.
//
// Pushing the handle to the database to be stored as a pointer on the
// C++/R side (via XPtr<rliteContext>) requires some type erasure if
// we can't include all of hirlite.h in C++ code.
//
// For now we'll just open and close the database each time, which
// might suffer a performance cost, but should also simplify the code.
void rlite_noop(const char * ip, int port);

#ifdef __cplusplus
} // closing brace for extern "C"
#endif
