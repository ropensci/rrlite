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

// [[Rcpp::export]]
SEXP test_rlite_db(std::string filename) {
  return rlite_test_db(filename.c_str());
}

// [[Rcpp::export]]
void test_rlite_write(std::string filename, SEXP command) {
  rlite_write(filename.c_str(), command);
}

// [[Rcpp::export]]
SEXP test_rlite_read(std::string filename) {
  return rlite_read(filename.c_str());
}
