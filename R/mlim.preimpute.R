
#' @title carries out preimputation
#' @description instead of replacing missing data with mean and mode, a smarter
#'              start-point would be to use fast imputation algorithms and then
#'              optimize the imputed dataset with mlim. this procedure usually
#'              requires less iterations and will savea lot of computation
#'              resources.
#' @importFrom VIM kNN
#' @importFrom missRanger missRanger imputeUnivariate
# @importFrom missForest missForest
#' @param data data.frame with missing values
#' @param preimpute character. specify the algorithm for preimputation. the
#'                  supported options are "kNN", "ranger", "missForest", and "mm"
#'                  (mean-mode replacement). "ranger" and "missForest" both
#'                  implement Random Forest procedures and are generally
#'                  recommended. For very large datasets use "kNN".
#' @param report filename. if a filename is specified, the \code{"md.log"} R
#'               package is used to generate a Markdown progress report for the
#'               imputation. the format of the report is adopted based on the
#'               \code{'verbosity'} argument. the higher the verbosity, the more
#'               technical the report becomes. if verbosity equals "debug", then
#'               a log file is generated, which includes time stamp and shows
#'               the function that has generated the message. otherwise, a
#'               reduced markdown-like report is generated.
#' @return imputed data.frame
#' @author E. F. Haghish
#' @keywords Internal
#' @noRd

mlim.preimpute <- function(data, preimpute, seed = NULL,
                           report = NULL, debug=FALSE) {

  if (tolower(preimpute) == "knn") {
    set.seed(seed)
    data <- VIM::kNN(data, imp_var=FALSE)
    if (!is.null(report)) md.log("kNN preimputation is done", date=debug, time=debug, trace=FALSE)
  }
  else if (tolower(preimpute) == "rf") {
    set.seed(seed)
    #data <- missForest::missForest(data)$ximp
    data <- missRanger::missRanger(data, seed = seed)
    if (!is.null(report)) md.log("RF preimputation is done", date=debug, time=debug, trace=FALSE)
  }
  #else if (tolower(preimpute) == "ranger") {
  #  data <- missRanger::missRanger(data, seed = seed)
  #  if (!is.null(report)) md.log("missRanger preimputation is done", date=debug, time=debug, trace=FALSE)
  #}
  else if (tolower(preimpute) == "mm") {
    data <- meanmode(data)
    if (!is.null(report)) md.log("Mean/Mode preimputation is done", date=debug, time=debug, trace=FALSE)
  }
  else stop(paste(preimpute, "is not recognized preimputation argument"))

  return(data)
}


