#include <Rcpp.h>
#include "rlite_wrap.h"

// [[Rcpp::export]]
void test_rlite_noop(std::string ip, int port) {
  rlite_noop(ip.c_str(), port);
}

// [[Rcpp::export]]
void test_rlite_add(std::string ip) {
  rlite_test_add(ip.c_str());
}
