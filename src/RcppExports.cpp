// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// test_rlite_noop
void test_rlite_noop(std::string ip, int port);
RcppExport SEXP rrlite_test_rlite_noop(SEXP ipSEXP, SEXP portSEXP) {
BEGIN_RCPP
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< std::string >::type ip(ipSEXP );
        Rcpp::traits::input_parameter< int >::type port(portSEXP );
        test_rlite_noop(ip, port);
    }
    return R_NilValue;
END_RCPP
}
// test_rlite_add
void test_rlite_add(std::string ip);
RcppExport SEXP rrlite_test_rlite_add(SEXP ipSEXP) {
BEGIN_RCPP
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< std::string >::type ip(ipSEXP );
        test_rlite_add(ip);
    }
    return R_NilValue;
END_RCPP
}
