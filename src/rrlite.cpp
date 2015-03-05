#include <Rcpp.h>
#include "rlite_wrap.h"

// [[Rcpp::export]]
void test_rlite_noop(std::string ip, int port) {
  rlite_noop(ip.c_str(), port);
}
