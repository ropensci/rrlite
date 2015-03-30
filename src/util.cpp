// DataFrame to rows:
#include <Rcpp.h>

// This is *really* simple minded, and focussed on the use case here:
// break up the data.frame into a set of lists.
// [[Rcpp::export]]
Rcpp::List df_to_rows(Rcpp::DataFrame d) {
  const size_t
    nr = static_cast<size_t>(d.nrows()),
    nc = static_cast<size_t>(d.size());
  std::vector<Rcpp::List> cols(nc);
  for (size_t i = 0; i < nc; ++i) {
    cols[i] = Rcpp::as<Rcpp::List>(d[i]);
  }

  Rcpp::List ret(nr);
  for (size_t i = 0; i < nr; ++i) {
    Rcpp::List el(nc);
    for (size_t j = 0; j < nc; ++j) {
      el[j] = cols[j][i];
    }
    ret[i] = el;
  }
  return ret;
}
